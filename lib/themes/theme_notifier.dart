import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = LightTheme.themeData;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme == LightTheme.themeData) {
      _currentTheme = DarkTheme.themeData;
    } else {
      _currentTheme = LightTheme.themeData;
    }
    notifyListeners();
  }
}
