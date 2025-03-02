import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DartboardNotifier extends ChangeNotifier {
  bool _showNumbers = false;
  bool _boardVersion = true;

  bool get showNumbers => _showNumbers;
  bool get boardVersion => _boardVersion; //true - dotykowa, false - manualna

  DartboardNotifier() {
    _loadSettings();
  }

  void toggleShowNumbers() {
    _showNumbers = !_showNumbers;
    _saveSettings();
    notifyListeners();
  }

  void toggleBoardVersion() {
    _boardVersion = !_boardVersion;
    _saveSettings();
    notifyListeners();
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showNumbers', _showNumbers);
    await prefs.setBool('boardVersion', _boardVersion);
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _showNumbers = prefs.getBool('showNumbers') ?? false;
    _boardVersion = prefs.getBool('boardVersion') ?? true;
    notifyListeners();
  }
}
