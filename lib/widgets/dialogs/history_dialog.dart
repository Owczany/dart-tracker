import 'package:darttracker/screens/end_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/match.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:intl/intl.dart';

class HistoryDialog extends StatefulWidget {
  const HistoryDialog({super.key});

  @override
  HistoryDialogState createState() => HistoryDialogState();
}

class HistoryDialogState extends State<HistoryDialog> {
  late Future<List<Match>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = Match.loadMatches();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Match History'),
      content: FutureBuilder<List<Match>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error loading matches');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No matches found');
          } else {
            final matches = snapshot.data!;
            matches.sort((a, b) => b.dateTime.compareTo(a.dateTime));
            return SizedBox(
              height: 400, // Ustalona wysokość dla ListView
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  final formattedDate =
                      DateFormat('dd-MM-yyyy HH:mm').format(match.dateTime);
                  return ListTile(
                    title: Text(
                        '$formattedDate - ${match.players.length} players'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => EndGameScreen(match: match, hideButtons: true)));
                    },
                  );
                },
              ),
            );
          }
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

void showHistoryDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const HistoryDialog();
    },
  );
}
