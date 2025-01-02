/* to do:
 *  dodać obsługę motywów kolorystycznych
 *  dodać zaznaczanie rzutów na tarczy;
 *  dodać logikę powtarzania wprowadzania wyników rzucania;
 *  dodać dopisywanie punkty odpowiedniemu graczowi;
 *  dodać przekierowanie do EndGameScreen, jeśli gracz właśnie wygrał - wtedy nie większać numeru gracza;
*/
/*dane testowe:
players: [
        Player(name: 'Gracz 1', scores: [1, 2, 3]),
        Player(name: 'Gracz 2', scores: [4, 5, 6]),
        Player(name: 'Gracz 3', scores: [7, 8, 9]),
        Player(name: 'Gracz 4', scores: [10, 11, 12]),

      ], playerNumber: 3, roundNumber: 5
*/

import 'package:darttracker/models/player.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/views/widgets/dart_board/dartboard.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final List<Player> players;
  final int playerNumber;
  final int roundNumber;

  GameScreen(
      {required this.players, this.playerNumber = 0, this.roundNumber = 1});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      //kolor tła zrobić wg motywu (ciemny/jasny)
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Round $roundNumber',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),

      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 0),
              child: Text(
                players[playerNumber].name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Expanded(
              child: Center(
                child: Dartboard(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // Tu dodać logikę powtarzania wprowadzania wyników rzucania
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                        minimumSize: Size(150, 70),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        // Dopisać punkty odpowiedniemu graczowi
                        Navigator.pushReplacement(
                          context,
                          //dodać przekierowanie do EndGameScreen, jeśli gracz właśnie wygrał - wtedy nie większać numeru gracza

                          //przekierowanie do ScoreBoardScreen ze zmienionym graczem i rundą
                          MaterialPageRoute(
                            builder: (context) => ScoreBoardScreen(
                              players: players,
                              playerNumber: (playerNumber == players.length - 1)
                                  ? 0
                                  : playerNumber + 1,
                              roundNumber: (playerNumber == players.length - 1)
                                  ? roundNumber + 1
                                  : roundNumber,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary, //tu też
                        foregroundColor: theme.colorScheme.onSecondary,
                        minimumSize: Size(150, 70),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
