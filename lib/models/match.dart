import 'package:darttracker/models/player.dart';

class Match {
  final List<Player> players;
  int playerNumber;
  int roundNumber;

  Match({
    required this.players,
    this.playerNumber = 0,
    this.roundNumber = 1,
  });
}
