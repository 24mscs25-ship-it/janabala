import "package:flutter_test/flutter_test.dart";
import "package:janabala_app/models/constituency.dart";
import "package:janabala_app/models/enums.dart";
import "package:janabala_app/models/issue.dart";
import "package:janabala_app/models/user.dart";

void main() {
  group("enum wire mapping", () {
    test("all category values round-trip", () {
      for (final c in IssueCategory.values) {
        expect(IssueCategory.fromWire(c.wire), c);
      }
    });
    test("12 categories exist per contract", () {
      expect(IssueCategory.values.length, 12);
    });
    test("unknown wire falls back to safe defaults", () {
      expect(IssueCategory.fromWire("BOGUS"), IssueCategory.other);
      expect(Urgency.fromWire("BOGUS"), Urgency.low);
      expect(IssueStatus.fromWire("BOGUS"), IssueStatus.open);
    });
    test("status wire uses snake_case", () {
      expect(IssueStatus.inProgress.wire, "in_progress");
      expect(IssueStatus.fromWire("in_progress"), IssueStatus.inProgress);
    });
  });

  group("Issue.fromApi", () {
    test("parses a full IssueResponse", () {
      final issue = Issue.fromApi({
        "id": "abc",
        "user_id": "u1",
        "constituency_id": "c1",
        "category": "WATER",
        "title": "No water",
        "description": "3 days",
        "latitude": 12.97,
        "longitude": 77.59,
        "photo_urls": ["http://x/1.jpg", "http://x/2.jpg"],
        "urgency": "HIGH",
        "status": "in_progress",
        "created_at": "2026-01-01T10:00:00Z",
        "updated_at": "2026-01-02T10:00:00Z",
      });
      expect(issue.id, "abc");
      expect(issue.category, IssueCategory.water);
      expect(issue.urgency, Urgency.high);
      expect(issue.status, IssueStatus.inProgress);
      expect(issue.latitude, closeTo(12.97, 1e-9));
      expect(issue.photoUrls, hasLength(2));
      expect(issue.syncState, SyncState.synced);
      expect(issue.isPending, isFalse);
    });

    test("tolerates nulls (optional fields absent)", () {
      final issue = Issue.fromApi({
        "id": "abc",
        "user_id": null,
        "constituency_id": null,
        "category": "ROADS",
        "title": "Pothole",
        "description": null,
        "latitude": null,
        "longitude": null,
        "photo_urls": null,
        "urgency": "LOW",
        "status": "open",
        "created_at": "2026-01-01T10:00:00Z",
        "updated_at": "2026-01-01T10:00:00Z",
      });
      expect(issue.description, isNull);
      expect(issue.latitude, isNull);
      expect(issue.photoUrls, isNull);
    });

    test("integer lat/lng coerce to double", () {
      final issue = Issue.fromApi({
        "id": "abc",
        "category": "PARK",
        "title": "t",
        "latitude": 13,
        "longitude": 77,
        "urgency": "LOW",
        "status": "open",
        "created_at": "2026-01-01T10:00:00Z",
        "updated_at": "2026-01-01T10:00:00Z",
      });
      expect(issue.latitude, isA<double>());
      expect(issue.latitude, 13.0);
    });
  });

  group("Issue.toCreateJson", () {
    test("omits null optionals, keeps required", () {
      final issue = Issue(
        category: IssueCategory.waste,
        title: "Garbage",
        urgency: Urgency.medium,
        status: IssueStatus.open,
      );
      final json = issue.toCreateJson();
      expect(json["category"], "WASTE");
      expect(json["title"], "Garbage");
      expect(json["urgency"], "MEDIUM");
      expect(json.containsKey("description"), isFalse);
      expect(json.containsKey("latitude"), isFalse);
      expect(json.containsKey("photo_urls"), isFalse);
      expect(json.containsKey("client_id"), isFalse);
    });

    test("includes client_id only when asked", () {
      final issue = Issue(
        clientId: "cid-1",
        category: IssueCategory.roads,
        title: "t",
        urgency: Urgency.low,
        status: IssueStatus.open,
      );
      expect(issue.toCreateJson().containsKey("client_id"), isFalse);
      expect(
        issue.toCreateJson(includeClientId: true)["client_id"],
        "cid-1",
      );
    });

    test("empty photo list is omitted", () {
      final issue = Issue(
        category: IssueCategory.roads,
        title: "t",
        urgency: Urgency.low,
        status: IssueStatus.open,
        photoUrls: const [],
      );
      expect(issue.toCreateJson().containsKey("photo_urls"), isFalse);
    });
  });

  group("Issue DB round-trip", () {
    test("toDb -> fromDb preserves fields incl. sync state and photos", () {
      final original = Issue(
        id: "srv-1",
        clientId: "cid-9",
        userId: "u",
        constituencyId: "c",
        category: IssueCategory.drainage,
        title: "Blocked drain",
        description: "overflow",
        latitude: 12.5,
        longitude: 77.5,
        photoUrls: const ["a.jpg", "b.jpg"],
        urgency: Urgency.high,
        status: IssueStatus.resolved,
        createdAt: DateTime.parse("2026-01-01T10:00:00Z"),
        updatedAt: DateTime.parse("2026-01-02T10:00:00Z"),
        syncState: SyncState.pendingCreate,
      );
      final restored = Issue.fromDb(original.toDb());
      expect(restored.id, original.id);
      expect(restored.clientId, original.clientId);
      expect(restored.category, original.category);
      expect(restored.status, IssueStatus.resolved);
      expect(restored.photoUrls, original.photoUrls);
      expect(restored.syncState, SyncState.pendingCreate);
      expect(restored.isPending, isTrue);
      expect(restored.createdAt, original.createdAt);
    });

    test("null photo list survives db round-trip", () {
      final original = Issue(
        category: IssueCategory.noise,
        title: "t",
        urgency: Urgency.low,
        status: IssueStatus.open,
      );
      final restored = Issue.fromDb(original.toDb());
      expect(restored.photoUrls, isNull);
    });
  });

  group("Constituency + User", () {
    test("constituency api + db round-trip", () {
      final c = Constituency.fromApi({
        "id": "c1",
        "name": "Ballari",
        "code": "BLR",
        "district": "Ballari",
        "state": "Karnataka",
        "created_at": "2026-01-01T00:00:00Z",
      });
      expect(c.name, "Ballari");
      final back = Constituency.fromDb(c.toDb());
      expect(back.code, "BLR");
      expect(back.district, "Ballari");
    });

    test("user role drives isAdmin", () {
      final admin = AppUser.fromApi({
        "id": "1",
        "phone": "900",
        "name": null,
        "constituency_id": null,
        "role": "admin",
        "is_verified": true,
        "created_at": "2026-01-01T00:00:00Z",
      });
      final citizen = AppUser.fromApi({
        "id": "2",
        "phone": "901",
        "name": "Asha",
        "constituency_id": "c1",
        "role": "citizen",
        "is_verified": true,
        "created_at": "2026-01-01T00:00:00Z",
      });
      expect(admin.isAdmin, isTrue);
      expect(citizen.isAdmin, isFalse);
      expect(citizen.name, "Asha");
    });

    test("user tolerates missing is_verified", () {
      final u = AppUser.fromApi({
        "id": "3",
        "phone": "902",
        "role": "citizen",
      });
      expect(u.isVerified, isFalse);
    });
  });
}
