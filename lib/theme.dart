import 'package:flutter/material.dart';

const FontWeight light = FontWeight.w300;
const FontWeight regular = FontWeight.w400;
const FontWeight medium = FontWeight.w500;
const FontWeight semiBold = FontWeight.w600;
const FontWeight bold = FontWeight.w700;

const Color primaryColor = Color(0xffFC9630);
const Color secondaryColor = Color(0xffFED9B3);
const Color accentColor = Color(0xffFFFCFA);
const Color accentDarkColor = Color(0xff1E2938);
const Color backgroundColor = Color(0xffF9EDE0);
const Color backgroundDarkColor = Color(0xff15202E);
const Color blackColor = Color(0xFF050200);
const Color whiteColor = Color(0xffFFFCFA);
const Color greyColor = Color(0xff5B677F);
const Color lightGreyColor = Color(0xFF8D9DBD);

final lightTheme = ThemeData(
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: greyColor,
    tertiaryContainer: accentColor,
    onTertiaryContainer: whiteColor,
    background: backgroundColor,
    onBackground: blackColor,
  ),
  cardColor: whiteColor,
  textTheme: const TextTheme(
    headline3: TextStyle(fontFamily: 'Oswald', color: Color(0xffF9EDE0)),
    headline5: TextStyle(
        fontFamily: 'PublicSans', fontWeight: semiBold, color: primaryColor),
    headline6: TextStyle(
        fontFamily: 'PublicSans', fontWeight: semiBold, color: primaryColor),
    subtitle1: TextStyle(
        fontFamily: 'PublicSans', fontWeight: medium, color: blackColor),
    bodyText1: TextStyle(fontFamily: 'PublicSans', color: blackColor),
    bodyText2: TextStyle(fontFamily: 'PublicSans', color: blackColor),
    caption: TextStyle(fontFamily: 'PublicSans', color: greyColor),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: Colors.orange,
);

final darkTheme = ThemeData(
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: accentDarkColor,
    tertiary: lightGreyColor,
    tertiaryContainer: accentDarkColor,
    onTertiaryContainer: blackColor,
    background: backgroundDarkColor,
    onBackground: whiteColor,
  ),
  textTheme: const TextTheme(
    headline3: TextStyle(fontFamily: 'Oswald', color: Color(0xffF9EDE0)),
    headline5: TextStyle(
        fontFamily: 'PublicSans', fontWeight: semiBold, color: primaryColor),
    headline6: TextStyle(
        fontFamily: 'PublicSans', fontWeight: semiBold, color: primaryColor),
    subtitle1: TextStyle(
        fontFamily: 'PublicSans', fontWeight: medium, color: whiteColor),
    bodyText1: TextStyle(fontFamily: 'PublicSans', color: whiteColor),
    bodyText2: TextStyle(fontFamily: 'PublicSans', color: whiteColor),
    caption: TextStyle(fontFamily: 'PublicSans', color: lightGreyColor),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: Colors.orange,
);
