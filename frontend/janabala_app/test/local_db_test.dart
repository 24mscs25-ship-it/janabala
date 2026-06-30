import "package:flutter_test/flutter_test.dart";
import "package:janabala_app/models/constituency.dart";
import "package:janabala_app/models/enums.dart";
import "package:janabala_app/models/issue.dart";
import "package:janabala_app/services/local_db.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

Issue pending(String clientId, String title,
        {IssueCategory cat = IssueCategory.water,
        IssueStatus status = IssueStatus.open}) =>
    Issue(
      clientId: clientId,
      category: cat,
      title: title,
      urgency: Urgency.low,
      status: status,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      syncState: SyncState.pendingCreate,
    );

Issue server(String id, String title,
        {IssueCategory cat = IssueCategory.water,
        IssueStatus status = IssueStatus.open,
        String? constituencyId}) =>
    Issue(
      id: id,
      constituencyId: constituencyId,
      category: cat,
      title: title,
      urgency: Urgency.low,
      status: status,
      createdAt: DateTime.parse("2026-01-01T00:00:00Z"),
      updatedAt: DateTime.parse("2026-01-01T00:00:00Z"),
      syncState: SyncState.synced,
    );

void main() {
  late LocalDb db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    LocalDb.dbPathOverride = inMemoryDatabasePath;
    db = LocalDb.instance;
  });

  setUp(() async {
    await db.clearAll();
  });

  test("insertPending shows in queue and pendingCount", () async {
    await db.insertPending(pending("c1", "offline issue"));
    expect(await db.pendingCount(), 1);
    final q = await db.getPending();
    expect(q.single.title, "offline issue");
    expect(q.single.isPending, isTrue);
  });

  test("markPushed removes the pending row and inserts synced server row",
      () async {
    await db.insertPending(pending("c1", "to push"));
    final queued = (await db.getPending()).single;
    // simulate fetching local_id like SyncService does
    final raw = await (await db.database).query("issues",
        columns: ["local_id"], where: "client_id = ?", whereArgs: ["c1"]);
    final localId = raw.first["local_id"] as int;

    await db.markPushed(localId, server("srv-1", "to push"));

    expect(await db.pendingCount(), 0);
    final all = await db.queryIssues();
    expect(all.where((i) => i.title == "to push").length, 1,
        reason: "no duplicate after push");
    expect(all.single.id, "srv-1");
    expect(all.single.isPending, isFalse);
    expect(queued.clientId, "c1");
  });

  test("upsertServerIssue is idempotent on server id", () async {
    await db.upsertServerIssue(server("srv-1", "v1"));
    await db.upsertServerIssue(server("srv-1", "v2-updated"));
    final all = await db.queryIssues();
    expect(all.length, 1, reason: "same id upserts, not duplicates");
    expect(all.single.title, "v2-updated");
  });

  test("upsert does not clobber pending local rows", () async {
    await db.insertPending(pending("c1", "my offline"));
    await db.upsertServerIssues([server("srv-1", "someone elses")]);
    final all = await db.queryIssues();
    expect(all.length, 2);
    expect(await db.pendingCount(), 1);
  });

  test("queryIssues filters by category and status", () async {
    await db.upsertServerIssues([
      server("1", "road issue", cat: IssueCategory.roads),
      server("2", "water issue", cat: IssueCategory.water),
      server("3", "resolved water",
          cat: IssueCategory.water, status: IssueStatus.resolved),
    ]);
    final water = await db.queryIssues(category: IssueCategory.water.wire);
    expect(water.length, 2);
    final resolvedWater = await db.queryIssues(
        category: IssueCategory.water.wire, status: IssueStatus.resolved.wire);
    expect(resolvedWater.single.title, "resolved water");
  });

  test("queryIssues filters by constituency", () async {
    await db.upsertServerIssues([
      server("1", "a", constituencyId: "k1"),
      server("2", "b", constituencyId: "k2"),
    ]);
    final k1 = await db.queryIssues(constituencyId: "k1");
    expect(k1.single.title, "a");
  });

  test("getIssueById returns null for unknown", () async {
    expect(await db.getIssueById("nope"), isNull);
    await db.upsertServerIssue(server("srv-1", "exists"));
    expect((await db.getIssueById("srv-1"))!.title, "exists");
  });

  test("meta cursor get/set persists", () async {
    expect(await db.getMeta("sync.since"), isNull);
    await db.setMeta("sync.since", "2026-01-01T00:00:00.000Z");
    expect(await db.getMeta("sync.since"), "2026-01-01T00:00:00.000Z");
    await db.setMeta("sync.since", "2026-02-01T00:00:00.000Z");
    expect(await db.getMeta("sync.since"), "2026-02-01T00:00:00.000Z");
  });

  test("constituencies upsert + ordered read", () async {
    await db.upsertConstituencies([
      Constituency(id: "2", name: "Mysuru", code: "MYS"),
      Constituency(id: "1", name: "Ballari", code: "BLR"),
    ]);
    final list = await db.getConstituencies();
    expect(list.map((c) => c.name).toList(), ["Ballari", "Mysuru"]);
  });

  test("pending queue preserves FIFO order", () async {
    await db.insertPending(pending("c1", "first"));
    await db.insertPending(pending("c2", "second"));
    await db.insertPending(pending("c3", "third"));
    final q = await db.getPending();
    expect(q.map((i) => i.title).toList(), ["first", "second", "third"]);
  });
}
