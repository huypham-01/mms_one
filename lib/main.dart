import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_locale.dart';
import 'l10n/app_localizations.dart';
import 'core/services/app_update_service.dart';
import 'providers/app_providers.dart';
import 'presentation/providers/locale_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

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

  await Firebase.initializeApp();

  // --- Cấu hình Firebase Cloud Messaging (FCM) ---
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final messaging = FirebaseMessaging.instance;
  
  // Yêu cầu quyền thông báo (iOS/Android 13+)
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Cấu hình channel cho Android để hiện thông báo heads-up khi app đang mở
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 
    'High Importance Notifications', 
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Lắng nghe thông báo khi app đang ở Foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  // Lắng nghe sự kiện click vào thông báo từ background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    // TODO: Xử lý điều hướng khi bấm vào thông báo tại đây
  });

  // Lấy Token FCM
  try {
    final fcmToken = await messaging.getToken();
    print("FCM Token: $fcmToken");
  } catch (e) {
    print("Error getting FCM token: $e");
  }
  // --- Kết thúc cấu hình FCM ---

  runApp(AppProviders.wrapWithProviders(prefs: prefs, child: const MmsApp()));
}

/// Root application widget.
/// Only contains theme config and router config — all providers
/// and DI are handled by [AppProviders].
class MmsApp extends StatefulWidget {
  const MmsApp({super.key});

  @override
  State<MmsApp> createState() => _MmsAppState();
}

class _MmsAppState extends State<MmsApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = context.read<GoRouter>();
      final navContext = router.routerDelegate.navigatorKey.currentContext;
      if (navContext != null) {
        AppUpdateService.check(navContext);
      }
    });
  }

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
