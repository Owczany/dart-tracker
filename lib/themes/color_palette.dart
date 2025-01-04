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

class DarkTheme {
  static final ThemeData themeData = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9840FF),
      secondary: Color(0xFF2D7731),
      surface: Color(0xFF121212),
      error: Color(0xFF9F4759),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      onError: Color(0xFFFFFFFF),
    ),
    useMaterial3: true,
    primaryColor: const Color(0xFFBB86FC),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF9A4DFA),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
    ),
  );
}
