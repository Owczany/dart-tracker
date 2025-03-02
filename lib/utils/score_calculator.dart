import 'dart:ui';
import 'dart:math';

class ScoreCalculator {
  static const List<List<int>> boardScores = [
    [3, 17, 2, 15, 10, 6, 13, 4, 18, 1, 20],
    [3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20]
  ];

  static int calculateThrow(Offset throw_, Size size, bool needsDoubleIn) {
    final Offset center = Offset(0.5 * size.width, 0.5 * size.height);
    final double boardRadius = min(size.width, size.height) / 2;
    final double innerRadius = boardRadius * 0.65; //wewnętrzny okrąg
    final double bullseyeRadius = boardRadius * 0.125; //środek
    final double sectorWidth = boardRadius * 0.1;

    final double distance = (throw_ - center).distance;
    if (distance > boardRadius) {
      return 0;
    }
    if (distance <= bullseyeRadius / 2) {
      return 50;
    }
    if (distance <= bullseyeRadius) {
      if (needsDoubleIn) {
        return 0;
      }
      return 25;
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
      if (needsDoubleIn) {
        return 0;
      }
      mult = 1;
    } else if (distance <= innerRadius) {
      if (needsDoubleIn) {
        return 0;
      }
      mult = 3;
    } else {
      mult = 2;
    }

    int i = 0;
    for (; i < 10; i++) {
      if (arcsin >= startAngle + i * sweepAngle &&
          arcsin <= startAngle + (i + 1) * sweepAngle) {
        if (throw_.dx > center.dx) {
          return mult * boardScores[0][i];
        } else {
          return mult * boardScores[1][i];
        }
      }
    }
    return mult * boardScores[0][i];
  }
}
