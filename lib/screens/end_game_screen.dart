import 'package:darttracker/models/match.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/widgets/components/our_wide_button.dart';
import 'package:darttracker/screens/home_screen.dart';
import 'package:darttracker/widgets/adapters/score_board.dart';
import 'package:flutter/material.dart';

class EndGameScreen extends StatefulWidget {
  final Match match;
  final bool hideButtons;

  const EndGameScreen(
      {super.key, required this.match, this.hideButtons = false});

  @override
  EndGameScreenState createState() => EndGameScreenState();
}

class EndGameScreenState extends State<EndGameScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.match.players[widget.match.playerNumber].name} won!'),
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
                    child: ScoreBoard(match: widget.match, endOfGame: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //przycisk powrotu do HomeScreen
                      if (!widget.hideButtons) ...[
                        const SizedBox(height: 16), // Odstęp między przyciskami
                        //przycisk zapisu gry do pamięci
                        OurWideButton(
                          text: 'Save the game...',
                          onPressed: () async {
                            await Match.saveMatch(widget.match);
                            if (!mounted) return;
                            showSnackBar("Game saved successfully!");
                          },
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16), // Odstęp między przyciskami

                        //przycisk nowej szybkiej gry
                        OurWideButton(
                          text: 'Quick start',
                          onPressed: () {
                            final newMatch = widget.match.quickStart();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScoreBoardScreen(match: newMatch),
                              ),
                            );
                          },
                          color: theme.colorScheme.secondary,
                          textColor: theme.colorScheme.onSecondary,
                        ),
                      ],
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

  void showSnackBar(String text) {
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
}
