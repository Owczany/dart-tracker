import 'package:darttracker/models/player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Match {
  final List<Player> players;
  int playerNumber;
  int roundNumber;
  final DateTime dateTime;

  Match({
    required this.players,
    this.playerNumber = 0,
    this.roundNumber = 1,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  void updatePlayerScore(int playerIndex, int score) {
    if (playerIndex >= 0 && playerIndex < players.length) {
      players[playerIndex].scores.add(score);
    }
  }

  void nextPlayer() {
    if (playerNumber == players.length - 1) {
      playerNumber = 0;
      roundNumber++;
    } else {
      playerNumber++;
    }
  }

  bool isGameOver() {
    // TODO: apply game over logic
    return false;
  }

  List<Player> getSortedPlayers() {
    List<Player> sortedPlayers = List.from(players);
    sortedPlayers.sort((a, b) => a.scores.last.compareTo(b.scores.last));
    return sortedPlayers;
  }

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((player) => player.toJson()).toList(),
      'playerNumber': playerNumber,
      'roundNumber': roundNumber,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static Match fromJson(Map<String, dynamic> json) {
    return Match(
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
      playerNumber: json['playerNumber'],
      roundNumber: json['roundNumber'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  static Future<void> saveMatch(Match match) async {
    final prefs = await SharedPreferences.getInstance();
    final matches = prefs.getStringList('matches') ?? [];
    matches.add(jsonEncode(match.toJson()));
    await prefs.setStringList('matches', matches);
  }

  static Future<List<Match>> loadMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final matches = prefs.getStringList('matches') ?? [];
    return matches
        .map((matchJson) => Match.fromJson(jsonDecode(matchJson)))
        .toList();
  }
}
