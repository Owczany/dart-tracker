// TODO: dodać obsługę motywów kolorystycznych
// TODO: dodać zaznaczanie rzutów na tarczy;

/*dane testowe:
players: [
        Player(name: 'Gracz 1', scores: [1, 2, 3]),
        Player(name: 'Gracz 2', scores: [4, 5, 6]),
        Player(name: 'Gracz 3', scores: [7, 8, 9]),
        Player(name: 'Gracz 4', scores: [10, 11, 12]),

      ], playerNumber: 3, roundNumber: 5
*/

import 'dart:io';

import 'package:darttracker/components/own_button.dart';
import 'package:darttracker/models/player.dart';
import 'package:darttracker/screens/end_game_screen.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/views/widgets/dart_board/dartboard.dart';
import 'package:darttracker/views/widgets/dart_board/touch_points_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late List<Player> players;
  late int playerNumber;
  late int roundNumber;
  final List<Offset> throws = []; // Przechowuje współrzędne rzutu

  //int throwNumber = 0;  //numer rzutu

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
  
  ///metoda do wyznaczania ilości zdobytych punktów na podstawnie miejsca trafirnia w tarczę
    //FIXME: Napisz mnie
  int calculatePoints(List<Offset> throws) {
    Size size = MediaQuery.of(context).size;
    
    
    
    return HttpStatus.notImplemented;
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

          // Dodanie pól tekstowych, można wpisać tylko liczby
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(labelText: 'Throw 1'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller2,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(labelText: 'Throw 2'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller3,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(labelText: 'Throw 3'),
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            child: Stack(
              children: [
                const Dartboard(),

                //zczytywanie kliknięć
                GestureDetector(
                  onTapDown: (details) {
                    
                    // Przekształcenie globalnych współrzędnych na lokalne - okazuje się że nie trzeba tak robić
                    //final RenderBox box = context.findRenderObject() as RenderBox;
                    setState(() {
                      throws.add(/*box.globalToLocal*/(details.localPosition));
                    });
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
                      throws.removeLast(); // Usuwa ostatni punkt
                      //throwNumber --;
                    }
                  },
                  color: Colors.red,
                  minimumSize: const Size(150, 50),
                ),

                // nawigacja do tabelki wyników
                OwnButton(
                  text: 'Confirm',
                  onPressed: () {
                    /*  używane przy klikaniu, narazie zbędne
                    if ( !(throws.length == 3)) {
                      //TODO: pop-up, że za mało punktów zostało wprowadzone
                    }
                    // obliczanie punktów gracza po tej rundzie
                    else if (roundNumber == 1) {
                      players[playerNumber].scores[roundNumber - 1] = 501 - calculatePoints(throws);
                    } else {
                      players[playerNumber].scores[roundNumber - 1] = players[playerNumber].scores[roundNumber - 2] - calculatePoints(throws);
                    }
                    */

                    //dodanie kolejnej runduy do list wyników
                    if (players[0].scores.length < roundNumber) {
                      for (var player in players) {
                        player.scores.add(0);
                      }
                    }

                    //TODO: zrobić ładniej
                    //jeśli nie ma trzech wartości to nie puści dalej
                    int? throw1 = int.tryParse(_controller1.text);
                    int? throw2 = int.tryParse(_controller2.text);
                    int? throw3 = int.tryParse(_controller3.text);

                    if (throw1 == null || throw2 == null || throw3 == null) {
                      // Jeden z wpisanych tekstów nie jest liczbą
                      // TODO: Wyświetl komunikat o błędzie
                    }
                    else {
                      int score = 0;
                      if (roundNumber == 1) {
                        score = 501 - (throw1 + throw2 + throw3);
                      } else {
                        score = players[playerNumber].scores[roundNumber - 2] - (throw1 + throw2 + throw3);
                      }
                      players[playerNumber].scores[roundNumber - 1] = score;

                      //odpowiednie przekierowanie jeśli już ktoś wygrał (wtedy jego wynik w ostatniej rundzie to 0)
                      if (players[playerNumber].scores[roundNumber - 1] <= 0) {
                        players[playerNumber].scores[roundNumber - 1] = 0;
                        
                        roundNumber == 1 ? score = 501 : score = players[playerNumber].scores[roundNumber - 2];
                        for (int i = playerNumber + 1; i < players.length; i ++) {
                          players[playerNumber].scores[roundNumber - 1] = score;
                        }
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
          ),
        ],
      ),
    );
  }
}