import "dart:async";
import "dart:convert";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:janabala_app/models/enums.dart";
import "package:janabala_app/models/issue.dart";
import "package:janabala_app/services/api_client.dart";
import "package:janabala_app/services/local_db.dart";
import "package:janabala_app/services/sync_service.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

class FakeConnectivity implements Connectivity {
  final _ctl = StreamController<List<ConnectivityResult>>.broadcast();
  List<ConnectivityResult> current = [ConnectivityResult.wifi];

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => current;
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _ctl.stream;
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

Issue pending(String clientId, String title) => Issue(
      clientId: clientId,
      category: IssueCategory.water,
      title: title,
      urgency: Urgency.low,
      status: IssueStatus.open,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      syncState: SyncState.pendingCreate,
    );

/// Records every push and lets the test fail specific client_ids.
class PushRecorder {
  final List<String> pushedClientIds = [];
  final Set<String> failClientIds = {};
  int pullCount = 0;
  String serverTime = "2026-01-01T00:00:00Z";

  http.Response handle(http.Request req) {
    if (req.url.path.endsWith("/sync/push")) {
      final body = jsonDecode(req.body);
      final items = (body["issues"] as List);
      final created = <Map<String, dynamic>>[];
      for (final item in items) {
        final cid = item["client_id"] as String;
        if (failClientIds.contains(cid)) {
          return http.Response(jsonEncode({"detail": "boom"}), 500);
        }
        pushedClientIds.add(cid);
        created.add({
          "id": "srv-$cid",
          "client_id": cid,
          "category": item["category"],
          "title": item["title"],
          "urgency": item["urgency"],
          "status": "open",
          "created_at": "2026-01-01T00:00:00Z",
          "updated_at": "2026-01-01T00:00:00Z",
        });
      }
      return http.Response(
          jsonEncode({"created": created, "count": created.length}), 200);
    }
    if (req.url.path.endsWith("/sync/pull")) {
      pullCount++;
      return http.Response(
          jsonEncode({"issues": [], "server_time": serverTime, "count": 0}),
          200);
    }
    return http.Response("not found", 404);
  }
}

void main() {
  late LocalDb db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    LocalDb.dbPathOverride = inMemoryDatabasePath;
    db = LocalDb.instance;
  });

  setUp(() async => db.clearAll());

  ({SyncService sync, PushRecorder rec, FakeConnectivity conn}) build() {
    final rec = PushRecorder();
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((req) async => rec.handle(req)),
    );
    api.tokenProvider = () => "tok";
    final conn = FakeConnectivity();
    final sync = SyncService(api, db, connectivity: conn);
    sync.authGuard = () => true;
    return (sync: sync, rec: rec, conn: conn);
  }

  test("drains queue, pushes each item exactly once", () async {
    final b = build();
    await db.insertPending(pending("a", "one"));
    await db.insertPending(pending("b", "two"));

    await b.sync.sync();

    expect(b.rec.pushedClientIds, ["a", "b"]);
    expect(await db.pendingCount(), 0);
    expect(b.rec.pullCount, 1);
  });

  test("second sync does NOT re-push already-synced items", () async {
    final b = build();
    await db.insertPending(pending("a", "one"));
    await b.sync.sync();
    await b.sync.sync();
    await b.sync.sync();
    expect(b.rec.pushedClientIds, ["a"],
        reason: "exactly-once across repeated syncs");
  });

  test("partial failure: synced item stays synced, failed item retried once",
      () async {
    final b = build();
    await db.insertPending(pending("a", "ok"));
    await db.insertPending(pending("b", "will-fail"));
    b.rec.failClientIds.add("b");

    // First pass: a succeeds, b fails (throws out of push loop).
    await b.sync.sync();
    expect(b.rec.pushedClientIds, ["a"]);
    expect(await db.pendingCount(), 1, reason: "b still queued");

    // b recovers; second pass must push ONLY b, never re-push a.
    b.rec.failClientIds.clear();
    await b.sync.sync();
    expect(b.rec.pushedClientIds, ["a", "b"],
        reason: "a pushed once total, b pushed after recovery");
    expect(await db.pendingCount(), 0);
  });

  test("advances cursor to server_time and reuses it as next since", () async {
    final b = build();
    b.rec.serverTime = "2026-03-03T03:03:03Z";
    await b.sync.sync();
    expect(await db.getMeta("sync.since"),
        DateTime.parse("2026-03-03T03:03:03Z").toUtc().toIso8601String());
  });

  test("offline: status offline, nothing pushed", () async {
    final b = build();
    b.conn.current = [ConnectivityResult.none];
    await db.insertPending(pending("a", "one"));
    await b.sync.sync();
    expect(b.sync.status, SyncStatus.offline);
    expect(b.rec.pushedClientIds, isEmpty);
    expect(await db.pendingCount(), 1);
  });

  test("authGuard false short-circuits sync", () async {
    final b = build();
    b.sync.authGuard = () => false;
    await db.insertPending(pending("a", "one"));
    await b.sync.sync();
    expect(b.rec.pushedClientIds, isEmpty);
    expect(b.rec.pullCount, 0);
  });

  test("pendingCount notifier reflects queue", () async {
    final b = build();
    await db.insertPending(pending("a", "one"));
    await b.sync.refreshPendingCount();
    expect(b.sync.pending, 1);
    await b.sync.sync();
    expect(b.sync.pending, 0);
  });
}
