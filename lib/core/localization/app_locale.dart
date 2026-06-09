import 'package:flutter/material.dart';

class AppLocale {
  AppLocale._();

  static const Locale english = Locale('en');
  static const Locale vietnamese = Locale('vi');
  static const Locale chineseSimplified = Locale('zh', 'CN');
  static const Locale chineseTraditional = Locale('zh', 'TW');

  static const List<Locale> all = [
    english,
    vietnamese,
    chineseSimplified,
    chineseTraditional,
  ];
}
