import 'package:darttracker/models/player.dart';
import 'package:darttracker/screens/end_game_screen.dart';
import 'package:darttracker/screens/game_screen.dart';
import 'package:darttracker/screens/home_screen.dart';
import 'package:darttracker/screens/score_board_screen.dart';
//import 'package:darttracker/views/widgets/score_board.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
