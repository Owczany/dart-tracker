import 'package:flutter/material.dart';

/// Zaznacza miejsce dotknięcia tarczy
class TouchPointsPainter extends CustomPainter {
  final List<Offset> touchPositions;

  TouchPointsPainter({required this.touchPositions});

  @override
  void paint(Canvas canvas, Size size) {
    // Rysowanie miejsc dotknięcia
    if (touchPositions != []) {
      final Paint touchPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      // Rysuje kółko w miejscu dotknięcia
      for (Offset point in touchPositions){
        canvas.drawCircle(point, 10.0, touchPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Zwraca true, aby ponownie narysować, gdy touchPosition się zmieni
  }
}