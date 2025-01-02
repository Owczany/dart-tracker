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
    // Kolory
    // const Color bullseyeColor = Color;


    // Środek i promień tarczy
    final Offset center = Offset(0.5 * size.width, 0.5 * size.height);
    final double boardRadius = min(size.width, size.height) / 2;
    final double innerRadius = boardRadius * 0.65;
    final double bullseyeRadius = boardRadius * 0.125;
    final double sectorWidth = boardRadius * 0.1;

    final rectangle = Rect.fromCircle(center: center, radius: boardRadius);

    final innerRect = Rect.fromCircle(center: center, radius: innerRadius - 0.5 * sectorWidth);
    final outerRect = Rect.fromCircle(center: center, radius: boardRadius - 0.5 * sectorWidth);

    // Paints
    final backGroundColor = Paint()..color = Colors.white;

    final segmentPaint = Paint()..color = Colors.grey.shade800;

    final sectorPoint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    final innerBullseyePaint = Paint()..color = Colors.red;
    final outerBullseyePaint = Paint()..color = Colors.green;

    final wirePaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // TODO: Do zmiany połozenie
    const numberOfSegments = 20;
    const startAngle = -(11 / numberOfSegments) * pi;
    const sweepAngle = 2 * pi / 20;

    // Tło tarczy
    canvas.drawCircle(center, boardRadius, backGroundColor);

    // Kolory tarczy
    for (int i = 0; i < 20; i += 2) {
      canvas.drawArc(rectangle, startAngle + (sweepAngle * i), sweepAngle, true,
          segmentPaint);

      canvas.drawPath(
          Path()..addArc(outerRect, startAngle + (sweepAngle * i), sweepAngle),
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeWidth = sectorWidth);

      canvas.drawPath(
          Path()..addArc(innerRect, startAngle + (sweepAngle * i), sweepAngle),
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeWidth = sectorWidth);

      canvas.drawArc(rectangle, startAngle + (sweepAngle * i), sweepAngle, true,
          wirePaint);
    }

    segmentPaint.color = Colors.amberAccent;
    sectorPoint.color = Colors.blue;

    for (int i = 1; i < 20; i += 2) {
      canvas.drawArc(rectangle, startAngle + (sweepAngle * i), sweepAngle, true,
          segmentPaint);

      canvas.drawPath(
          Path()..addArc(outerRect, startAngle + (sweepAngle * i), sweepAngle),
          Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = sectorWidth);

      canvas.drawPath(
          Path()..addArc(innerRect, startAngle + (sweepAngle * i), sweepAngle),
          Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = sectorWidth);

      canvas.drawArc(rectangle, startAngle + (sweepAngle * i), sweepAngle, true,
          wirePaint);
    }

    segmentPaint.color = Colors.red;

    // Środek
    canvas.drawCircle(center, bullseyeRadius, outerBullseyePaint);

    canvas.drawCircle(center, bullseyeRadius / 2, innerBullseyePaint);

    // Rysuje szare druty

    // Zewnętrzne druty
    canvas.drawCircle(center, boardRadius - sectorWidth, wirePaint);

    // Wewnętrzne druty
    canvas.drawCircle(center, innerRadius, wirePaint);
    canvas.drawCircle(center, innerRadius - sectorWidth, wirePaint);

    // Środkowe druty
    canvas.drawCircle(center, bullseyeRadius, wirePaint);
    canvas.drawCircle(center, bullseyeRadius / 2, wirePaint);

    for (int i = 0; i < 20; i++) {
      canvas.clipPath(Path()..lineTo(10.0 * i, 10.0 * i));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}