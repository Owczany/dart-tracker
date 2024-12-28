import 'package:flutter/material.dart';

class LightTheme {
  static final ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    primaryColor: const Color(0xFFD8C4B6),
    scaffoldBackgroundColor: const Color(0xFFF5EFE7),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD8C4B6),
    ),
  );
}

class DarkTheme {
  static final ThemeData themeData = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFBB86FC),
      secondary: Color(0xFF03DAC6),
      surface: Color(0xFF121212),
      error: Color(0xFFCF6679),
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFF000000),
      onSurface: Color(0xFFFFFFFF),
      onError: Color(0xFF000000),
    ),
    useMaterial3: true,
    primaryColor: const Color(0xFFBB86FC),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF3700B3),
    ),
  );
}
