import "dart:convert";

import "enums.dart";

/// Local sync state for an issue/queue row.
enum SyncState {
  /// Mirrored from the server, no local pending changes.
  synced,

  /// Created locally, not yet pushed to the server.
  pendingCreate,
}

/// A civic issue. Used both as the API IssueResponse shape and the local
/// SQLite mirror row. Locally-created issues carry a [clientId] and live in
/// the outbound queue until pushed exactly once.
class Issue {
  Issue({
    this.id,
    this.clientId,
    this.userId,
    this.constituencyId,
    required this.category,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.photoUrls,
    required this.urgency,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.syncState = SyncState.synced,
  });

  /// Server UUID (null until pushed for locally-created issues).
  final String? id;

  /// Client-generated UUID for offline-created issues (dedup key candidate).
  final String? clientId;

  final String? userId;
  final String? constituencyId;
  final IssueCategory category;
  final String title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final List<String>? photoUrls;
  final Urgency urgency;
  final IssueStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SyncState syncState;

  bool get isPending => syncState == SyncState.pendingCreate;

  factory Issue.fromApi(Map<String, dynamic> json) {
    return Issue(
      id: json["id"] as String?,
      userId: json["user_id"] as String?,
      constituencyId: json["constituency_id"] as String?,
      category: IssueCategory.fromWire(json["category"] as String),
      title: json["title"] as String,
      description: json["description"] as String?,
      latitude: (json["latitude"] as num?)?.toDouble(),
      longitude: (json["longitude"] as num?)?.toDouble(),
      photoUrls: (json["photo_urls"] as List?)?.cast<String>(),
      urgency: Urgency.fromWire(json["urgency"] as String),
      status: IssueStatus.fromWire(json["status"] as String),
      createdAt: _parseDate(json["created_at"]),
      updatedAt: _parseDate(json["updated_at"]),
      syncState: SyncState.synced,
    );
  }

  /// Body for POST /issues and the items in POST /sync/push.
  Map<String, dynamic> toCreateJson({bool includeClientId = false}) {
    final map = <String, dynamic>{
      "category": category.wire,
      "title": title,
      "urgency": urgency.wire,
    };
    if (description != null) map["description"] = description;
    if (constituencyId != null) map["constituency_id"] = constituencyId;
    if (latitude != null) map["latitude"] = latitude;
    if (longitude != null) map["longitude"] = longitude;
    if (photoUrls != null && photoUrls!.isNotEmpty) {
      map["photo_urls"] = photoUrls;
    }
    if (includeClientId && clientId != null) map["client_id"] = clientId;
    return map;
  }

  Map<String, dynamic> toDb() {
    return {
      "id": id,
      "client_id": clientId,
      "user_id": userId,
      "constituency_id": constituencyId,
      "category": category.wire,
      "title": title,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "photo_urls": photoUrls == null ? null : jsonEncode(photoUrls),
      "urgency": urgency.wire,
      "status": status.wire,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "sync_state": syncState.name,
    };
  }

  factory Issue.fromDb(Map<String, dynamic> row) {
    return Issue(
      id: row["id"] as String?,
      clientId: row["client_id"] as String?,
      userId: row["user_id"] as String?,
      constituencyId: row["constituency_id"] as String?,
      category: IssueCategory.fromWire(row["category"] as String),
      title: row["title"] as String,
      description: row["description"] as String?,
      latitude: (row["latitude"] as num?)?.toDouble(),
      longitude: (row["longitude"] as num?)?.toDouble(),
      photoUrls: row["photo_urls"] == null
          ? null
          : (jsonDecode(row["photo_urls"] as String) as List).cast<String>(),
      urgency: Urgency.fromWire(row["urgency"] as String),
      status: IssueStatus.fromWire(row["status"] as String),
      createdAt: _parseDate(row["created_at"]),
      updatedAt: _parseDate(row["updated_at"]),
      syncState: SyncState.values.firstWhere(
        (s) => s.name == row["sync_state"],
        orElse: () => SyncState.synced,
      ),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value as String);
  }
}
