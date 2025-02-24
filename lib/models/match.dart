import 'package:darttracker/models/player.dart';
import 'package:darttracker/utils/score_calculator.dart';
import 'package:darttracker/utils/storage.dart';
import 'package:flutter/material.dart';

class Match {
  final List<Player> players;
  int playerNumber;
  int roundNumber;
  final DateTime dateTime;
  static int gameScore = 501;
  static bool boardVersion = true; // true - dotykowa, false - wpisywanie ręczne
  static bool showNumbers = false; // true - rysowanie numerów na tarczy
  static ValueNotifier<bool> showNumbersNotifier = ValueNotifier(showNumbers);
  static ValueNotifier<bool> boardversionNotifier = ValueNotifier(boardVersion);

  bool get boardversion => boardVersion;

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
    if (players[playerNumber].scores.isNotEmpty &&
        players[playerNumber].scores.length >= roundNumber &&
        players[playerNumber].scores[roundNumber - 1] == 0) {

      for (int i = playerNumber + 1; i < players.length - 1; i++) {
        if (players[i].scores.length >= roundNumber - 1) {
          updatePlayerScore(i, players[i].scores[roundNumber - 2]);
        }
      }
      return true;
    }
    return false;
  }

  List<Player> getSortedPlayers() {
    List<Player> sortedPlayers = List.from(players);
    sortedPlayers.sort((a, b) => a.scores.last.compareTo(b.scores.last));
    return sortedPlayers;
  }

  Match quickStart() {
    for (var player in players) {
      player.resetScores();
    }
    return Match(players: players);
  }
  /// Przypisuje punkty graczowi i zwraca informację, czy runda została uznana,
  /// true - poprawne przypisanie, false - przekroczona wartść 0
  bool processThrows(List<int> points) {
    
    bool tooMuch;

    int score;
    roundNumber == 1
      ? score = gameScore - (points[0] + points[1] + points[2])
      : score = players[playerNumber].scores[roundNumber - 2] -
          (points[0] + points[1] + points[2]);
    if (score >= 0) {
      updatePlayerScore(playerNumber, score);
      tooMuch = false;
    } else {
      roundNumber == 1
        ? updatePlayerScore(playerNumber, gameScore)
        : updatePlayerScore(playerNumber, players[playerNumber].scores[roundNumber - 2]);
      tooMuch = true;
    }
    
    if (!isGameOver()) {
      nextPlayer();
    }
    return tooMuch;
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
    await Storage.saveMatch(match);
  }

  static Future<List<Match>> loadMatches() async {
    return await Storage.loadMatches();
  }

  int calculateThrow(Offset throw_, Size size) {
    return ScoreCalculator.calculateThrow(throw_, size);
  }
}
