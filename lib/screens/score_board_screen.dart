// TODO: dodać obsługę motywów kolorystycznych


import 'package:darttracker/components/own_button.dart';
import 'package:darttracker/models/player.dart';
import 'package:darttracker/screens/game_screen.dart';
import 'package:darttracker/views/widgets/score_board.dart';
import 'package:flutter/material.dart';

/// To jest ekran wyników po każdej rundzie
class ScoreBoardScreen extends StatelessWidget {
  final List<Player> players;
  final int playerNumber;
  final int roundNumber;
  
  const ScoreBoardScreen({super.key, required this.players, required this.playerNumber, required this.roundNumber});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scores after each round'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                //tabelka wyników
                child: Center(
                  child: ScoreBoard(players: players),
                ),
              ),

              //przycisk przejścia do następnej tury
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OwnButton(
                  text: 'Next player: ${players[playerNumber].name}',
                  onPressed: () {
                    //przekierowanie spowrotem do game_screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen(players: players, playerNumber: playerNumber, roundNumber : roundNumber)),
                    );
                  },
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
