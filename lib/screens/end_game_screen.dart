/* To do:
 * dodać obsługę motywów kolorystycznych
 * logika przycisku zapisu gry do pamięci
 * logika przycisku nowej szybkiej gry
*/

import 'package:darttracker/models/player.dart';
import 'package:darttracker/screens/home_screen.dart';
import 'package:darttracker/views/widgets/score_board.dart';
import 'package:flutter/material.dart';

class EndGameScreen extends StatelessWidget {
  final List<Player> players;
  final int playerNumber;
  final int roundNumber;

  EndGameScreen({required this.players, required this.playerNumber, required this.roundNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${players[playerNumber].name} is Winning!'), //dodam tu wygranego, jak ustalimy strukturę danych do przekazywania graczy, 
        //już widać, że sortowanie graczy trzeba wynieść poza score_board
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // Szerokość na cały ekran, wysokość 50
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //przekierowanie do HomeScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Center(
                        child: Text('Back to Main Menu'),
                      ),
                    ),
                    SizedBox(height: 16), // Odstęp między przyciskami

                    //przycisk zapisu gry do pamięci
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // Szerokość na cały ekran, wysokość 50
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        // tu zapisanie gry
                      },
                      child: Center(
                        child: Text('Save a Game'),
                      ),
                    ),
                    SizedBox(height: 16), // Odstęp między przyciskami

                    //przycisk nowej szybkiej gry 
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // Szerokość na cały ekran, wysokość 50
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        // tu szybki start
                      },
                      child: Center(
                        child: Text('Quick Start'),
                      ),
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