import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = LightTheme.themeData;

  ThemeData get currentTheme => _currentTheme;

  ThemeNotifier() {
    _loadTheme();
  }

  void toggleTheme() {
    if (_currentTheme == LightTheme.themeData) {
      _currentTheme = DarkTheme.themeData;
    } else {
      _currentTheme = LightTheme.themeData;
    }
    _saveTheme();
    notifyListeners();
  }

  void _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _currentTheme == DarkTheme.themeData);
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _currentTheme = isDarkTheme ? DarkTheme.themeData : LightTheme.themeData;
    notifyListeners();
  }
}
