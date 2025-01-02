/* To do:
 * dodać obsługę motywów kolorystycznych
 */

import 'package:darttracker/models/player.dart';
import 'package:darttracker/screens/game_screen.dart';
import 'package:darttracker/views/widgets/score_board.dart';
import 'package:flutter/material.dart';

class ScoreBoardScreen extends StatelessWidget {
  final List<Player> players;
  final int playerNumber;
  final int roundNumber;
  
  ScoreBoardScreen({required this.players, required this.playerNumber, required this.roundNumber});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores after each round'),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 70), 
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //przekierowanie spowrotem do game_screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen(players: players, playerNumber: playerNumber, roundNumber : roundNumber)),
                    );
                  },
                  //wyświetlanie nazwy zastępnego gracza na przycisku
                  child: Center(
                    child: Text(
                      'Now player ${players[playerNumber].name}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
