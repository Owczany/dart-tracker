import 'package:darttracker/screens/end_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/match.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: Text(AppLocalizations.of(context)!.match_history),
      content: FutureBuilder<List<Match>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            //TODO: usuń print
            print('blaaad: ${snapshot.error}');
            return Text(AppLocalizations.of(context)!.history_loading_error);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text(AppLocalizations.of(context)!.history_noone_found);
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
                        '$formattedDate - ${match.players.length} ${match.players.length > 1 ? AppLocalizations.of(context)!.players : AppLocalizations.of(context)!.player}'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              EndGameScreen(match: match, hideButtons: true)));
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
          child: Text(AppLocalizations.of(context)!.close),
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
