import 'package:flutter/material.dart';

class LightTheme {
  static final ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      primary: const Color(0xFFC8AD90),
      secondary: const Color(0xFF6AAE70),
      surface: const Color(0xFFFFFFFF),
      error: const Color(0xFFE6758B),
      onPrimary: const Color(0xFF000000),
      onSecondary: const Color(0xFF000000),
      onSurface: const Color(0xFF000000),
      onError: const Color(0xFF000000),
    ),
    useMaterial3: true,
    primaryColor: const Color(0xFFD8C4B6),
    scaffoldBackgroundColor: const Color(0xFFF5EFE7),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD8C4B6),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
    ),
  );
}


