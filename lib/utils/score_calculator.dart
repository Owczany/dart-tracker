import 'dart:ui';
import 'dart:math';

import 'package:darttracker/models/pair.dart';

class ScoreCalculator {
  static const List<List<int>> boardScores = [
    [3, 17, 2, 15, 10, 6, 13, 4, 18, 1, 20],
    [3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20]
  ];

  static Pair<int, int> calculateThrow(Offset throw_, Size size) {
    final Offset center = Offset(0.5 * size.width, 0.5 * size.height);
    final double boardRadius = min(size.width, size.height) / 2;
    final double innerRadius = boardRadius * 0.65; //wewnętrzny okrąg
    final double bullseyeRadius = boardRadius * 0.125; //środek
    final double sectorWidth = boardRadius * 0.1;

    final double distance = (throw_ - center).distance;
    if (distance > boardRadius) {
      return Pair(0, 1);
    }
    if (distance <= bullseyeRadius / 2) {
      return Pair(25, 2);
    }
    if (distance <= bullseyeRadius) {
      return Pair(25, 1);
    }

    //arcsin(x) należy do [-pi/2 ; pi/2]
    double arcsin = asin((-throw_.dy + (size.height / 2)) /
        distance); //sprowadzenie punktów do układu współrzędnych, gdzie środek tarczy ma (0,0)
    const numberOfSegments = 20;
    const startAngle = -11 / numberOfSegments * pi;
    const sweepAngle = 2 * pi / numberOfSegments;

    int mult;
    if (distance < innerRadius - sectorWidth ||
        (distance > innerRadius && distance < boardRadius - sectorWidth)) {
      mult = 1;
    } else if (distance <= innerRadius) {
      mult = 3;
    } else {
      mult = 2;
    }

    int i = 0;
    for (; i < 10; i++) {
      if (arcsin >= startAngle + i * sweepAngle &&
          arcsin <= startAngle + (i + 1) * sweepAngle) {
        if (throw_.dx > center.dx) {
          return Pair(boardScores[0][i], mult);
        } else {
          return Pair(boardScores[1][i] ,mult);
        }
      }
    }
    return Pair(boardScores[0][i] ,mult);
  }
}
