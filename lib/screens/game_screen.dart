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

import 'package:darttracker/components/own_button.dart';
import 'package:darttracker/models/player.dart';
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
  final List<Offset> points = []; // Przechowuje współrzędne dotknięcia

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Round ${widget.roundNumber}',
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
              widget.players[widget.playerNumber].name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                const Dartboard(),

                //zczytywanie kliknięć
                //FIXME: Przy najechaniu myszką na jeden z przycisków na dole ekranu uruchania się objekt TouchPointsPainter chuj wie czemu
                //FIXME: Dodatkowo chyba program nie ogarnia dużej ilości punktów
                //FIXME: No i skalowanie tu siada, punkty pojawiają się nie tam, gdzie się kliknie
                GestureDetector(
                  onTapDown: (details) {
                    // Przekształcenie globalnych współrzędnych na lokalne - okazuje się że nie trzeba tak robić
                    //final RenderBox box = context.findRenderObject() as RenderBox;
                    setState(() {
                      points.add(/*box.globalToLocal*/(details.localPosition));
                    });
                  },
                  child: CustomPaint(
                    painter: TouchPointsPainter(touchPositions: points),
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
                    setState(() {
                      if (points.isNotEmpty) {
                        points.removeLast(); // Usuwa ostatni punkt
                      }
                    });
                  },
                  color: Colors.red,
                  minimumSize: const Size(150, 50),
                ),

                // nawigacja do tabelki wyników
                OwnButton(
                  text: 'Confirm',
                  onPressed: () {
                    //TODO Dopisać punkty odpowiedniemu graczowi
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScoreBoardScreen(
                          players: widget.players,
                          playerNumber: (widget.playerNumber == widget.players.length - 1) ? 0 : widget.playerNumber + 1,
                          roundNumber: (widget.playerNumber == widget.players.length - 1) ? widget.roundNumber + 1 : widget.roundNumber,
                        ),
                      ),
                    );
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