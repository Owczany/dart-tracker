import 'package:darttracker/models/player.dart';
import 'package:darttracker/views/widgets/score_board.dart';
import 'package:flutter/material.dart';

class ScoreBoardScreen extends StatelessWidget {
  final List<Player> players;
  
//players: [Player(name: 'Gracz 1', scores: [600, 23, 5], ), Player(name: 'Gracz 2', scores: [600, 22, 0])]   - dane testowe
  ScoreBoardScreen({required this.players});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores after each round'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: ScoreBoard(players: players),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                // tu przekierowanie spowrotem do game_screen
              },
              child: Center(
                child: Text('Now player XYZ'), //jak będą przekazywane dane, o tym czyja jest tura to tu będzie nazwa następnego gracza
              ),
            ),
          ),
        ],
      ),
    );
  }
}
