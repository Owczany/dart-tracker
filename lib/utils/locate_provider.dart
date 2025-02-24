
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui'; // Dla domyślnego locale

/// Klasa zarządzająca stanem języka
class LocaleProvider extends ChangeNotifier {
  Locale _locale = PlatformDispatcher.instance.locale;

  Locale get locale => _locale;

  LocaleProvider() {
    loadLocale(); // Załaduj zapisany język przy uruchomieniu
  }

  void setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
  }

  Future<void> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');
    String? countryCode = prefs.getString('country_code');

    if (langCode != null) {
      _locale = Locale(langCode, countryCode?.isEmpty ?? true ? null : countryCode);
      notifyListeners();
    }
  }
}