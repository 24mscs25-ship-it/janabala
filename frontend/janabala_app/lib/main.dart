import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:provider/provider.dart";

import "app_state.dart";
import "l10n/app_localizations.dart";
import "services/api_client.dart";
import "services/auth_service.dart";
import "services/issue_repository.dart";
import "services/local_db.dart";
import "services/sync_service.dart";
import "screens/home_screen.dart";
import "screens/login_screen.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalDb.init();

  final api = ApiClient();
  final db = LocalDb.instance;
  final auth = AuthService(api);
  final sync = SyncService(api, db);
  sync.authGuard = () => auth.isLoggedIn;
  final repo = IssueRepository(api, db, sync);

  runApp(JanaBalaApp(
    api: api,
    auth: auth,
    sync: sync,
    repo: repo,
  ));
}

class JanaBalaApp extends StatefulWidget {
  const JanaBalaApp({
    super.key,
    required this.api,
    required this.auth,
    required this.sync,
    required this.repo,
  });

  final ApiClient api;
  final AuthService auth;
  final SyncService sync;
  final IssueRepository repo;

  @override
  State<JanaBalaApp> createState() => _JanaBalaAppState();
}

class _JanaBalaAppState extends State<JanaBalaApp> {
  @override
  void initState() {
    super.initState();
    widget.auth.bootstrap();
    widget.sync.start();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider.value(value: widget.auth),
        ChangeNotifierProvider.value(value: widget.sync),
        ChangeNotifierProvider.value(value: widget.repo),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorSchemeSeed: const Color(0xFF4F8CFF),
              useMaterial3: true,
            ),
            locale: appState.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const _Root(),
          );
        },
      ),
    );
  }
}

/// Decides between login and home based on auth state.
class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (auth.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
