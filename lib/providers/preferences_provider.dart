import 'package:flutter/material.dart';
import 'package:resto_app/data/preferences/preferences_helper.dart';
import 'package:resto_app/common/theme.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getTheme();
    _getRestaurantNotification();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  bool _enableNotification = false;
  bool get enableNotification => _enableNotification;

  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
  }

  void _getRestaurantNotification() async {
    _enableNotification = await preferencesHelper.enableNotification;
    notifyListeners();
  }

  void setEnableNotification(bool value) {
    preferencesHelper.setNotification(value);
    _getRestaurantNotification();
  }
}
