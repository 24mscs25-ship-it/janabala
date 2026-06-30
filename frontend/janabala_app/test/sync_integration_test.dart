// Integration test against a LIVE backend at 127.0.0.1:8000.
// Run explicitly:  flutter test test/sync_integration_test.dart
// Skipped automatically if the backend is unreachable.

import "dart:async";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:janabala_app/models/enums.dart";
import "package:janabala_app/models/issue.dart";
import "package:janabala_app/services/api_client.dart";
import "package:janabala_app/services/local_db.dart";
import "package:janabala_app/services/sync_service.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "package:uuid/uuid.dart";

/// Fake connectivity we can flip between offline and online.
class FakeConnectivity implements Connectivity {
  final _ctl = StreamController<List<ConnectivityResult>>.broadcast();
  List<ConnectivityResult> _current = [ConnectivityResult.wifi];

  void goOnline() {
    _current = [ConnectivityResult.wifi];
    _ctl.add(_current);
  }

  void goOffline() {
    _current = [ConnectivityResult.none];
    _ctl.add(_current);
  }

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => _current;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _ctl.stream;

  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

Future<bool> _backendUp() async {
  try {
    final res = await http
        .get(Uri.parse("http://127.0.0.1:8000/api/v1/health"))
        .timeout(const Duration(seconds: 3));
    return res.statusCode == 200;
  } catch (_) {
    return false;
  }
}

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  LocalDb.dbPathOverride = inMemoryDatabasePath;

  test("offline create -> push exactly once -> pull reflects server", () async {
    if (!await _backendUp()) {
      markTestSkipped("backend not reachable at 127.0.0.1:8000");
      return;
    }

    final api = ApiClient(baseUrl: "http://127.0.0.1:8000/api/v1");

    // --- login via dev OTP ---
    const phone = "9111100001";
    final otp = await api.sendOtp(phone);
    expect(otp, isNotNull, reason: "backend must be in DEBUG to echo otp");
    final token = await api.verifyOtp(phone, otp!);
    expect(token, isNotEmpty);
    api.tokenProvider = () => token;

    // --- fresh in-memory-ish DB ---
    final db = LocalDb.instance;
    await db.clearAll();

    final conn = FakeConnectivity();
    final sync = SyncService(api, db, connectivity: conn);
    sync.authGuard = () => true;

    // --- create an issue OFFLINE (just write to local queue) ---
    final marker = "OFFLINE-${const Uuid().v4()}";
    final queued = Issue(
      clientId: const Uuid().v4(),
      category: IssueCategory.water,
      title: marker,
      description: "created offline",
      urgency: Urgency.high,
      status: IssueStatus.open,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      syncState: SyncState.pendingCreate,
    );
    await db.insertPending(queued);
    expect(await db.pendingCount(), 1);

    // --- come online and sync ---
    conn.goOnline();
    await sync.sync();

    // queue drained, item now synced with a server id
    expect(await db.pendingCount(), 0, reason: "queue must drain");
    final local = await db.queryIssues();
    final mine = local.where((i) => i.title == marker).toList();
    expect(mine.length, 1, reason: "exactly one local copy, no dup");
    expect(mine.first.id, isNotNull, reason: "now has server id");
    expect(mine.first.isPending, isFalse);

    // --- verify server side: exactly one issue with our marker ---
    final serverIssues = await api.listIssues(limit: 100);
    final serverMatches =
        serverIssues.where((i) => i.title == marker).toList();
    expect(serverMatches.length, 1,
        reason: "push must create exactly one server issue");

    // --- a second sync must NOT re-push (no new server rows) ---
    await sync.sync();
    final after = await api.listIssues(limit: 100);
    expect(after.where((i) => i.title == marker).length, 1,
        reason: "second sync must not duplicate");

    api.close();
  });
}

