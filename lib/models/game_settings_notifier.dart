import 'package:flutter/material.dart';

class GameSettingsNotifier extends ChangeNotifier {
  int _gameStartingScore = 501;
  bool _easyMode = false;

  int get gameStartingScore => _gameStartingScore;
  bool get easyMode => _easyMode;

  void setGameStartingScore(int score) {
    _gameStartingScore = score;
    notifyListeners();
  }

  void toggleEasyMode() {
    _easyMode = !_easyMode;
    notifyListeners();
  }
}
