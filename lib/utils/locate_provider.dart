import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Klasa zarządzająca stanem języka
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    loadLocale(); // Załaduj zapisany język przy uruchomieniu
  }

  /// Ustawia nowy język i zapisuje go w SharedPreferences
  void setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
  }

  /// Ładuje zapisany język z SharedPreferences lub ustawia domyślny
  Future<void> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');
    String? countryCode = prefs.getString('country_code');

    if (langCode != null) {
      _locale =
          Locale(langCode, countryCode?.isEmpty ?? true ? null : countryCode);
      notifyListeners();
    }
  }
}
