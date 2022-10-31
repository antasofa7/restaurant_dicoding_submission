import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/navigation.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/data/preferences/preferences_helper.dart';
import 'package:resto_app/pages/detail_page.dart';
import 'package:resto_app/pages/home_page.dart';
import 'package:resto_app/pages/search_page.dart';
import 'package:resto_app/pages/settings_page.dart';
import 'package:resto_app/pages/splash_page.dart';
import 'package:resto_app/providers/connectivity_provider.dart';
import 'package:resto_app/providers/database_provider.dart';
import 'package:resto_app/providers/preferences_provider.dart';
import 'package:resto_app/providers/restaurant_provider.dart';
import 'package:resto_app/providers/scheduling_provider.dart';
import 'package:resto_app/providers/search_restaurant_provider.dart';
import 'package:resto_app/utils/background_service.dart';
import 'package:resto_app/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Restaurant provider
        ChangeNotifierProvider<RestaurantProvider>(
          create: (context) =>
              RestaurantProvider(apiService: ApiService(client: http.Client())),
        ),
        // Restaurant search provider
        ChangeNotifierProvider<SearchRestaurantProvider>(
          create: (context) => SearchRestaurantProvider(
              apiService: ApiService(client: http.Client())),
        ),
        // Scheduling provider
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        // Connectivity provider
        ChangeNotifierProvider<ConnectivityProvider>(
            create: (context) => ConnectivityProvider()),
        // Preferences provider
        ChangeNotifierProvider<PreferencesProvider>(
          create: (context) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                  sharedPreferences: SharedPreferences.getInstance())),
        ),
        // Database provider
        ChangeNotifierProvider<DatabaseProvider>(
          create: (context) =>
              DatabaseProvider(databaseHelper: DatabaseHelper()),
        )
      ],
      child: Consumer<PreferencesProvider>(builder: (context, provider, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: provider.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: SplashPage.routName,
          routes: {
            SplashPage.routName: (context) => const SplashPage(),
            HomePage.routeName: (context) => const HomePage(),
            DetailPage.routeName: (context) => DetailPage(
                  id: ModalRoute.of(context)!.settings.arguments as String,
                ),
            SearchPage.routeName: (context) => const SearchPage(),
            SettingsPage.routeName: (context) => const SettingsPage()
          },
        );
      }),
    );
  }
}
