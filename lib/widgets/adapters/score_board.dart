import 'package:flutter/material.dart';
import 'package:darttracker/models/player.dart';
import 'package:darttracker/models/match.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoreBoard extends StatelessWidget {
  final Match match;
  final bool endOfGame; // endOfGame: true - kolorowanie i sortowanie wygranych po ostatniej rundzie

  const ScoreBoard({super.key, required this.match, this.endOfGame = false});

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 52.0;
    final double tableHeight = rowHeight * (match.players.length + 1) +
        4; // ramka ma 2 piksele, więc trza tu dodać 4
    return Padding(
      padding:
          const EdgeInsets.all(30.0), // Dodanie odstępów od krawędzi ekranu
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: tableHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          child: DataTable(
            columns: _buildColumns(context),
            rows: _buildRows(context),
            dataRowMinHeight: rowHeight,
            dataRowMaxHeight: rowHeight,
            headingRowHeight: rowHeight,
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(label: Text(AppLocalizations.of(context)!.player)),
    ];
    int maxRounds = match.players
        .map((player) => player.scores.length)
        .reduce((a, b) => a > b ? a : b);
    String round = AppLocalizations.of(context)!.round;
    for (int i = 0; i < maxRounds; i++) {
      columns.add(DataColumn(label: Text('$round ${i + 1}')));
    }
    return columns;
  }

  List<DataRow> _buildRows(BuildContext context) {
    List<Player> displayPlayers =
        endOfGame ? match.getSortedPlayers() : match.players;

    return displayPlayers.map((player) {
      List<DataCell> cells = [
        DataCell(Text(player.name)),
      ];

      cells.addAll(player.scores
          .map((score) => DataCell(Text(score.toString())))
          .toList());

      // Ensure the number of cells matches the number of columns
      while (cells.length < _buildColumns(context).length) {
        cells.add(const DataCell(Text('')));
      }

      // If endOfGame, add row color for top 3 players
      Color? rowColor;
      if (endOfGame) {
        int index = displayPlayers.indexOf(player);
        if (index == 0) {
          rowColor =
              Colors.amberAccent.withOpacity(0.9); // Gold color for the best
        } else if (index == 1) {
          rowColor = const Color.fromRGBO(
              192, 192, 192, 0.9); // Silver color for second
        } else if (index == 2) {
          rowColor =
              const Color.fromRGBO(205, 127, 50, 0.9); // Bronze color for third
        }
      }

      return DataRow(
        cells: cells,
        color: rowColor != null
            ? WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                return rowColor;
              })
            : null,
      );
    }).toList();
  }
}
