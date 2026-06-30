import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:janabala_app/l10n/app_localizations.dart";
import "package:janabala_app/services/api_client.dart";
import "package:janabala_app/services/auth_service.dart";
import "package:janabala_app/screens/login_screen.dart";
import "package:provider/provider.dart";

/// In-memory secure storage so widget tests don't hit platform channels.
class FakeSecureStorage extends FlutterSecureStorage {
  const FakeSecureStorage();
  static final Map<String, String> _store = {};

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
}

Widget wrap(AuthService auth) {
  return MultiProvider(
    providers: [ChangeNotifierProvider.value(value: auth)],
    child: const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoginScreen(),
    ),
  );
}

void main() {
  testWidgets("phone step -> OTP step reveals code field", (tester) async {
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((req) async {
        if (req.url.path.endsWith("/send-otp")) {
          return http.Response(
              jsonEncode({"message": "ok", "debug_otp": "654321"}), 200);
        }
        return http.Response("no", 404);
      }),
    );
    final auth = AuthService(api, storage: const FakeSecureStorage());

    await tester.pumpWidget(wrap(auth));
    await tester.pumpAndSettle();

    // Phone step is shown.
    expect(find.text("Send OTP"), findsOneWidget);

    await tester.enterText(find.byType(TextField), "9000012345");
    await tester.tap(find.text("Send OTP"));
    await tester.pumpAndSettle();

    // OTP step now shown; in debug the dev OTP banner appears.
    expect(find.text("Enter OTP"), findsOneWidget);
    expect(find.textContaining("654321"), findsWidgets);
    expect(find.text("Verify & log in"), findsOneWidget);
  });

  testWidgets("invalid OTP surfaces error message", (tester) async {
    final api = ApiClient(
      baseUrl: "http://test/api/v1",
      httpClient: MockClient((req) async {
        if (req.url.path.endsWith("/send-otp")) {
          return http.Response(
              jsonEncode({"message": "ok", "debug_otp": null}), 200);
        }
        if (req.url.path.endsWith("/verify-otp")) {
          return http.Response(jsonEncode({"detail": "Invalid OTP"}), 400);
        }
        return http.Response("no", 404);
      }),
    );
    final auth = AuthService(api, storage: const FakeSecureStorage());

    await tester.pumpWidget(wrap(auth));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "9000012345");
    await tester.tap(find.text("Send OTP"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), "000000");
    await tester.tap(find.text("Verify & log in"));
    await tester.pumpAndSettle();

    expect(find.text("Invalid OTP"), findsOneWidget);
  });
}
