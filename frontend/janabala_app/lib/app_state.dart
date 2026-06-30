import "package:flutter/material.dart";

/// Holds app-wide UI state that is not tied to a service, e.g. the chosen
/// locale (English / Kannada).
class AppState extends ChangeNotifier {
  Locale? _locale = const Locale("en");
  Locale? get locale => _locale;

  void setLocale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }
}
