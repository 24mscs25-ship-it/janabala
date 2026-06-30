import "dart:async";
import "package:flutter/foundation.dart";
import "package:uuid/uuid.dart";

import "../models/constituency.dart";
import "../models/enums.dart";
import "../models/issue.dart";
import "api_client.dart";
import "local_db.dart";
import "sync_service.dart";

/// Offline-first data access for issues. Reads from local SQLite first, then
/// refreshes from the API when online. New issues are written to the local
/// queue immediately and synced later by [SyncService].
class IssueRepository extends ChangeNotifier {
  IssueRepository(this._api, this._db, this._sync);

  final ApiClient _api;
  final LocalDb _db;
  final SyncService _sync;
  final _uuid = const Uuid();

  /// Local-first read with optional online refresh.
  Future<List<Issue>> getIssues({
    String? constituencyId,
    IssueCategory? category,
    IssueStatus? status,
    bool refresh = true,
  }) async {
    if (refresh) {
      try {
        final remote = await _api.listIssues(
          constituencyId: constituencyId,
          category: category?.wire,
          status: status?.wire,
          limit: 100,
        );
        await _db.upsertServerIssues(remote);
      } catch (_) {
        // Stay offline-capable: fall back to local data silently.
      }
    }
    return _db.queryIssues(
      constituencyId: constituencyId,
      category: category?.wire,
      status: status?.wire,
    );
  }

  Future<Issue?> getIssue(String id, {bool refresh = true}) async {
    if (refresh) {
      try {
        final remote = await _api.getIssue(id);
        await _db.upsertServerIssue(remote);
      } catch (_) {}
    }
    return _db.getIssueById(id);
  }

  /// Create an issue offline-first: write to the local queue immediately, then
  /// attempt a sync. Returns once the local row exists (does not block on net).
  Future<void> createIssue({
    required IssueCategory category,
    required String title,
    String? description,
    String? constituencyId,
    double? latitude,
    double? longitude,
    List<String>? photoUrls,
    required Urgency urgency,
  }) async {
    final now = DateTime.now().toUtc();
    final issue = Issue(
      clientId: _uuid.v4(),
      constituencyId: constituencyId,
      category: category,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      photoUrls: photoUrls,
      urgency: urgency,
      status: IssueStatus.open,
      createdAt: now,
      updatedAt: now,
      syncState: SyncState.pendingCreate,
    );
    await _db.insertPending(issue);
    await _sync.refreshPendingCount();
    notifyListeners();
    // Fire-and-forget sync; failures keep the item queued for next time.
    unawaited(_sync.sync());
  }

  // ---- Constituencies (local-first) ----

  Future<List<Constituency>> getConstituencies({bool refresh = true}) async {
    if (refresh) {
      try {
        final remote = await _api.listConstituencies();
        await _db.upsertConstituencies(remote);
      } catch (_) {}
    }
    return _db.getConstituencies();
  }
}

