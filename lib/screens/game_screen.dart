import 'package:darttracker/views/widgets/dart_board/dartboard.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final String playerName;
  final int roundNumber;

  GameScreen({required this.playerName, required this.roundNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(      //kolor tła zrobić wg motywu (ciemny/jasny)
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Round $roundNumber',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
            child: Text(
              playerName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    // Tu dodać logikę cofania
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,    //dorobić kolorki
                    foregroundColor: Colors.black,
                    minimumSize: Size(150, 50),
                  ),
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Tu dodać logikę potwierdzania
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,  //tu też
                    foregroundColor: Colors.black,
                    minimumSize: Size(150, 50),
                  ),
                  child: Text('Confirm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}