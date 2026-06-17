import 'package:flutter/material.dart';
import '../models/app_update_model.dart';
import '../../l10n/app_localizations.dart';

class UpdateDialog extends StatelessWidget {
  final AppUpdateModel model;
  final String? currentVersion;
  final VoidCallback onUpdate;

  const UpdateDialog({
    super.key,
    required this.model,
    this.currentVersion,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Row(
          children: [
            const Text('MMS'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.updateNewVersionAvailable),
            const SizedBox(height: 8),
            if ((model.description ?? '').isNotEmpty) Text(model.description!),
            const SizedBox(height: 8),
            Text('${l10n.updateCurrentVersion}: ${currentVersion ?? '-'}'),
            Text('${l10n.updateLatestVersion}: ${model.version}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onUpdate();
            },
            child: Text(l10n.updateUpdate),
          ),
        ],
      ),
    );
  }
}
