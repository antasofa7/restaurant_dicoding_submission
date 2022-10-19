import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/pages/detail_page.dart';
import 'package:resto_app/pages/home_page.dart';
import 'package:resto_app/pages/search_page.dart';
import 'package:resto_app/pages/splash_page.dart';
import 'package:resto_app/providers/connectivity_provider.dart';
import 'package:resto_app/providers/restaurant_detail_provider.dart';
import 'package:resto_app/providers/restaurant_provider.dart';
import 'package:resto_app/providers/search_restaurant_provider.dart';
import 'package:resto_app/providers/theme_notifier.dart';
import 'package:resto_app/theme.dart';

void main() {
  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(lightTheme), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.light;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
          create: (context) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider<SearchRestaurantProvider>(
          create: (context) =>
              SearchRestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (context) =>
              RestaurantDetailProvider(apiService: ApiService(), id: ''),
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
            create: (context) => ConnectivityProvider()),
      ],
      child: Consumer<ThemeNotifier>(builder: (context, value, _) {
        return MaterialApp(
          theme: value.getTheme(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: SplashPage.routName,
          routes: {
            SplashPage.routName: (context) => const SplashPage(),
            HomePage.routeName: (context) => const HomePage(),
            DetailPage.routeName: (context) => const DetailPage(),
            SearchPage.routeName: (context) => const SearchPage(),
          },
        );
      }),
    );
  }
}
