import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

extension BuildContextLocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
