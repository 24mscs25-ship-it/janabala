import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../models/issue.dart";
import "../services/issue_repository.dart";
import "widgets.dart";

class IssueDetailScreen extends StatefulWidget {
  const IssueDetailScreen({super.key, required this.issueId});
  final String issueId;

  @override
  State<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends State<IssueDetailScreen> {
  Issue? _issue;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<IssueRepository>();
    final issue = await repo.getIssue(widget.issueId);
    if (!mounted) return;
    setState(() {
      _issue = issue;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navIssues)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _issue == null
              ? Center(child: Text(l10n.issueNotFound))
              : _detail(_issue!, l10n),
    );
  }

  Widget _detail(Issue issue, AppLocalizations l10n) {
    final hasGeo = issue.latitude != null && issue.longitude != null;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(issue.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 4, children: [
          CategoryChip(category: issue.category),
          UrgencyChip(urgency: issue.urgency),
          StatusChip(status: issue.status),
          if (issue.isPending) const PendingChip(),
        ]),
        const Divider(height: 32),
        if (issue.description != null && issue.description!.isNotEmpty) ...[
          Text(l10n.description,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(issue.description!),
          const SizedBox(height: 16),
        ],
        _row(l10n.filterConstituency, issue.constituencyId ?? "-"),
        _row(l10n.createdAt, issue.createdAt?.toLocal().toString() ?? "-"),
        _row(l10n.updatedAt, issue.updatedAt?.toLocal().toString() ?? "-"),
        _row(
          l10n.location,
          hasGeo ? "${issue.latitude}, ${issue.longitude}" : l10n.noCoordinates,
        ),
        if (issue.photoUrls != null && issue.photoUrls!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text("${l10n.addPhoto}s",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: issue.photoUrls!
                .map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(url,
                          width: 160,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                                width: 160,
                                height: 120,
                                color: Colors.black12,
                                child: const Icon(Icons.broken_image),
                              )),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
