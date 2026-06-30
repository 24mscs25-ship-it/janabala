import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../services/sync_service.dart";

/// Small status chip in the app bar reflecting the SyncService state.
class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sync = context.watch<SyncService>();

    late final IconData icon;
    late final String label;
    Color? color;

    if (sync.pending > 0 && sync.status != SyncStatus.syncing) {
      icon = Icons.cloud_upload_outlined;
      label = l10n.syncPending(sync.pending);
      color = Colors.orange;
    } else {
      switch (sync.status) {
        case SyncStatus.syncing:
          icon = Icons.sync;
          label = l10n.syncing;
          break;
        case SyncStatus.offline:
          icon = Icons.cloud_off;
          label = l10n.syncOffline;
          color = Colors.grey;
          break;
        case SyncStatus.error:
          icon = Icons.error_outline;
          label = l10n.syncOffline;
          color = Colors.red;
          break;
        case SyncStatus.idle:
          icon = Icons.cloud_done_outlined;
          label = l10n.syncIdle;
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: InkWell(
          onTap: () => sync.sync(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 4),
                Text(label, style: TextStyle(fontSize: 12, color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
