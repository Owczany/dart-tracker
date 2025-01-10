import 'package:darttracker/models/match.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/widgets/adapters/dartboard.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final Match match;

  const GameScreen({super.key, required this.match});

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
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 0),
              child: Text(
                match.players[match.playerNumber].name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      minimumSize: const Size(150, 70),
                    ),
                    child: const Text(
                      "Back",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      match.updatePlayerScore(
                          match.playerNumber, 50); // Przykładowy wynik
                      match.nextPlayer();
                      Navigator.pushReplacement(
                        context,
                        //dodać przekierowanie do EndGameScreen, jeśli gracz właśnie wygrał - wtedy nie większać numeru gracza

                        //przekierowanie do ScoreBoardScreen ze zmienionym graczem i rundą
                        MaterialPageRoute(
                          builder: (context) => ScoreBoardScreen(match: match),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                      minimumSize: const Size(150, 70),
                    ),
                    child: const Text(
                      "Confirm",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
