// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'JanaBala';

  @override
  String get navIssues => 'Issues';

  @override
  String get navReport => 'Report';

  @override
  String get login => 'Log in';

  @override
  String get logout => 'Log out';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get verifyLogin => 'Verify & log in';

  @override
  String get changeNumber => 'Change number';

  @override
  String get sending => 'Sending...';

  @override
  String get verifying => 'Verifying...';

  @override
  String get devOtp => 'Dev OTP';

  @override
  String resendIn(int seconds) {
    return 'Resend available in ${seconds}s';
  }

  @override
  String get tooManyAttempts => 'Too many attempts. Try again later.';

  @override
  String get civicIssues => 'Civic Issues';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterConstituency => 'Constituency';

  @override
  String get all => 'All';

  @override
  String get noIssues => 'No issues match these filters.';

  @override
  String get loadingIssues => 'Loading issues...';

  @override
  String get reportIssue => 'Report an Issue';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get urgency => 'Urgency';

  @override
  String get category => 'Category';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get useLocation => 'Attach current location';

  @override
  String get locationAttached => 'Location attached';

  @override
  String get submit => 'Submit';

  @override
  String get savedOffline => 'Saved. Will sync when online.';

  @override
  String get submitted => 'Issue submitted.';

  @override
  String get syncIdle => 'Up to date';

  @override
  String get syncing => 'Syncing...';

  @override
  String syncPending(int count) {
    return '$count pending';
  }

  @override
  String get syncOffline => 'Offline';

  @override
  String get backToIssues => 'Back to issues';

  @override
  String get issueNotFound => 'Issue not found.';

  @override
  String get createdAt => 'Created';

  @override
  String get updatedAt => 'Updated';

  @override
  String get location => 'Location';

  @override
  String get noCoordinates => 'No coordinates';

  @override
  String get reportedBy => 'Reported by';

  @override
  String get language => 'Language';

  @override
  String get requiredField => 'Required';
}
