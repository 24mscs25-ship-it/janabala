import "dart:async";
import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/foundation.dart";

import "../models/issue.dart";
import "api_client.dart";
import "local_db.dart";

enum SyncStatus { idle, syncing, offline, error }

/// Orchestrates offline-first sync:
///  - push each queued (pendingCreate) issue EXACTLY ONCE, marking it synced on
///    success (server is not idempotent on client_id, so we never re-push);
///  - pull issues updated since the last server_time and upsert locally;
///  - track server_time as the next `since` cursor.
class SyncService extends ChangeNotifier {
  SyncService(this._api, this._db, {Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  static const _cursorKey = "sync.since";

  final ApiClient _api;
  final LocalDb _db;
  final Connectivity _connectivity;

  SyncStatus _status = SyncStatus.idle;
  int _pending = 0;
  String? _lastError;
  bool _inFlight = false;

  SyncStatus get status => _status;
  int get pending => _pending;
  String? get lastError => _lastError;

  /// Whether the user is authenticated; sync needs a bearer token.
  bool Function()? authGuard;

  void start() {
    _connectivity.onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) {
        unawaited(sync());
      } else {
        _status = SyncStatus.offline;
        notifyListeners();
      }
    });
    unawaited(refreshPendingCount());
  }

  Future<void> refreshPendingCount() async {
    _pending = await _db.pendingCount();
    notifyListeners();
  }

  Future<bool> _isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Full sync pass: push queue (once each), then pull. Safe to call often;
  /// re-entrancy is guarded.
  Future<void> sync() async {
    if (_inFlight) return;
    if (authGuard != null && !authGuard!()) return;
    _inFlight = true;
    _status = SyncStatus.syncing;
    _lastError = null;
    notifyListeners();
    try {
      if (!await _isOnline()) {
        _status = SyncStatus.offline;
        return;
      }
      await _pushQueue();
      await _pull();
      _status = SyncStatus.idle;
    } on ApiException catch (e) {
      _lastError = e.message;
      _status = SyncStatus.error;
    } catch (e) {
      _lastError = e.toString();
      _status = SyncStatus.error;
    } finally {
      _inFlight = false;
      await refreshPendingCount();
      notifyListeners();
    }
  }

  /// Push each queued item individually so a mid-batch failure never causes a
  /// re-push of already-created items. Each success is committed immediately.
  Future<void> _pushQueue() async {
    final pending = await _db.getPending();
    for (final issue in pending) {
      final created = await _api.syncPush([issue]);
      if (created.isNotEmpty) {
        // local_id is the queue row identity; resolve it for this client_id.
        await _markByClientId(issue, created.first);
      }
    }
  }

  Future<void> _markByClientId(Issue queued, Issue serverIssue) async {
    // Re-read pending rows to find the local_id matching this client_id.
    final db = await _db.database;
    final rows = await db.query("issues",
        columns: ["local_id"],
        where: "sync_state = ? AND client_id = ?",
        whereArgs: [SyncState.pendingCreate.name, queued.clientId],
        limit: 1);
    if (rows.isEmpty) return;
    final localId = rows.first["local_id"] as int;
    await _db.markPushed(localId, serverIssue);
  }

  Future<void> _pull() async {
    final cursorStr = await _db.getMeta(_cursorKey);
    final since = cursorStr == null ? null : DateTime.tryParse(cursorStr);
    final result = await _api.syncPull(since: since);
    if (result.issues.isNotEmpty) {
      await _db.upsertServerIssues(result.issues);
    }
    await _db.setMeta(_cursorKey, result.serverTime.toUtc().toIso8601String());
  }
}

