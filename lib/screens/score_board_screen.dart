import 'package:darttracker/components/own_button.dart';
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
      body: Container (
        color: theme.scaffoldBackgroundColor,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  //tabelka wyników
                  child: Center(
                    child: ScoreBoard(match: match),
                  ),
                ),

                //przycisk przejścia do następnej tury
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OwnButton(
                    text: 'Next player: ${match.players[match.playerNumber].name}',
                    onPressed: () {
                      //przekierowanie spowrotem do game_screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GameScreen(match: match)),
                      );
                    },
                    color: theme.colorScheme.primary,
                    textColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ]
        )
      )
    );
  }
}
