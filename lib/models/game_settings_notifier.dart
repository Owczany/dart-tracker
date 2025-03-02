import 'package:flutter/material.dart';

class GameSettingsNotifier extends ChangeNotifier {
  int _gameStartingScore = 501;
  int _gameMode = 0;
  bool _doubleIn = false;
  bool _doubleOut = false;
  bool _lowerThan0 = true;
  

  int get gameStartingScore => _gameStartingScore;
  int get gameMode => _gameMode;
  bool get doubleIn => _doubleIn;
  bool get doubleOut => _doubleOut;
  bool get lowerThan0 => _lowerThan0;

  void setGameStartingScore(int score) {
    _gameStartingScore = score;
    notifyListeners();
  }

  void setAllGameMode(int gameMode, bool doubleIn, bool doubleOut, bool lowerThan0) {
    _gameMode = gameMode;
    _doubleIn = doubleIn;
    _doubleOut = doubleOut;
    _lowerThan0 = lowerThan0;
    notifyListeners();
  }
  void toggleDoubleIn() {
    _doubleIn = !_doubleIn;
    notifyListeners();
  }
  void toggleDoubleOut() {
    _doubleOut = !_doubleOut;
    notifyListeners();
  }
  void togglelowerThan0() {
    _lowerThan0 = !_lowerThan0;
    notifyListeners();
  }
/*
  void toggleEasyMode() {
    _easyMode = !_easyMode;
    notifyListeners();
  }
  */
}
