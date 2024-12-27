import 'dart:math';

import 'package:flutter/material.dart';

class Dartboard extends StatelessWidget {
  const Dartboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: DartBoardPainter(),
        ),
      ),
    );
  }
}

class DartBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Środek i promień tarczy
    final Offset center = Offset(0.5 * size.width, 0.5 * size.height);
    final double boardRadius = min(size.width, size.height) / 2;
    final double innerRadius = boardRadius * 0.7;
    final double bullseyeRadius = boardRadius * 0.1;
    final double sectorWidth = boardRadius * 0.05;

    // Paints
    final wirePaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const numberOfSegments = 20;
    const startAngle = -(11 / numberOfSegments) * pi;
    const sweepAngle = 2 * pi / 20;

    // Paints
    final rectangle = Rect.fromCircle(center: center, radius: boardRadius);
    // Tło tarczy
    final backGroundColor = Paint()..color = Colors.white;
    canvas.drawCircle(center, boardRadius, backGroundColor);

    // Jeden taki trójkącik
    final trainglePaint = Paint()..color = Colors.grey.shade800;
    final aPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    for (int i = 0; i < 20; i += 2) {
      canvas.drawArc(rectangle, startAngle + (sweepAngle * i), sweepAngle, true,
          trainglePaint);
    }

    trainglePaint.color = Colors.amberAccent;
    aPaint.color = Colors.blue;
    for (int i = 1; i < 20; i += 2) {
      canvas.drawArc(rectangle, startAngle + (sweepAngle * i), sweepAngle, true,
          trainglePaint);

      canvas.drawPath(
          Path()..addArc(rectangle, startAngle, sweepAngle),
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeWidth = 20.0);
      // canvas.drawPath(Path().., Paint());
    }

    trainglePaint.color = Colors.red;

    // Środek
    final innerBullseyePaint = Paint()..color = Colors.red;
    final outerBullseyePaint = Paint()..color = Colors.green;

    canvas.drawCircle(center, bullseyeRadius, outerBullseyePaint);

    canvas.drawCircle(center, bullseyeRadius / 2, innerBullseyePaint);

    // Szare druty
    canvas.drawCircle(
        center,
        bullseyeRadius,
        outerBullseyePaint
          ..color = Colors.grey.shade600
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0);

    canvas.drawCircle(
        center,
        bullseyeRadius / 2,
        innerBullseyePaint
          ..color = Colors.grey.shade600
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0);

    canvas.drawCircle(center, boardRadius, wirePaint);
    canvas.drawCircle(center, boardRadius - sectorWidth, wirePaint);

    canvas.drawCircle(center, innerRadius, wirePaint);
    canvas.drawCircle(center, innerRadius - sectorWidth, wirePaint);

    for ( int i = 0; i < 20; i++ ) {
      canvas.clipPath(Path()..lineTo(10.0 * i, 10.0 * i));
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
