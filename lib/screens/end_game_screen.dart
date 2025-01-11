import 'package:darttracker/models/match.dart';
import 'package:darttracker/widgets/components/our_wide_button.dart';
import 'package:darttracker/screens/home_screen.dart';
import 'package:darttracker/widgets/adapters/score_board.dart';
import 'package:flutter/material.dart';

class EndGameScreen extends StatelessWidget {
  final Match match;

  const EndGameScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${match.players[match.playerNumber].name} is Winning!'),
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
                    child: ScoreBoard(match: match, endOfGame: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    //przycisk powrotu do HomeScreen
                    OurWideButton(
                      text: 'Back to Main Menu',
                      onPressed: () {
                        //przekierowanie do HomeScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16), // Odstęp między przyciskami

                    //przycisk zapisu gry do pamięci
                    OurWideButton(
                      text: 'Save a Game',
                      onPressed: () {
                        //TODO: tu dorobić zapisanie gry
                      },
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16), // Odstęp między przyciskami

                    //przycisk nowej szybkiej gry
                    OurWideButton(
                      text: 'Quick Start',
                      onPressed: () {
                        //TODO: tu zrobić szybki start
                      },
                      color: Colors.green,
                    ),
                  ],
                ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
