// TODO: dodać obsługę motywów kolorystycznych

import 'package:darttracker/components/own_button.dart';
import 'package:darttracker/models/player.dart';
import 'package:darttracker/screens/home_screen.dart';
import 'package:darttracker/views/widgets/score_board.dart';
import 'package:flutter/material.dart';

/// To jest ekran końca gry
class EndGameScreen extends StatelessWidget {
  final List<Player> players;
  final int playerNumber;
  final int roundNumber;

  const EndGameScreen({super.key, required this.players, required this.playerNumber, required this.roundNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${players[playerNumber].name} is Winning!'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                //tabelka wyników
                child: Center(
                  child: ScoreBoard(players: players, endOfGame: true),
                ),

              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    //przycisk powrotu do HomeScreen
                    OwnButton(
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
                    OwnButton(
                      text: 'Save a Game',
                      onPressed: () {
                        //TODO: tu dorobić zapisanie gry
                      },
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16), // Odstęp między przyciskami

                    //przycisk nowej szybkiej gry 
                    OwnButton(
                      text: 'Quick Start',
                      onPressed: () {
                        //TODO: tu zrobić szybki start
                      },
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}