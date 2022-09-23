import 'package:flutter/material.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/pages/detail_page.dart';
import 'package:resto_app/pages/home_page.dart';
import 'package:resto_app/pages/splash_page.dart';
import 'package:resto_app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xffFC9630),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xffFC9630),
              secondary: const Color(0xffFED9B3),
              background: const Color(0xffF9EDE0),
            ),
        textTheme: const TextTheme(
          headline3: TextStyle(fontFamily: 'Oswald', color: Color(0xffF9EDE0)),
          headline5: TextStyle(
              fontFamily: 'PublicSans',
              fontWeight: semiBold,
              color: Color(0xffFC9630)),
          headline6: TextStyle(
              fontFamily: 'PublicSans',
              fontWeight: semiBold,
              color: Color(0xffFC9630)),
          subtitle1: TextStyle(
              fontFamily: 'PublicSans',
              fontWeight: medium,
              color: Colors.black),
          bodyText1: TextStyle(fontFamily: 'PublicSans', color: Colors.black),
          bodyText2: TextStyle(fontFamily: 'PublicSans', color: Colors.black),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashPage.routname,
      routes: {
        SplashPage.routname: (context) => const SplashPage(),
        HomePage.routename: (context) => const HomePage(),
        DetailPage.routeName: (context) => DetailPage(
            restaurant:
                ModalRoute.of(context)?.settings.arguments as RestaurantModel)
      },
    );
  }
}
