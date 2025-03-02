import 'package:flutter/material.dart';

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
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFFFD700)),
    ),
  );
}
