import 'package:darttracker/models/pair.dart';
import 'package:darttracker/models/player.dart';
import 'package:darttracker/utils/score_calculator.dart';
import 'package:darttracker/utils/storage.dart';
import 'package:flutter/material.dart';

/// Możliwe komunikaty przy próbie zakończenia rundy, jeżeli liczba rzutów się zgadza
enum RoundResult {
    allThrowsAccepted, // - wszystkie rzuty zostały uznane
    someThrowsInvalidLowerThan0, // - niektóre rzuty się nie liczą, przez lowerThan0
    someThrowsInvalidDoubleIn, // - niektóre rzuty się nie liczą, przez doubleIn
    lastThrowInvalidDoubleOut, // - ostatni rzut się nie liczy przez doubleOut
    someThrowsInvalidLowerThan0AndDoubleOut, // - niektóre rzuty się nie liczą przez lowerThan0 oraz doubleOut
    roundInvalidLowerThan0, // - runda się nie liczy przez lowerThan0
    roundInvalidDoubleOut, // - runda się nie liczy przez doubleOut
  }

///Klasa zarządzająca stanem pojedynczego meczu
class Match {
  final List<Player> players;
  int playerNumber;
  int roundNumber;
  final DateTime dateTime;
  final int gameStartingScore;
  final int gameMode;  //0 - easyMode, 1 - normalMode, 2 - customMode
  final bool doubleIn;
  final bool doubleOut;
  final bool lowerThan0;
  final bool removeLastRound; // true - przy przekroczeniu 0 lub nietrafieniu podwójnego pola cała runda jest niezaliczona, false - konkretne rzuty są niezaliczone

  Match({
    required this.players,
    this.playerNumber = 0,
    this.roundNumber = 1,
    DateTime? dateTime,
    required this.gameStartingScore,
    required this.gameMode,
    required this.doubleIn,
    required this.doubleOut,
    required this.lowerThan0,
    required this.removeLastRound,
  }) : dateTime = dateTime ?? DateTime.now();

  ///Dopisuje danemu graczowi punkty za ostatnią rundę
  void updatePlayerScore(int playerIndex, int score) {
    if (playerIndex >= 0 && playerIndex < players.length) {
      players[playerIndex].scores.add(score);
    }
  }

  ///Ustawia playerNumber na numer następnego gracza w kolejce
  void nextPlayer() {
    if (playerNumber == players.length - 1) {
      playerNumber = 0;
      roundNumber++;
    } else {
      playerNumber++;
    }
  }

  ///Sprawdza, czy aktualny gracz wygrał w obecnj turze
  bool isGameOver() {
    if (players[playerNumber].scores.isNotEmpty &&
        players[playerNumber].scores.length >= roundNumber &&
        (lowerThan0 
            ? players[playerNumber].scores[roundNumber - 1] <= 0
            : players[playerNumber].scores[roundNumber - 1] == 0))
        /*
        ((!lowerThan0 &&
            players[playerNumber].scores[roundNumber - 1] ==
                0) || //warunek zwycięstwa gdy lowerThan0 = false
          (lowerThan0 &&
            players[playerNumber].scores[roundNumber - 1] <=
                0))) //warunek zwycięstwa gdy lowerThan0 = true
        */
    {
      return true;
    }
    return false;
  }

  ///Zwraca listę graczy posortowaną według ich wyników w ostatniej turze
  List<Player> getSortedPlayers() {
    List<Player> sortedPlayers = List.from(players);
    sortedPlayers.sort((a, b) => a.scores.last.compareTo(b.scores.last));
    return sortedPlayers;
  }

  ///Iniciuje nową grę z ustawieniami właśnie zakończonej
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
        lowerThan0: lowerThan0,
        removeLastRound: removeLastRound
        );
  }
  /// Przypisuje punkty graczowi i zwraca informację, czy runda została uznana.
  /// Podlicza punkty zdobyte w obecnej rundzie na podstawi listy par(wartość rzutu, mnożnik rzutu)
  /// biorąc pod uwagę ustawienia trudności rozgrywki
  RoundResult processThrows(List<Pair<int, int>> points) {
    points.removeWhere((e) => e.left == 0);
    RoundResult message = RoundResult.allThrowsAccepted;
    int score;
    int getsPoints = 0;

    int beforeScore =
        roundNumber == 1 
            ? gameStartingScore 
            : players[playerNumber].scores[roundNumber - 2];

    //wpisywanie punktów przy doubleIn
    if (doubleIn) {
      for (int i = 0; i < points.length; i++) {
        if (players[playerNumber].getsIn ||
            points[i].right == 2) {
          players[playerNumber].getsIn = true;
          getsPoints += points[i].left * points[i].right;
        } else {
          message = RoundResult.someThrowsInvalidDoubleIn;
        }
      }
    } else {
      for (int i = 0; i < points.length; i++) {
        getsPoints += points[i].left * points[i].right;
      }
    }
    score = beforeScore - getsPoints;

    //klasyczna wersja z usuwaniem całej rundy
    if (removeLastRound){
      if (lowerThan0 && !doubleOut) {
        if (score <= 0) {
          updatePlayerScore(playerNumber, 0);
        } else {
          updatePlayerScore(playerNumber, score);
        }
      } else if (!lowerThan0 && doubleOut) {
        if (score < 0) {
          updatePlayerScore(playerNumber, beforeScore);
          message = RoundResult.roundInvalidLowerThan0;
        } else if (score == 0) {
          if (points.last.right == 2) {
            updatePlayerScore(playerNumber, 0);
          } else {
            updatePlayerScore(playerNumber, beforeScore);
            message = RoundResult.roundInvalidDoubleOut;
          }
        } else if (score == 1) {
          updatePlayerScore(playerNumber, beforeScore);
          message = RoundResult.roundInvalidDoubleOut;
        } else {
          updatePlayerScore(playerNumber, score);
        }
      } else if (!lowerThan0 && !doubleOut) {
        if (score < 0) {
          updatePlayerScore(playerNumber, beforeScore);
          message = RoundResult.roundInvalidLowerThan0;
        } else {
          updatePlayerScore(playerNumber, score);
        }
      } else if (lowerThan0 && doubleOut) {
        if (score <= 0) {
          if (points.last.right == 2) {
            updatePlayerScore(playerNumber, 0);
          } else {
            updatePlayerScore(playerNumber, beforeScore);
            message = RoundResult.roundInvalidDoubleOut;
          }
        } else {
          updatePlayerScore(playerNumber, score);
        }
      }
    } else {  //usuwane są tylko niepoprawne rzuty
      bool end = false;
      if (score < 0) {
        if (!lowerThan0) {
          while (score < 0) {
            score += points.last.left * points.last.right;
            points.removeLast();
            message = RoundResult.someThrowsInvalidLowerThan0;
          }
        } else {
          if (!doubleOut) {
            updatePlayerScore(playerNumber, 0);
            end = true;
          } else {
            /*
            while (score + (points.last.left * points.last.right) < 0) {
              score += points.last.left * points.last.right;
              points.removeLast();
              message = 0;
            }
            */
            if (points.last.right == 2) {
              updatePlayerScore(playerNumber, 0);
              end = true;
            } else {
              score += points.last.left * points.last.right;
              points.removeLast();
              message == RoundResult.someThrowsInvalidLowerThan0
                  ? message = RoundResult.someThrowsInvalidLowerThan0AndDoubleOut
                  : message = RoundResult.lastThrowInvalidDoubleOut;
            }
          }
        }
      }
      if (points.isEmpty) {
        updatePlayerScore(playerNumber, score);
        end = true;
      }
      if (!end) {
        if (score == 0) {
          if (doubleOut) {
            if (points.last.right == 2) {
              updatePlayerScore(playerNumber, score);
            } else {
              score += points.last.left * points.last.right;
              updatePlayerScore(playerNumber, score);
              message == RoundResult.someThrowsInvalidLowerThan0
                  ? message = RoundResult.someThrowsInvalidLowerThan0AndDoubleOut
                  : message = RoundResult.lastThrowInvalidDoubleOut;
            }
          }
        } else if (score == 1) {
          if (doubleOut) {
            if (lowerThan0) {
              updatePlayerScore(playerNumber, score);
            } else {
              score += points.last.left * points.last.right;
              updatePlayerScore(playerNumber, score);
              message == RoundResult.someThrowsInvalidLowerThan0
                  ? message = RoundResult.someThrowsInvalidLowerThan0AndDoubleOut
                  : message = RoundResult.lastThrowInvalidDoubleOut;
            }
          } else {
            updatePlayerScore(playerNumber, score);
          }
        } else if (score > 1) {
            updatePlayerScore(playerNumber, score);
        }
      }
    }

    // Przypisanie wyników pozostałym graczom przy wygranej obecnego
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
    return message;
  }

  /// Konwerteruje obiekt Match do formatu JSON
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
      'lowerThan0': lowerThan0,
      'removeLastRound': removeLastRound,
    };
  }

  /// Konwerteruje obiekt Match z formatu JSON
  static Match fromJson(Map<String, dynamic> json) {
    // Print all parameters before returning the Match object
    /*
    print('players: ${json['players']}');
    print('playerNumber: ${json['playerNumber']}');
    print('roundNumber: ${json['roundNumber']}');
    print('dateTime: ${json['dateTime']}');
    print('gameStartingScore: ${json['gameStartingScore']}');
    print('gameMode: ${json['gameMode']}');
    print('doubleIn: ${json['doubleIn']}');
    print('doubleIn: ${json['doubleIn']}');
    print('lowerThan0: ${json['lowerThan0']}');
    */

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
      lowerThan0: json['lowerThan0'],
      removeLastRound: json['removeLastRound'],
    );
  }

  /// Zapisuje mecz do historii
  static Future<bool> saveMatch(Match match) async {
    return await Storage.saveMatch(match);
  }

  /// Odczytuje wszystkie zapisane mecze
  static Future<List<Match>> loadMatches() async {
    return await Storage.loadMatches();
  }

  /// Oblicza wartość pojedynczego rzutu i jego mnożnik
  Pair<int, int> calculateThrow(Offset throw_, Size size) {
    return ScoreCalculator.calculateThrow(throw_, size);
  }
}
