import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_locale.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_providers.dart';
import 'presentation/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Lock to portrait mode for factory handheld devices
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(AppProviders.wrapWithProviders(prefs: prefs, child: const MmsApp()));
}

/// Root application widget.
/// Only contains theme config and router config — all providers
/// and DI are handled by [AppProviders].
class MmsApp extends StatelessWidget {
  const MmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = context.watch<GoRouter>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp.router(
      title: 'MMS Factory Monitor',
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: AppLocale.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
