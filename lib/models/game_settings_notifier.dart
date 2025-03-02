import 'package:darttracker/models/game_mode.dart';
import 'package:flutter/material.dart';

class GameSettingsNotifier extends ChangeNotifier {
  int _gameStartingScore = 501;
  int _gameMode = 0;
  bool _doubleIn = false;
  bool _doubleOut = false;
  bool _lowwerThan0 = false;
  

  int get gameStartingScore => _gameStartingScore;
  int get gameMode => _gameMode;
  bool get doubleIn => _doubleIn;
  bool get doubleOut => _doubleOut;
  bool get lowwerThan0 => _lowwerThan0;

  void setGameStartingScore(int score) {
    _gameStartingScore = score;
    notifyListeners();
  }

  void setAllGameMode(int gameMode, bool doubleIn, bool doubleOut, bool lowwerThan0) {
    _gameMode = gameMode;
    _doubleIn = doubleIn;
    _doubleOut = doubleOut;
    _lowwerThan0 = lowwerThan0;
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
  void toggleLowwerThan0() {
    _lowwerThan0 = !_lowwerThan0;
    notifyListeners();
  }
/*
  void toggleEasyMode() {
    _easyMode = !_easyMode;
    notifyListeners();
  }
  */
}
