import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../app_state.dart";
import "../l10n/app_localizations.dart";
import "../services/auth_service.dart";
import "issue_list_screen.dart";
import "report_screen.dart";
import "sync_indicator.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthService>();

    const pages = [IssueListScreen(), ReportScreen()];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          const SyncIndicator(),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onSelected: (loc) =>
                context.read<AppState>().setLocale(loc),
            itemBuilder: (_) => const [
              PopupMenuItem(value: Locale("en"), child: Text("English")),
              PopupMenuItem(value: Locale("kn"), child: Text("ಕನ್ನಡ")),
            ],
          ),
          IconButton(
            tooltip: l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list_alt),
            label: l10n.navIssues,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            label: l10n.navReport,
          ),
        ],
      ),
    );
  }
}

