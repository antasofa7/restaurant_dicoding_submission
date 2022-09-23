import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resto_app/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  static const routname = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(
        const Duration(milliseconds: 3000),
        () => Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.routename,
              (route) => false,
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: Theme.of(context).colorScheme.background,
              size: 80.0,
            ),
            Text(
              'RestoApp',
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
      ),
    );
  }
}
