import 'package:flutter/material.dart';

class DartboardNotifier extends ChangeNotifier {
  bool _showNumbers = false;
  bool _boardVersion = true;

  bool get showNumbers => _showNumbers;
  bool get boardVersion => _boardVersion;

  void toggleShowNumbers() {
    _showNumbers = !_showNumbers;
    notifyListeners();
  }

  void toggleBoardVersion() {
    _boardVersion = !_boardVersion;
    notifyListeners();
  }
}
