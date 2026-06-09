import 'package:flutter/material.dart';
import 'app_locale.dart';

class LanguageHelper {
  LanguageHelper._();

  static String getLanguageName(Locale locale) {
    final code = locale.toLanguageTag();

    switch (code) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      case 'zh-CN':
        return '简体中文';
      case 'zh-TW':
        return '繁體中文';
      default:
        return code;
    }
  }

  static Locale getLocaleFromCode(String code) {
    switch (code) {
      case 'en':
        return AppLocale.english;
      case 'vi':
        return AppLocale.vietnamese;
      case 'zh_CN':
        return AppLocale.chineseSimplified;
      case 'zh_TW':
        return AppLocale.chineseTraditional;
      default:
        return AppLocale.english;
    }
  }

  static String getLocaleCode(Locale locale) {
    final tag = locale.toLanguageTag();
    if (tag.contains('-')) {
      return tag.replaceAll('-', '_');
    }
    return tag;
  }
}
