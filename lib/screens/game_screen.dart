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
  late Match match;
  final List<Offset> throws = []; // Przechowuje współrzędne rzutu
  final GlobalKey dartboardKey = GlobalKey();

  // Kontrolery do przechowywania wartości z pól tekstowych
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  //Kontroler do utrzymywania powiększenia przy klikniękciu rzutu
  final TransformationController _transformController = TransformationController();



  @override
  void initState() {
    super.initState();
    match = widget.match;
  }

  /// metoda do wyliczania punktów na podstawie współrzędnych rzutu
  int calculateThrow(Offset throw_) {
    final RenderBox box =
        dartboardKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = box.size;
    return match.calculateThrow(throw_, size);
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
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              if (!Match.boardVersion)
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
                child: 
                  InteractiveViewer(  //powiększanie tarczy
                    transformationController: _transformController,
                    boundaryMargin: const EdgeInsets.all(20), // Margines do przewijania
                    minScale: 0.5,
                    maxScale: 3.0, 
                    
                    child: Stack (
                      children: [
                        Dartboard(key: dartboardKey, background: true),
                        if (Match.boardVersion)
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
                                  throws.add(/*box.globalToLocal*/ (details
                                      .localPosition));
                                });
                              }
                            },
                            child: CustomPaint(
                              painter: TouchPointsPainter(touchPositions: throws),
                              child:
                                Container(), //potrzebny, żeby był znany rozmiar obszaru do klikania
                            ),
                          ),
                      ]
                    )
                  ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //przycisk usunięcia ostatniego rzutu
                    if (Match.boardVersion)
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

                        if (Match.boardVersion) {
                          if (throws.length != 3) {
                            showSnackBar(context, "Mark 3 throws");
                          } else {
                            for (Offset throw_ in throws) {
                              points.add(calculateThrow(throw_));
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
                          //ustalanie punktacji obecnego gracza
                          bool counts = match.processThrows(points);
                          if (!counts) {
                            showSnackBar(context, "You have reached too many points this turn :(");
                          }
                          /*
                          int score;
                          match.roundNumber == 1
                              ? score = match.gameScore -
                                  (points[0] + points[1] + points[2])
                              : score = match.players[match.playerNumber]
                                      .scores[match.roundNumber - 2] -
                                  (points[0] + points[1] + points[2]);
                                  */
                          /*
                          match.players[match.playerNumber]
                              .scores[match.roundNumber - 1] = score;
                          */
                          /*
                          if (score >= 0) {
                            match.updatePlayerScore(match.playerNumber, score);
                          } else {
                            //gdy zdobył zbyt dużo punktów
                            showSnackBar(context, "You have reached too many points this turn :(");
                            match.updatePlayerScore(match.playerNumber, match.players[match.playerNumber]
                                                                          .scores[match.roundNumber - 2]);

                          }
                          */
                          //if (score == 0) {
                          if (match.isGameOver()) {
/*
                          if (score <= 0) {
                            match.updatePlayerScore(match.playerNumber, 0);
*/
                            /*if (match.roundNumber == 1) { //tak wsm to jest niemożliwe żeby ktoś wygrał w pierwszej turze
                              for (int i = match.playerNumber + 1;
                                  i < match.players.length;
                                  i++) {
                                match.players[i].scores[match.roundNumber - 1] =
                                    gameScore;
                              }
                            } else {*/
                            
                            //ustalanie punktacji pozostałych graczy przy wygranej obecnego gracza
                            /*for (int i = match.playerNumber + 1;
                                i < match.players.length;
                                i++) {
                              match.updatePlayerScore(i, match.players[i].scores[match.roundNumber - 2]);*/
                                //match.players[i].scores[match.roundNumber - 1] =
                                //    match.players[i]
                                //        .scores[match.roundNumber - 2];
                            //}

                            //odpowiednie przekierowanie jeśli już ktoś wygrał (wtedy jego wynik w ostatniej rundzie to 0)
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EndGameScreen(
                                  match: match,
                                ),
                              ),
                            );
                          } else {
                            //match.nextPlayer();
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
        ));
  }
}
