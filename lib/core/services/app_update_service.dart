import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../models/app_update_model.dart';
import '../repositories/app_update_repository.dart';
import '../widgets/update_dialog.dart';
import '../widgets/download_progress_dialog.dart';
import '../../l10n/app_localizations.dart';

class AppUpdateService {
  static bool _checked = false;
  final AppUpdateRepository _repo;

  AppUpdateService([AppUpdateRepository? repo])
    : _repo = repo ?? AppUpdateRepository();

  static Future<void> check(BuildContext context) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (_checked) return;
    _checked = true;
    // run but don't block startup
    final service = AppUpdateService();
    // ignore: avoid_print
    print('[UPDATE] Check update');
    try {
      final pkg = await PackageInfo.fromPlatform();
      final current = pkg.version;
      // fetch from repo
      final model = await service._repo.fetchLatestVersion();
      if (model == null) return;
      // log
      // ignore: avoid_print
      print('[UPDATE] Current version: $current');
      // ignore: avoid_print
      print('[UPDATE] Latest version: ${model.version}');
      final isNew = _isNewVersion(current, model.version);
      if (isNew) {
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => UpdateDialog(
            model: model,
            currentVersion: current,
            onUpdate: Platform.isIOS ? null : () => service._downloadAndInstall(context, model),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('[UPDATE] check error: $e');
    }
  }

  Future<void> _downloadAndInstall(
    BuildContext context,
    AppUpdateModel model,
  ) async {
    final dio = Dio();
    final cancelToken = CancelToken();
    final tempDir = await getTemporaryDirectory();
    final savePath = '${tempDir.path}${Platform.pathSeparator}mms_update.apk';
    // show progress dialog
    final progressNotifier = ValueNotifier<double>(0);
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DownloadProgressDialog(
        progress: progressNotifier,
        onCancel: () {
          cancelToken.cancel('user_cancelled');
        },
      ),
    );

    try {
      // ignore: avoid_print
      print('[UPDATE] Download start');
      await dio.download(
        model.url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final pct = received / total;
            progressNotifier.value = pct;
            // ignore: avoid_print
            print(
              '[UPDATE] Download progress ${(pct * 100).toStringAsFixed(0)}%',
            );
          }
        },
        cancelToken: cancelToken,
      );

      progressNotifier.value = 1.0;
      // ignore: avoid_print
      print('[UPDATE] Install APK');
      if (!context.mounted) return;
      Navigator.of(context).pop(); // close progress dialog
      // open file
      await OpenFilex.open(savePath);
    } on DioException catch (e) {
      // ignore: avoid_print
      print('[UPDATE] Download failed: ${e.message}');
      if (context.mounted) {
        Navigator.of(context).pop();
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.updateDownloadFailed ?? 'Download failed'),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('[UPDATE] Download error: $e');
      if (context.mounted) {
        Navigator.of(context).pop();
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.updateDownloadFailed ?? 'Download failed'),
          ),
        );
      }
    } finally {
      progressNotifier.dispose();
    }
  }

  static bool _isNewVersion(String current, String latest) {
    try {
      final cs = current.split('.').map((s) => int.tryParse(s) ?? 0).toList();
      final ls = latest.split('.').map((s) => int.tryParse(s) ?? 0).toList();
      final len = cs.length > ls.length ? cs.length : ls.length;
      for (var i = 0; i < len; i++) {
        final c = i < cs.length ? cs[i] : 0;
        final l = i < ls.length ? ls[i] : 0;
        if (c < l) return true;
        if (c > l) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
