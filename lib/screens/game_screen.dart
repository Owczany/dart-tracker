// TODO: dodać obsługę motywów kolorystycznych
import 'dart:math';

import 'package:darttracker/components/own_button.dart';
import 'package:darttracker/components/own_only_number_text_firld.dart';
import 'package:darttracker/models/player.dart';
import 'package:darttracker/screens/end_game_screen.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/views/widgets/dart_board/dartboard.dart';
import 'package:darttracker/views/widgets/dart_board/touch_points_painter.dart';
import 'package:flutter/material.dart';

/// To jest ekran gry, gdzie gracz wklepuje swoje rzuty
class GameScreen extends StatefulWidget {
  final List<Player> players;
  final int playerNumber;
  final int roundNumber;

  const GameScreen({super.key, required this.players, this.playerNumber = 0, this.roundNumber = 1});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //TODO: przenieść to do ustawień
  final bool boardVersion = true; // true - dotykowa, false - wpisywanie ręczne
  final int gameScore = 501;

  late List<Player> players;
  late int playerNumber;
  late int roundNumber;
  final List<Offset> throws = []; // Przechowuje współrzędne rzutu
  final GlobalKey dartboardKey = GlobalKey();
  final List<List<int>> boardScores = [[3, 17, 2, 15, 10, 6, 13, 4, 18, 1, 20], [3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20]];

  // Zmienne do przechowywania wartości z pól tekstowych
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    players = widget.players;
    playerNumber = widget.playerNumber;
    roundNumber = widget.roundNumber;
  }
  
  
    //FIXME: Dokończ mnie
  /// metoda do wyliczania punktów na podstawie współrzędnych rzutu
  int calculateThrow(Offset throw_) {
    final RenderBox box = dartboardKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = box.size;
    final Offset center = Offset(0.5 * size.width, 0.5 * size.height);
    final double boardRadius = min(size.width, size.height) / 2;
    final double innerRadius = boardRadius * 0.65;  //wewnętrzny okrąg
    final double bullseyeRadius = boardRadius * 0.125;  //środek
    final double sectorWidth = boardRadius * 0.1;

    final double distance = (throw_ - center).distance;
    if (distance > boardRadius) {
      return 0;
    }
    if (distance <= bullseyeRadius / 2) {
      return 50;
    }
    if (distance <= bullseyeRadius) {
      return 25;
    }

    //arcsin należy do [-pi/2 ; pi/2]
    double arcsin = asin((-throw_.dy + (size.height / 2)) / distance); //sprowadzenie punktów do układu współrzędnych, gdzie środek tarczy ma (0,0)
    const numberOfSegments = 20;
    const startAngle = - 11 / numberOfSegments * pi;
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
    for (; i < 10; i ++) {
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

  void showSnackBar(BuildContext context, String text) {
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
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Round $roundNumber',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          // Nazwa gracza
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
            child: Text(
              players[playerNumber].name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    child: OwnOnlyNumberTextFirld(controller: _controller1, text: 'Throw 1'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OwnOnlyNumberTextFirld(controller: _controller2, text: 'Throw 2'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OwnOnlyNumberTextFirld(controller: _controller3, text: 'Throw 3'),
                  ),
                ],
              ),
            ),

          Expanded(
            child: Stack(
              children: [
                Dartboard(key : dartboardKey),
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
                          throws.add(/*box.globalToLocal*/(details.localPosition));
                        });
                      }
                    },
                    child: CustomPaint(
                      painter: TouchPointsPainter(touchPositions: throws),
                      child: Container(), //potrzebny, żeby był znany rozmiar obszaru do klikania
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
                OwnButton(
                  text: 'Cancel',
                  onPressed: () {
                    if (throws.isNotEmpty) {
                      throws.removeLast();
                    }
                  },
                  color: Colors.red,
                  minimumSize: const Size(150, 50),
                ),

                // nawigacja do tabelki wyników
                OwnButton(
                  text: 'Confirm',
                  onPressed: () {

                    //dodanie kolejnej runduy do list wyników
                    if (players[0].scores.length < roundNumber) {
                      for (var player in players) {
                        player.scores.add(0);
                      }
                    }

                    //TODO: zrobić ładniej
                    
                    List<int> points = [];

                    if (boardVersion) {
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
                      if (throw1 == null || throw2 == null || throw3 == null) {
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
                      int score = 0;
                      roundNumber == 1 
                        ? score = gameScore - (points[0] + points[1] + points[2])
                        : score = players[playerNumber].scores[roundNumber - 2] - (points[0] + points[1] + points[2]);
                      
                      players[playerNumber].scores[roundNumber - 1] = score;

                      if (players[playerNumber].scores[roundNumber - 1] <= 0) {
                        players[playerNumber].scores[roundNumber - 1] = 0;
                        
                        //ustalanie punktacji pozostałych graczy przy wygranej obecnego gracza
                        if (roundNumber == 1){
                          for (int i = playerNumber + 1; i < players.length; i ++) {
                            players[i].scores[roundNumber - 1] = gameScore;
                          }
                        } else {
                          for (int i = playerNumber + 1; i < players.length; i ++) {
                            players[i].scores[roundNumber - 1] = players[i].scores[roundNumber - 2];
                          }
                        }

                        //odpowiednie przekierowanie jeśli już ktoś wygrał (wtedy jego wynik w ostatniej rundzie to 0)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EndGameScreen(
                              players: players,
                              playerNumber: playerNumber,
                              roundNumber: roundNumber,
                            ),
                          ),
                        );
                      }
                      else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScoreBoardScreen(
                              players: players,
                              playerNumber: (playerNumber == players.length - 1) ? 0 : playerNumber + 1,
                              roundNumber: (playerNumber == players.length - 1) ? roundNumber + 1 : roundNumber,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  color: Colors.green,
                  minimumSize: const Size(150, 50),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
