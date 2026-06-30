import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:janabala_app/models/issue.dart";
import "package:janabala_app/models/enums.dart";
import "package:janabala_app/services/api_client.dart";

ApiClient clientReturning(
  http.Response Function(http.Request req) handler, {
  String? token,
}) {
  final mock = MockClient((req) async => handler(req));
  final api = ApiClient(baseUrl: "http://test/api/v1", httpClient: mock);
  if (token != null) api.tokenProvider = () => token;
  return api;
}

void main() {
  group("sendOtp", () {
    test("returns debug_otp on 200", () async {
      final api = clientReturning((req) {
        expect(req.method, "POST");
        expect(req.url.path, "/api/v1/auth/send-otp");
        expect(jsonDecode(req.body)["phone"], "900");
        return http.Response(
            jsonEncode({"message": "ok", "debug_otp": "123456"}), 200);
      });
      expect(await api.sendOtp("900"), "123456");
    });

    test("null debug_otp when not in debug", () async {
      final api = clientReturning((req) =>
          http.Response(jsonEncode({"message": "ok", "debug_otp": null}), 200));
      expect(await api.sendOtp("900"), isNull);
    });

    test("429 surfaces Retry-After seconds", () async {
      final api = clientReturning((req) => http.Response(
            jsonEncode({"detail": "Too soon"}),
            429,
            headers: {"retry-after": "42"},
          ));
      try {
        await api.sendOtp("900");
        fail("should have thrown");
      } on ApiException catch (e) {
        expect(e.statusCode, 429);
        expect(e.isRateLimited, isTrue);
        expect(e.retryAfterSeconds, 42);
        expect(e.message, "Too soon");
      }
    });
  });

  group("verifyOtp", () {
    test("returns access_token", () async {
      final api = clientReturning((req) => http.Response(
          jsonEncode({"access_token": "jwt-x", "token_type": "bearer"}), 200));
      expect(await api.verifyOtp("900", "111111"), "jwt-x");
    });

    test("maps 400 to ApiException with detail", () async {
      final api = clientReturning((req) =>
          http.Response(jsonEncode({"detail": "Invalid OTP"}), 400));
      try {
        await api.verifyOtp("900", "000000");
        fail("should throw");
      } on ApiException catch (e) {
        expect(e.statusCode, 400);
        expect(e.message, "Invalid OTP");
        expect(e.isRateLimited, isFalse);
      }
    });
  });

  group("auth header", () {
    test("me() attaches bearer token", () async {
      late String? authHeader;
      final api = clientReturning((req) {
        authHeader = req.headers["Authorization"];
        return http.Response(
            jsonEncode({
              "id": "1",
              "phone": "900",
              "name": null,
              "constituency_id": null,
              "role": "admin",
              "is_verified": true,
              "created_at": "2026-01-01T00:00:00Z",
            }),
            200);
      }, token: "tok-123");
      final user = await api.me();
      expect(authHeader, "Bearer tok-123");
      expect(user.isAdmin, isTrue);
    });

    test("public listIssues sends no Authorization", () async {
      late bool hadAuth;
      final api = clientReturning((req) {
        hadAuth = req.headers.containsKey("Authorization");
        return http.Response(jsonEncode([]), 200);
      }, token: "tok-123");
      await api.listIssues();
      expect(hadAuth, isFalse);
    });
  });

  group("listIssues query building", () {
    test("only includes set filters; always limit+offset", () async {
      late Uri captured;
      final api = clientReturning((req) {
        captured = req.url;
        return http.Response(jsonEncode([]), 200);
      });
      await api.listIssues(category: "WATER", status: "open", limit: 25);
      expect(captured.queryParameters["category"], "WATER");
      expect(captured.queryParameters["status"], "open");
      expect(captured.queryParameters["limit"], "25");
      expect(captured.queryParameters["offset"], "0");
      expect(captured.queryParameters.containsKey("constituency_id"), isFalse);
    });
  });

  group("createIssue", () {
    test("posts create body and parses 201", () async {
      final api = clientReturning((req) {
        expect(req.url.path, "/api/v1/issues");
        final body = jsonDecode(req.body);
        expect(body["category"], "ROADS");
        return http.Response(
            jsonEncode({
              "id": "new-1",
              "category": "ROADS",
              "title": "t",
              "urgency": "LOW",
              "status": "open",
              "created_at": "2026-01-01T00:00:00Z",
              "updated_at": "2026-01-01T00:00:00Z",
            }),
            201);
      }, token: "t");
      final issue = Issue(
        category: IssueCategory.roads,
        title: "t",
        urgency: Urgency.low,
        status: IssueStatus.open,
      );
      final created = await api.createIssue(issue);
      expect(created.id, "new-1");
    });

    test("non-201 throws", () async {
      final api = clientReturning(
          (req) => http.Response(jsonEncode({"detail": "nope"}), 401),
          token: "t");
      expect(
        () => api.createIssue(Issue(
          category: IssueCategory.roads,
          title: "t",
          urgency: Urgency.low,
          status: IssueStatus.open,
        )),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group("sync", () {
    test("push sends client_id and parses created list", () async {
      final api = clientReturning((req) {
        final body = jsonDecode(req.body);
        expect(body["issues"][0]["client_id"], "cid-1");
        return http.Response(
            jsonEncode({
              "created": [
                {
                  "id": "srv-1",
                  "category": "WATER",
                  "title": "t",
                  "urgency": "LOW",
                  "status": "open",
                  "created_at": "2026-01-01T00:00:00Z",
                  "updated_at": "2026-01-01T00:00:00Z",
                }
              ],
              "count": 1,
            }),
            200);
      }, token: "t");
      final created = await api.syncPush([
        Issue(
          clientId: "cid-1",
          category: IssueCategory.water,
          title: "t",
          urgency: Urgency.low,
          status: IssueStatus.open,
        )
      ]);
      expect(created.single.id, "srv-1");
    });

    test("pull passes since as UTC iso and parses server_time", () async {
      late Uri captured;
      final api = clientReturning((req) {
        captured = req.url;
        return http.Response(
            jsonEncode({
              "issues": [],
              "server_time": "2026-02-02T12:00:00Z",
              "count": 0,
            }),
            200);
      }, token: "t");
      final since = DateTime.utc(2026, 1, 1, 0, 0, 0);
      final res = await api.syncPull(since: since);
      expect(captured.queryParameters["since"], "2026-01-01T00:00:00.000Z");
      expect(res.serverTime, DateTime.utc(2026, 2, 2, 12, 0, 0));
    });

    test("pull omits since when null", () async {
      late Uri captured;
      final api = clientReturning((req) {
        captured = req.url;
        return http.Response(
            jsonEncode({
              "issues": [],
              "server_time": "2026-02-02T12:00:00Z",
              "count": 0,
            }),
            200);
      }, token: "t");
      await api.syncPull();
      expect(captured.queryParameters.containsKey("since"), isFalse);
    });
  });
}
