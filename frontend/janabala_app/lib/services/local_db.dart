import "dart:io";

import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";
import "package:sqflite/sqflite.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

import "../models/constituency.dart";
import "../models/issue.dart";

/// Local SQLite mirror of server issues plus an outbound queue for issues
/// created while offline. A single `issues` table holds both: rows with
/// sync_state = 'pendingCreate' are the queue; 'synced' rows mirror the server.
class LocalDb {
  LocalDb._();
  static final LocalDb instance = LocalDb._();

  /// Test hook: when set (e.g. to inMemoryDatabasePath), bypasses
  /// path_provider so the DB can run in a headless test environment.
  static String? dbPathOverride;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  /// Initialize the correct sqflite factory for the platform. Desktop/tests use
  /// FFI; mobile uses the default plugin.
  static void init() {
    if (!_isMobile) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  static bool get _isMobile => Platform.isAndroid || Platform.isIOS;

  Future<Database> _open() async {
    if (dbPathOverride != null) {
      return databaseFactory.openDatabase(
        dbPathOverride!,
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
      );
    }
    String dbPath;
    if (_isMobile) {
      dbPath = p.join(await getDatabasesPath(), "janabala.db");
    } else {
      final dir = await getApplicationSupportDirectory();
      dbPath = p.join(dir.path, "janabala.db");
    }
    return databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE issues (
        local_id INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT UNIQUE,
        client_id TEXT,
        user_id TEXT,
        constituency_id TEXT,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        latitude REAL,
        longitude REAL,
        photo_urls TEXT,
        urgency TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT,
        updated_at TEXT,
        sync_state TEXT NOT NULL DEFAULT 'synced'
      )
    """);
    await db.execute("CREATE INDEX idx_issues_status ON issues(status)");
    await db.execute("CREATE INDEX idx_issues_category ON issues(category)");
    await db.execute("CREATE INDEX idx_issues_sync ON issues(sync_state)");
    await db.execute("""
      CREATE TABLE constituencies (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT,
        district TEXT,
        state TEXT
      )
    """);
    await db.execute("""
      CREATE TABLE meta (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    """);
  }

  // ---- Issues ----

  Future<int> insertPending(Issue issue) async {
    final db = await database;
    return db.insert("issues", issue.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Upserts a server issue keyed on its server [id], preserving local pending
  /// rows (those have no server id).
  Future<void> upsertServerIssue(Issue issue) async {
    final db = await database;
    await db.insert("issues", issue.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> upsertServerIssues(List<Issue> issues) async {
    final db = await database;
    final batch = db.batch();
    for (final issue in issues) {
      batch.insert("issues", issue.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Issue>> getPending() async {
    final db = await database;
    final rows = await db.query("issues",
        where: "sync_state = ?",
        whereArgs: [SyncState.pendingCreate.name],
        orderBy: "local_id ASC");
    return rows.map(Issue.fromDb).toList();
  }

  Future<int> pendingCount() async {
    final db = await database;
    final rows = await db.rawQuery(
        "SELECT COUNT(*) c FROM issues WHERE sync_state = ?",
        [SyncState.pendingCreate.name]);
    return Sqflite.firstIntValue(rows) ?? 0;
  }

  /// Replaces a pending row (by its local autoincrement id) with the synced
  /// server version. Done in a txn so a queued item is never both pending and
  /// duplicated.
  Future<void> markPushed(int localId, Issue serverIssue) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete("issues", where: "local_id = ?", whereArgs: [localId]);
      await txn.insert("issues", serverIssue.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<List<Issue>> queryIssues({
    String? constituencyId,
    String? category,
    String? status,
  }) async {
    final db = await database;
    final where = <String>[];
    final args = <Object?>[];
    if (constituencyId != null) {
      where.add("constituency_id = ?");
      args.add(constituencyId);
    }
    if (category != null) {
      where.add("category = ?");
      args.add(category);
    }
    if (status != null) {
      where.add("status = ?");
      args.add(status);
    }
    final rows = await db.query(
      "issues",
      where: where.isEmpty ? null : where.join(" AND "),
      whereArgs: args.isEmpty ? null : args,
      orderBy: "COALESCE(created_at, '') DESC, local_id DESC",
    );
    return rows.map(Issue.fromDb).toList();
  }

  Future<Issue?> getIssueById(String id) async {
    final db = await database;
    final rows =
        await db.query("issues", where: "id = ?", whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return Issue.fromDb(rows.first);
  }

  // ---- Constituencies ----

  Future<void> upsertConstituencies(List<Constituency> items) async {
    final db = await database;
    final batch = db.batch();
    for (final c in items) {
      batch.insert("constituencies", c.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Constituency>> getConstituencies() async {
    final db = await database;
    final rows = await db.query("constituencies", orderBy: "name ASC");
    return rows.map(Constituency.fromDb).toList();
  }

  // ---- Meta (sync cursor) ----

  Future<void> setMeta(String key, String value) async {
    final db = await database;
    await db.insert("meta", {"key": key, "value": value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getMeta(String key) async {
    final db = await database;
    final rows =
        await db.query("meta", where: "key = ?", whereArgs: [key], limit: 1);
    if (rows.isEmpty) return null;
    return rows.first["value"] as String?;
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete("issues");
    await db.delete("constituencies");
    await db.delete("meta");
  }
}

