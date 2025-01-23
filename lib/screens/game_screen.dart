import 'dart:math';
import 'package:darttracker/models/match.dart';
import 'package:darttracker/widgets/components/our_wide_button.dart';
import 'package:darttracker/widgets/components/our_only_number_text_field.dart';
import 'package:darttracker/screens/end_game_screen.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/adapters/touch_points_painter.dart';
import '../widgets/adapters/dartboard.dart';

/// To jest ekran gry, gdzie gracz wklepuje swoje rzuty
class GameScreen extends StatefulWidget {
  final Match match;

  const GameScreen({super.key, required this.match});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  //TODO: przenieść to do ustawień
  final bool boardVersion = true; // true - dotykowa, false - wpisywanie ręczne

  late Match match;
  final List<Offset> throws = []; // Przechowuje współrzędne rzutu
  final GlobalKey dartboardKey = GlobalKey();

  // Zmienne do przechowywania wartości z pól tekstowych
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    match = widget.match;
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Round ${match.roundNumber}',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            // Nazwa gracza
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 0),
              child: Text(
                match.players[match.playerNumber].name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            if (!boardVersion)
              // Dodanie pól tekstowych, można wpisać tylko liczby
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OurOnlyNumberTextField(
                          controller: _controller1, text: 'Throw 1'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OurOnlyNumberTextField(
                          controller: _controller2, text: 'Throw 2'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OurOnlyNumberTextField(
                          controller: _controller3, text: 'Throw 3'),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: Stack(
                children: [
                  Dartboard(key: dartboardKey),
                  if (boardVersion)
                    //zczytywanie kliknięć
                    GestureDetector(
                      onTapDown: (details) {
                        //final RenderBox box = dartboardKey.currentContext!.findRenderObject() as RenderBox;

                        //ograniczenie na max 3 rzuty
                        if (throws.length == 3) {
                          showSnackBar(context, "You have only 3 darts!");
                        } else {
                          // Przekształcenie globalnych współrzędnych na lokalne
                          setState(() {
                            throws.add(
                                /*box.globalToLocal*/ (details.localPosition));
                          });
                        }
                      },
                      child: CustomPaint(
                        painter: TouchPointsPainter(touchPositions: throws),
                        child:
                            Container(), //potrzebny, żeby był znany rozmiar obszaru do klikania
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //przycisk usunięcia ostatniego rzutu
                  OurWideButton(
                    text: 'Cancel',
                    onPressed: () {
                      if (throws.isNotEmpty) {
                        throws.removeLast();
                      }
                    },
                    color: theme.colorScheme.error,
                    textColor: theme.colorScheme.onError,
                    minimumSize: const Size(150, 70),
                  ),

                  // nawigacja do tabelki wyników
                  OurWideButton(
                    text: 'Confirm',
                    onPressed: () {
                      List<int> points = [];

                      if (boardVersion) {
                        if (throws.length != 3) {
                          showSnackBar(context, "Mark 3 throws");
                        } else {
                          for (Offset throw_ in throws) {
                            final RenderBox box = dartboardKey.currentContext!
                                .findRenderObject() as RenderBox;
                            final Size size = box.size;
                            points.add(match.calculateThrow(throw_, size));
                          }
                        }
                      } else {
                        int? throw1 = int.tryParse(_controller1.text);
                        int? throw2 = int.tryParse(_controller2.text);
                        int? throw3 = int.tryParse(_controller3.text);

                        //sprawdzenie, czy wpisano tylko liczby
                        if (throw1 == null ||
                            throw2 == null ||
                            throw3 == null) {
                          showSnackBar(context, "Type all numbers");
                        } else {
                          points.add(throw1);
                          points.add(throw2);
                          points.add(throw3);
                        }
                      }

                      //sprawdzenie, czy ilość rzutów się zgadza
                      if (points.length == 3) {
                        match.processThrows(points);

                        if (match.isGameOver()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EndGameScreen(
                                match: match,
                              ),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScoreBoardScreen(
                                match: match,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    color: theme.colorScheme.secondary,
                    textColor: theme.colorScheme.onSecondary,
                    minimumSize: const Size(150, 70),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
