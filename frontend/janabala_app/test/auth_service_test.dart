import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:janabala_app/services/api_client.dart";
import "package:janabala_app/services/auth_service.dart";

/// In-memory secure storage, seedable per test.
class FakeSecureStorage extends FlutterSecureStorage {
  FakeSecureStorage([Map<String, String>? seed]) {
    if (seed != null) _store.addAll(seed);
  }
  final Map<String, String> _store = {};

  @override
  Future<String?> read({required String key, dynamic iOptions, dynamic aOptions, dynamic lOptions, dynamic webOptions, dynamic mOptions, dynamic wOptions}) async =>
      _store[key];
  @override
  Future<void> write({required String key, required String? value, dynamic iOptions, dynamic aOptions, dynamic lOptions, dynamic webOptions, dynamic mOptions, dynamic wOptions}) async {
    if (value != null) _store[key] = value;
  }
  @override
  Future<void> delete({required String key, dynamic iOptions, dynamic aOptions, dynamic lOptions, dynamic webOptions, dynamic mOptions, dynamic wOptions}) async {
    _store.remove(key);
  }

  bool has(String key) => _store.containsKey(key);
}

const _tokenKey = "janabala.jwt";

http.Response _meResponse(String role) => http.Response(
      jsonEncode({
        "id": "1",
        "phone": "900",
        "name": null,
        "constituency_id": null,
        "role": role,
        "is_verified": true,
        "created_at": "2026-01-01T00:00:00Z",
      }),
      200,
    );

void main() {
  test("bootstrap with no token -> logged out, not loading", () async {
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((_) async => http.Response("no", 404)),
    );
    final auth = AuthService(api, storage: FakeSecureStorage());
    await auth.bootstrap();
    expect(auth.isLoggedIn, isFalse);
    expect(auth.loading, isFalse);
    expect(auth.user, isNull);
  });

  test("bootstrap with valid token -> loads user", () async {
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((req) async {
        expect(req.headers["Authorization"], "Bearer good");
        return _meResponse("citizen");
      }),
    );
    final auth = AuthService(api, storage: FakeSecureStorage({_tokenKey: "good"}));
    await auth.bootstrap();
    expect(auth.isLoggedIn, isTrue);
    expect(auth.isAdmin, isFalse);
    expect(auth.user!.phone, "900");
  });

  test("bootstrap with invalid token clears it", () async {
    final storage = FakeSecureStorage({_tokenKey: "stale"});
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((_) async =>
          http.Response(jsonEncode({"detail": "expired"}), 401)),
    );
    final auth = AuthService(api, storage: storage);
    await auth.bootstrap();
    expect(auth.isLoggedIn, isFalse);
    expect(storage.has(_tokenKey), isFalse, reason: "stale token removed");
  });

  test("verifyAndLogin persists token and sets admin user", () async {
    final storage = FakeSecureStorage();
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((req) async {
        if (req.url.path.endsWith("/verify-otp")) {
          return http.Response(
              jsonEncode({"access_token": "fresh", "token_type": "bearer"}),
              200);
        }
        if (req.url.path.endsWith("/auth/me")) {
          expect(req.headers["Authorization"], "Bearer fresh");
          return _meResponse("admin");
        }
        return http.Response("no", 404);
      }),
    );
    final auth = AuthService(api, storage: storage);
    await auth.verifyAndLogin("900", "111111");
    expect(auth.isLoggedIn, isTrue);
    expect(auth.isAdmin, isTrue);
    expect(storage.has(_tokenKey), isTrue);
    expect(auth.token, "fresh");
  });

  test("logout clears token and user", () async {
    final storage = FakeSecureStorage({_tokenKey: "good"});
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((_) async => _meResponse("citizen")),
    );
    final auth = AuthService(api, storage: storage);
    await auth.bootstrap();
    expect(auth.isLoggedIn, isTrue);

    await auth.logout();
    expect(auth.isLoggedIn, isFalse);
    expect(auth.user, isNull);
    expect(storage.has(_tokenKey), isFalse);
  });

  test("notifies listeners on login and logout", () async {
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((req) async {
        if (req.url.path.endsWith("/verify-otp")) {
          return http.Response(
              jsonEncode({"access_token": "fresh", "token_type": "bearer"}),
              200);
        }
        return _meResponse("citizen");
      }),
    );
    final auth = AuthService(api, storage: FakeSecureStorage());
    var notifications = 0;
    auth.addListener(() => notifications++);
    await auth.verifyAndLogin("900", "111111");
    await auth.logout();
    expect(notifications, greaterThanOrEqualTo(2));
  });
}
