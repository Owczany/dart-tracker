import 'package:darttracker/models/game_mode.dart';
import 'package:flutter/material.dart';

class GameSettingsNotifier extends ChangeNotifier {
  int _gameStartingScore = 501;
  bool _easyMode = false;
  bool _doubleIn = false;
  bool _doubleOut = false;
  bool _lowwerThan0 = false;
  

  int get gameStartingScore => _gameStartingScore;
  bool get easyMode => _easyMode;
  bool get doubleIn => _doubleIn;
  bool get doubleOut => _doubleOut;
  bool get lowwerThan0 => _lowwerThan0;

  void setGameStartingScore(int score) {
    _gameStartingScore = score;
    notifyListeners();
  }

  void setGameMode(bool doubleIn, bool doubleOut, bool lowwerThan0) {
    _doubleIn = doubleIn;
    _doubleOut = doubleOut;
    _lowwerThan0 = lowwerThan0;
    notifyListeners();
  }

  void toggleEasyMode() {
    _easyMode = !_easyMode;
    notifyListeners();
  }
}
