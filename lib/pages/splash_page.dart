import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resto_app/common/theme.dart';
import 'package:resto_app/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  static const routName = '/splash';
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
              HomePage.routeName,
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
            Image.asset(
              'assets/dish.png',
              width: 100.0,
            ),
            const SizedBox(
              height: 24.0,
            ),
            Text(
              'RestoApp',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: backgroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
