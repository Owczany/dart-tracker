import 'package:flutter/material.dart';

/// Klasa zarządzająca stanem ustawień gry
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

  /// Ustawia początkowy wynik w meczu
  void setGameStartingScore(int score) {
    _gameStartingScore = score;
    notifyListeners();
  }

  /// Ustawia wszystkie parametry meczu
  void setAllGameMode({required int gameMode, required bool doubleIn, required bool doubleOut, required bool lowerThan0, required bool removeLastRound}) {
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
  /// Dba o spójność ustawień
  /// Jeżeli gracz nie musi osiągnąć 0 ostatnim rzutem oraz nie musi nim trafić w podwójne pole, kara jest ustawiana na wartość domyślną
  void validateSettings() {
    if (lowerThan0 && !doubleOut) {
      _removeLastRound = true;
    }
  }
}
