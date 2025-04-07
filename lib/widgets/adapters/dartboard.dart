import 'dart:math';
import 'package:darttracker/models/dartboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tarcza do gry dartboard
class Dartboard extends StatelessWidget {
  final bool isMainMenu;
  const Dartboard({super.key, this.isMainMenu = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dartboardNotifier = Provider.of<DartboardNotifier>(context);

    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: DartBoardPainter(
            //background: isMainMenu ? false : dartboardNotifier.boardVersion,
            theme: theme,
            showNumbers: isMainMenu ? false : dartboardNotifier.showNumbers,
          ),
        ),
      ),
    );
  }
}

class DartBoardPainter extends CustomPainter {
  //final bool background;
  final bool showNumbers;
  final ThemeData theme;
  DartBoardPainter(
      {//required this.background,
      required this.theme,
      required this.showNumbers});

  @override
  void paint(Canvas canvas, Size size) {
    // Środek i promień tarczy
    final Offset center = Offset(0.5 * size.width, 0.5 * size.height);
    final double boardRadius = min(size.width, size.height) / 2;
    final double innerRadius = boardRadius * 0.65;
    final double bullseyeRadius = boardRadius * 0.125;
    final double sectorWidth = boardRadius * 0.1;

    final rectangle = Rect.fromCircle(center: center, radius: boardRadius);

    final innerRect = Rect.fromCircle(
        center: center, radius: innerRadius - 0.5 * sectorWidth);
    final outerRect = Rect.fromCircle(
        center: center, radius: boardRadius - 0.5 * sectorWidth);

    final Paint backGroundColor = Paint()..color = Colors.white;

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

    const numberOfSegments = 20;
    const startAngle = 1 / numberOfSegments * pi;
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

    // Wpisz wartości pól, jeżeli drawNumbers = true
    if (showNumbers) {
      final numberPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      final mult2Painter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      final mult3Painter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      final numberStyle = TextStyle(
        color: Colors.black,
        fontSize: boardRadius * 0.1,
        fontWeight: FontWeight.bold,
      );

      final multStyle = TextStyle(
          color: const Color.fromARGB(207, 32, 27, 184),
          fontSize: boardRadius * 0.075,
          fontWeight: FontWeight.bold);

      mult2Painter.text = TextSpan(
        text: 'x2',
        style: multStyle,
      );
      mult3Painter.text = TextSpan(
        text: 'x3',
        style: multStyle,
      );
      final numbers = [
        '10',
        '15',
        '2',
        '17',
        '3',
        '19',
        '7',
        '16',
        '8',
        '11',
        '14',
        '9',
        '12',
        '5',
        '20',
        '1',
        '18',
        '4',
        '13',
        '6'
      ];

      for (int i = 0; i < 20; i++) {
        final angle = startAngle + (sweepAngle * i) + (sweepAngle / 2);

        final xMult2 = center.dx + (boardRadius * 0.95) * cos(angle);
        final yMult2 = center.dy + (boardRadius * 0.95) * sin(angle);

        final xNumber = center.dx + (boardRadius * 0.78) * cos(angle);
        final yNumber = center.dy + (boardRadius * 0.78) * sin(angle);

        final xMult3 = center.dy + (boardRadius * 0.6) * cos(angle);
        final yMult3 = center.dy + (boardRadius * 0.6) * sin(angle);

        numberPainter.text = TextSpan(
          text: numbers[i],
          style: numberStyle,
        );

        numberPainter.layout();
        numberPainter.paint(
          canvas,
          Offset(xNumber - numberPainter.width / 2,
              yNumber - numberPainter.height / 2),
        );
        mult2Painter.layout();
        mult2Painter.paint(
          canvas,
          Offset(xMult2 - mult2Painter.width / 2,
              yMult2 - mult2Painter.height / 2),
        );
        mult3Painter.layout();
        mult3Painter.paint(
          canvas,
          Offset(xMult3 - mult3Painter.width / 2,
              yMult3 - mult3Painter.height / 2),
        );
      }
      //rysiowanie liczb na środku tarczy
      final middleNumberPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      middleNumberPainter.text = TextSpan(
          text: '50',
          style: TextStyle(
              color: Colors.green,
              fontSize: boardRadius * 0.075,
              fontWeight: FontWeight.bold));
      middleNumberPainter.layout();
      middleNumberPainter.paint(
          canvas,
          Offset(center.dx - middleNumberPainter.width / 2,
              center.dy - middleNumberPainter.height / 2));

      middleNumberPainter.text = TextSpan(
          text: '25',
          style: TextStyle(
              color: Colors.red,
              fontSize: boardRadius * 0.065,
              fontWeight: FontWeight.bold));
      middleNumberPainter.layout();
      middleNumberPainter.paint(
          canvas,
          Offset(
              center.dx - middleNumberPainter.width / 2,
              center.dy -
                  middleNumberPainter.height / 2 -
                  (boardRadius * 0.093)));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
