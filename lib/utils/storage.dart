import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:darttracker/models/match.dart';

class Storage {
  static Future<bool> saveMatch(Match match) async {
    final prefs = await SharedPreferences.getInstance();
    final matches = prefs.getStringList('matches') ?? [];
    final matchJson = jsonEncode(match.toJson());

    if (!matches.contains(matchJson)) {
      matches.add(matchJson);
      await prefs.setStringList('matches', matches);
      return true;
    }
    return false;
  }

  static Future<List<Match>> loadMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final matches = prefs.getStringList('matches') ?? [];
    return matches
        .map((matchJson) => Match.fromJson(jsonDecode(matchJson)))
        .toList();
  }
}
