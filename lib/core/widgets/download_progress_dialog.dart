import 'package:flutter/material.dart';
import 'package:mms_acm/l10n/app_localizations.dart';

class DownloadProgressDialog extends StatefulWidget {
  final ValueNotifier<double> progress;
  final VoidCallback onCancel;

  const DownloadProgressDialog({
    super.key,
    required this.progress,
    required this.onCancel,
  });

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  @override
  void initState() {
    super.initState();
    widget.progress.addListener(_onProgress);
  }

  void _onProgress() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.progress.removeListener(_onProgress);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.progress.value * 100).clamp(0, 100).toInt();
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n?.updateDownloadStart ?? 'Downloading'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: widget.progress.value),
          const SizedBox(height: 12),
          Text('$pct%'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
      ],
    );
  }
}
