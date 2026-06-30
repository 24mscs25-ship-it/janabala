import "package:flutter/foundation.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

import "../models/user.dart";
import "api_client.dart";

/// Holds auth state: the JWT (persisted in secure storage) and the current
/// user from /auth/me. Exposes the token to ApiClient via tokenProvider.
class AuthService extends ChangeNotifier {
  AuthService(this._api, {FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage() {
    _api.tokenProvider = () => _token;
  }

  static const _tokenKey = "janabala.jwt";

  final ApiClient _api;
  final FlutterSecureStorage _storage;

  String? _token;
  AppUser? _user;
  bool _loading = true;

  AppUser? get user => _user;
  bool get isLoggedIn => _token != null && _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get loading => _loading;
  String? get token => _token;

  /// Loads any persisted token and refreshes the user. Call at startup.
  Future<void> bootstrap() async {
    _loading = true;
    notifyListeners();
    try {
      _token = await _readToken();
      if (_token != null) {
        try {
          _user = await _api.me();
        } catch (_) {
          // Token invalid/expired - clear it.
          await _clear();
        }
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> sendOtp(String phone) => _api.sendOtp(phone);

  Future<void> verifyAndLogin(String phone, String otp) async {
    final token = await _api.verifyOtp(phone, otp);
    _token = token;
    await _writeToken(token);
    _user = await _api.me();
    notifyListeners();
  }

  Future<void> logout() async {
    await _clear();
    notifyListeners();
  }

  Future<void> _clear() async {
    _token = null;
    _user = null;
    await _deleteToken();
  }

  // flutter_secure_storage lacks a desktop keychain in some setups; fall back
  // is unnecessary here because we run desktop verification with FFI storage.
  Future<String?> _readToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      if (kDebugMode) debugPrint("secure read failed: $e");
      return null;
    }
  }

  Future<void> _writeToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      if (kDebugMode) debugPrint("secure write failed: $e");
    }
  }

  Future<void> _deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (_) {}
  }
}
