import 'package:authcrypt/services/themePreferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemePrefrences themePrefrences = ThemePrefrences();
  bool _isDarkTheme = false;
  bool get getDarkTheme => _isDarkTheme;

  set setTheme(bool value) {
    _isDarkTheme = value;
    themePrefrences.setTheme(value);
    notifyListeners();
  }
}
