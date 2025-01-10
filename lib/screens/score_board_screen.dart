import 'package:darttracker/models/match.dart';
import 'package:darttracker/screens/game_screen.dart';
import 'package:darttracker/widgets/adapters/score_board.dart';
import 'package:flutter/material.dart';


class ScoreBoardScreen extends StatelessWidget {
  final Match match;

  const ScoreBoardScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scores after each round'),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  //tabelka wyników
                  child: Center(
                    child: ScoreBoard(players: match.players),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //przekierowanie spowrotem do game_screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(match: match),
                        ),
                      );
                    },
                    //wyświetlanie nazwy zastępnego gracza na przycisku
                    child: Center(
                      child: Text(
                        'Now player ${match.players[match.playerNumber].name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
