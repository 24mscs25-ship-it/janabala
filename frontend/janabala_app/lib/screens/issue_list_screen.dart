import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../models/constituency.dart";
import "../models/enums.dart";
import "../models/issue.dart";
import "../services/issue_repository.dart";
import "issue_detail_screen.dart";
import "widgets.dart";

class IssueListScreen extends StatefulWidget {
  const IssueListScreen({super.key});

  @override
  State<IssueListScreen> createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
  IssueCategory? _category;
  IssueStatus? _status;
  String? _constituencyId;

  List<Issue> _issues = [];
  List<Constituency> _constituencies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _loadConstituencies();
  }

  Future<void> _load({bool refresh = true}) async {
    setState(() => _loading = true);
    final repo = context.read<IssueRepository>();
    final issues = await repo.getIssues(
      category: _category,
      status: _status,
      constituencyId: _constituencyId,
      refresh: refresh,
    );
    if (!mounted) return;
    setState(() {
      _issues = issues;
      _loading = false;
    });
  }

  Future<void> _loadConstituencies() async {
    final repo = context.read<IssueRepository>();
    final items = await repo.getConstituencies();
    if (!mounted) return;
    setState(() => _constituencies = items);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _filters(l10n),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _load(refresh: true),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _issues.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 120),
                          Center(child: Text(l10n.noIssues)),
                        ],
                      )
                    : ListView.builder(
                        itemCount: _issues.length,
                        itemBuilder: (ctx, i) {
                          final issue = _issues[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: ListTile(
                              title: Text(issue.title),
                              subtitle: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  CategoryChip(category: issue.category),
                                  UrgencyChip(urgency: issue.urgency),
                                  StatusChip(status: issue.status),
                                  if (issue.isPending)
                                    const PendingChip(),
                                ],
                              ),
                              onTap: issue.id == null
                                  ? null
                                  : () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => IssueDetailScreen(
                                              issueId: issue.id!),
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }

  Widget _filters(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          DropdownButton<IssueCategory?>(
            value: _category,
            hint: Text(l10n.filterCategory),
            onChanged: (v) {
              setState(() => _category = v);
              _load();
            },
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.all)),
              ...IssueCategory.values.map(
                (c) => DropdownMenuItem(value: c, child: Text(c.wire)),
              ),
            ],
          ),
          DropdownButton<IssueStatus?>(
            value: _status,
            hint: Text(l10n.filterStatus),
            onChanged: (v) {
              setState(() => _status = v);
              _load();
            },
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.all)),
              ...IssueStatus.values.map(
                (s) => DropdownMenuItem(value: s, child: Text(s.wire)),
              ),
            ],
          ),
          DropdownButton<String?>(
            value: _constituencyId,
            hint: Text(l10n.filterConstituency),
            onChanged: (v) {
              setState(() => _constituencyId = v);
              _load();
            },
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.all)),
              ..._constituencies.map(
                (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
