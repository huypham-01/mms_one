import 'package:flutter/material.dart';
import '../../core/localization/app_locale.dart';
import '../../core/localization/locale_storage.dart';
import '../../core/localization/language_helper.dart';

class LocaleProvider extends ChangeNotifier {
  final LocaleStorage _storage;

  Locale _locale = AppLocale.english;

  LocaleProvider(this._storage);

  Locale get locale => _locale;

  Future<void> loadSavedLocale() async {
    final code = _storage.getLocale();
    if (code != null) {
      _locale = LanguageHelper.getLocaleFromCode(code);
      debugPrint('[Locale] Loaded locale: $code');
    }
    notifyListeners();
  }

  Future<void> changeLocale(Locale locale) async {
    _locale = locale;
    final code = LanguageHelper.getLocaleCode(locale);
    await _storage.saveLocale(code);
    debugPrint('[Locale] Changed locale: $code');
    notifyListeners();
  }

  bool isSelected(Locale locale) {
    return _locale.languageCode == locale.languageCode &&
        _locale.countryCode == locale.countryCode;
  }

  String getLanguageName(Locale locale) {
    return LanguageHelper.getLanguageName(locale);
  }
}
