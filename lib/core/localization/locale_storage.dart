import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_constants.dart';

class LocaleStorage {
  final SharedPreferences _prefs;

  LocaleStorage(this._prefs);

  Future<void> saveLocale(String localeCode) async {
    debugPrint('[Locale] Saved locale: $localeCode');
    await _prefs.setString(LocaleConstants.localeKey, localeCode);
  }

  String? getLocale() {
    return _prefs.getString(LocaleConstants.localeKey);
  }

  Future<void> clearLocale() async {
    await _prefs.remove(LocaleConstants.localeKey);
  }
}
