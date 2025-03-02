import 'package:darttracker/models/game_mode.dart';
import 'package:darttracker/models/player.dart';
import 'package:darttracker/utils/score_calculator.dart';
import 'package:darttracker/utils/storage.dart';
import 'package:flutter/material.dart';

class Match {
  final List<Player> players;
  int playerNumber;
  int roundNumber;
  final DateTime dateTime;
  final int gameStartingScore;
  final int gameMode;  //0 - easyMode, 1 - normalMode, 2 - customMode
  final bool doubleIn;
  final bool doubleOut;
  final bool lowwerThan0;

  Match({
    required this.players,
    this.playerNumber = 0,
    this.roundNumber = 1,
    DateTime? dateTime,
    required this.gameStartingScore,
    required this.gameMode,
    required this.doubleIn,
    required this.doubleOut,
    required this.lowwerThan0,
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
        ((!lowwerThan0 &&
            players[playerNumber].scores[roundNumber - 1] ==
                0) || //warunek zwycięstwa gdy lowerThan0 = false
          (lowwerThan0 &&
            players[playerNumber].scores[roundNumber - 1] <=
                0))) //warunek zwycięstwa gdy lowerThan0 = true
    {
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
    return Match(
        players: players,
        gameStartingScore: gameStartingScore,
        gameMode: gameMode,
        doubleIn: doubleIn,
        doubleOut: doubleOut,
        lowwerThan0: lowwerThan0
        );
  }

  /// Przypisuje punkty graczowi i zwraca informację, czy runda została uznana,
  ///0 - zero zostało przekroczone, 
  ///1 - osiągnięto jedynkę, 
  ///2 - żadne z powyższych
  int processThrows(List<int> points) {
    int howMuch;

    int score;
    roundNumber == 1
        ? score = gameStartingScore - (points[0] + points[1] + points[2])
        : score = players[playerNumber].scores[roundNumber - 2] -
            (points[0] + points[1] + points[2]);

    //lowerThan0 Mode On:
    if (lowwerThan0) {
      if (score >= 0) {
        updatePlayerScore(playerNumber, score);
      } else {
        updatePlayerScore(playerNumber, 0);
      }
      howMuch = 2;
    //lowerThan0 Mode off:
    } else {
      //runda zaliczona
      if (score >= 0 && score != 1) {
        updatePlayerScore(playerNumber, score);
        howMuch = 2;
      //runda niezaliczona
      } else {
        roundNumber == 1
            ? updatePlayerScore(playerNumber, gameStartingScore)
            : updatePlayerScore(
                playerNumber, players[playerNumber].scores[roundNumber - 2]);
        score == 1 
            ? howMuch = 1 
            : howMuch = 0;
      }
    }

    //przypisanie wyników pozostałym graczom przy wygranej obecnego
    if (isGameOver()) {
      for (int i = playerNumber + 1; i < players.length; i++) {
        if (players[i].scores.length >= roundNumber - 1) {
          if (roundNumber == 1) {
            updatePlayerScore(i, gameStartingScore);
          } else {
            updatePlayerScore(i, players[i].scores[roundNumber - 2]);
          }
        }
      }
    } else {
      nextPlayer();
    }
    return howMuch;
  }

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((player) => player.toJson()).toList(),
      'playerNumber': playerNumber,
      'roundNumber': roundNumber,
      'dateTime': dateTime.toIso8601String(),
      'gameStartingScore': gameStartingScore,
      'gameMode': gameMode,
      'doubleIn': doubleIn,
      'doubleOut': doubleOut,
      'lowwerThan0': lowwerThan0,
    };
  }

  static Match fromJson(Map<String, dynamic> json) {
    // Print all parameters before returning the Match object
    print('players: ${json['players']}');
    print('playerNumber: ${json['playerNumber']}');
    print('roundNumber: ${json['roundNumber']}');
    print('dateTime: ${json['dateTime']}');
    print('gameStartingScore: ${json['gameStartingScore']}');
    print('gameMode: ${json['gameMode']}');
    print('doubleIn: ${json['doubleIn']}');
    print('doubleIn: ${json['doubleIn']}');
    print('lowerThan0: ${json['lowerThan0']}');

//TODO: dokończ zapisywanie meczu
    return Match(
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
      playerNumber: json['playerNumber'],
      roundNumber: json['roundNumber'],
      dateTime: DateTime.parse(json['dateTime']),
      gameStartingScore: json['gameStartingScore'],
      gameMode: json['gameMode'],
      doubleIn: json['doubleIn'],
      doubleOut: json['doubleOut'],
      lowwerThan0: json['lowwerThan0'],
    );
  }

  static Future<void> saveMatch(Match match) async {
    await Storage.saveMatch(match);
  }

  static Future<List<Match>> loadMatches() async {
    return await Storage.loadMatches();
  }

  int calculateThrow(Offset throw_, Size size, bool needsDoubleIn) {
    return ScoreCalculator.calculateThrow(throw_, size, needsDoubleIn);
  }
}
