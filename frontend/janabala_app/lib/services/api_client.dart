import "dart:async";
import "dart:convert";

import "package:http/http.dart" as http;

import "../models/constituency.dart";
import "../models/issue.dart";
import "../models/user.dart";

/// Raised for non-2xx responses. [retryAfterSeconds] is set for 429s.
class ApiException implements Exception {
  ApiException(this.statusCode, this.message, {this.retryAfterSeconds});
  final int statusCode;
  final String message;
  final int? retryAfterSeconds;

  bool get isRateLimited => statusCode == 429;

  @override
  String toString() => "ApiException($statusCode): $message";
}

/// Result of a sync pull: server issues plus the authoritative server time to
/// use as the next `since`.
class PullResult {
  PullResult({required this.issues, required this.serverTime});
  final List<Issue> issues;
  final DateTime serverTime;
}

/// The single typed client for the JanaBala API. All endpoints live here so the
/// frozen contract is in one place; widgets never build URLs or parse JSON.
class ApiClient {
  ApiClient({
    String? baseUrl,
    http.Client? httpClient,
    this.tokenProvider,
  })  : baseUrl = baseUrl ?? defaultBaseUrl,
        _http = httpClient ?? http.Client();

  static const String defaultBaseUrl =
      String.fromEnvironment("API_BASE", defaultValue: "http://127.0.0.1:8000/api/v1");

  final String baseUrl;
  final http.Client _http;

  /// Supplies the current JWT for authed calls (set by AuthService).
  String? Function()? tokenProvider;

  Map<String, String> _headers({bool auth = false, bool json = false}) {
    final headers = <String, String>{};
    if (json) headers["Content-Type"] = "application/json";
    if (auth) {
      final token = tokenProvider?.call();
      if (token != null) headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  Never _throw(http.Response res) {
    int? retryAfter;
    final ra = res.headers["retry-after"];
    if (ra != null) retryAfter = int.tryParse(ra);
    String detail = res.reasonPhrase ?? "Request failed";
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body["detail"] != null) {
        detail = body["detail"].toString();
      }
    } catch (_) {}
    throw ApiException(res.statusCode, detail, retryAfterSeconds: retryAfter);
  }

  Uri _uri(String path, [Map<String, String?>? query]) {
    final cleaned = <String, String>{};
    query?.forEach((k, v) {
      if (v != null && v.isNotEmpty) cleaned[k] = v;
    });
    return Uri.parse("$baseUrl$path").replace(
      queryParameters: cleaned.isEmpty ? null : cleaned,
    );
  }

  // ---- Auth ----

  /// Returns debug_otp when the backend is in DEBUG mode, else null.
  Future<String?> sendOtp(String phone) async {
    final res = await _http.post(
      _uri("/auth/send-otp"),
      headers: _headers(json: true),
      body: jsonEncode({"phone": phone}),
    );
    if (res.statusCode != 200) _throw(res);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return body["debug_otp"] as String?;
  }

  Future<String> verifyOtp(String phone, String otp) async {
    final res = await _http.post(
      _uri("/auth/verify-otp"),
      headers: _headers(json: true),
      body: jsonEncode({"phone": phone, "otp": otp}),
    );
    if (res.statusCode != 200) _throw(res);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return body["access_token"] as String;
  }

  Future<AppUser> me() async {
    final res = await _http.get(_uri("/auth/me"), headers: _headers(auth: true));
    if (res.statusCode != 200) _throw(res);
    return AppUser.fromApi(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // ---- Constituencies ----

  Future<List<Constituency>> listConstituencies({String? query}) async {
    final res = await _http.get(_uri("/constituencies", {"q": query}));
    if (res.statusCode != 200) _throw(res);
    final list = jsonDecode(res.body) as List;
    return list
        .map((e) => Constituency.fromApi(e as Map<String, dynamic>))
        .toList();
  }

  // ---- Issues ----

  Future<List<Issue>> listIssues({
    String? constituencyId,
    String? category,
    String? status,
    int limit = 50,
    int offset = 0,
  }) async {
    final res = await _http.get(_uri("/issues", {
      "constituency_id": constituencyId,
      "category": category,
      "status": status,
      "limit": "$limit",
      "offset": "$offset",
    }));
    if (res.statusCode != 200) _throw(res);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Issue.fromApi(e as Map<String, dynamic>)).toList();
  }

  Future<Issue> getIssue(String id) async {
    final res = await _http.get(_uri("/issues/$id"));
    if (res.statusCode != 200) _throw(res);
    return Issue.fromApi(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Issue> createIssue(Issue issue) async {
    final res = await _http.post(
      _uri("/issues"),
      headers: _headers(auth: true, json: true),
      body: jsonEncode(issue.toCreateJson()),
    );
    if (res.statusCode != 201) _throw(res);
    return Issue.fromApi(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // ---- Sync ----

  /// Pushes queued issues. NOTE: the server is NOT idempotent on client_id, so
  /// callers must push each item exactly once and mark it synced locally.
  Future<List<Issue>> syncPush(List<Issue> issues) async {
    final res = await _http.post(
      _uri("/sync/push"),
      headers: _headers(auth: true, json: true),
      body: jsonEncode({
        "issues": issues.map((i) => i.toCreateJson(includeClientId: true)).toList(),
      }),
    );
    if (res.statusCode != 200) _throw(res);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body["created"] as List)
        .map((e) => Issue.fromApi(e as Map<String, dynamic>))
        .toList();
  }

  Future<PullResult> syncPull({DateTime? since}) async {
    final res = await _http.get(
      _uri("/sync/pull", {"since": since?.toUtc().toIso8601String()}),
      headers: _headers(auth: true),
    );
    if (res.statusCode != 200) _throw(res);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return PullResult(
      issues: (body["issues"] as List)
          .map((e) => Issue.fromApi(e as Map<String, dynamic>))
          .toList(),
      serverTime: DateTime.parse(body["server_time"] as String),
    );
  }

  void close() => _http.close();
}
