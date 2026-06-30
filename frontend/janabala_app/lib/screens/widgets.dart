import "package:flutter/material.dart";

import "../models/enums.dart";

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category});
  final IssueCategory category;

  @override
  Widget build(BuildContext context) {
    return _Pill(label: category.wire, color: Colors.blueGrey);
  }
}

class UrgencyChip extends StatelessWidget {
  const UrgencyChip({super.key, required this.urgency});
  final Urgency urgency;

  @override
  Widget build(BuildContext context) {
    final color = switch (urgency) {
      Urgency.low => Colors.grey,
      Urgency.medium => Colors.orange,
      Urgency.high => Colors.red,
    };
    return _Pill(label: urgency.wire, color: color);
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final IssueStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      IssueStatus.open => Colors.orange,
      IssueStatus.inProgress => Colors.blue,
      IssueStatus.resolved => Colors.green,
    };
    return _Pill(label: status.wire.replaceAll("_", " "), color: color);
  }
}

class PendingChip extends StatelessWidget {
  const PendingChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Pill(label: "pending sync", color: Colors.deepPurple);
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
