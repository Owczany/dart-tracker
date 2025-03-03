import 'package:flutter/material.dart';

class GameSettingsNotifier extends ChangeNotifier {
  int _gameStartingScore = 501;
  int _gameMode = 0;
  bool _doubleIn = false;
  bool _doubleOut = false;
  bool _lowerThan0 = true;
  bool _removeLastRound = true;
  

  int get gameStartingScore => _gameStartingScore;
  int get gameMode => _gameMode;
  bool get doubleIn => _doubleIn;
  bool get doubleOut => _doubleOut;
  bool get lowerThan0 => _lowerThan0;
  bool get removeLastRound => _removeLastRound;

  void setGameStartingScore(int score) {
    _gameStartingScore = score;
    notifyListeners();
  }

  void setAllGameMode(int gameMode, bool doubleIn, bool doubleOut, bool lowerThan0, bool removeLastRound) {
    _gameMode = gameMode;
    _doubleIn = doubleIn;
    _doubleOut = doubleOut;
    _lowerThan0 = lowerThan0;
    _removeLastRound = removeLastRound;
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
  void toggleLowerThan0() {
    _lowerThan0 = !_lowerThan0;
    notifyListeners();
  }
  void toggleRemoveLastRound() {
    _removeLastRound = !_removeLastRound;
    notifyListeners();
  }
  void validateSettings() {
    if (lowerThan0 && !doubleOut) {
      _removeLastRound = true;
    }
  }
/*
  void toggleEasyMode() {
    _easyMode = !_easyMode;
    notifyListeners();
  }
  */
}
