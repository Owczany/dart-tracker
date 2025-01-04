import 'package:flutter/material.dart';
import 'package:darttracker/models/player.dart';

class ScoreBoard extends StatelessWidget {
  final List<Player> players;
  final bool endOfGame;  //endOfGame: true - kolorowanie i sortowanie wygranych po ostatniej rundzie

  const ScoreBoard({super.key, required this.players, this.endOfGame = false});

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 52.0;
    final double tableHeight = rowHeight * (players.length + 1) + 4;  //ramka ma 2 piksele, więc trza tu dodać 4 
    return Padding(
      padding: const EdgeInsets.all(30.0), // Dodanie odstępów od krawędzi ekranu
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container (
          height: tableHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          child: DataTable(
            columns: _buildColumns(),
            rows: _buildRows(),
            dataRowHeight: rowHeight,
            headingRowHeight: rowHeight,
          ),
        )
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    List<DataColumn> columns = [
      const DataColumn(label: Text('Player')),
    ];
    for (int i = 0; i < players[0].scores.length; i++) {
      columns.add(DataColumn(label: Text('Round ${i + 1}')));
    }
    return columns;
  }

  List<DataRow> _buildRows() {
    //normalne wyświetlanie wyników
    if (!endOfGame) {
      return players.map((player) {
        List<DataCell> cells = [
          DataCell(Text(player.name)),
        ];

        cells.addAll(player.scores.map((score) => DataCell(Text(score.toString()))).toList());

        return DataRow(cells: cells);
      }).toList();
    }
    //  kolorowanie wygranych
    else {
      // Sortowanie graczy według punktów w ostatniej rundzie
      List<Player> sortedPlayers = players;
      sortedPlayers.sort((a, b) => a.scores.last.compareTo(b.scores.last));

      return players.map((player) {
        List<DataCell> cells = [
          DataCell(Text(player.name)),
        ];
        cells.addAll(player.scores.map((score) => DataCell(Text(score.toString()))).toList());

        // Sprawdzenie, czy gracz jest jednym z trzech najlepszych
        Color? rowColor;
        if (sortedPlayers.indexOf(player) == 0) {
          rowColor = Colors.amberAccent.withValues(alpha: 0.9); // Złoty kolor dla najlepszego
        } else if (sortedPlayers.indexOf(player) == 1) {
          rowColor = const Color.fromRGBO(192, 192, 192, 0.9); // Srebrny kolor dla drugiego
        } else if (sortedPlayers.indexOf(player) == 2) {
          rowColor = const Color.fromRGBO(205, 127, 50, 0.9); // Brązowy kolor dla trzeciego
        }

        return DataRow(
          cells: cells,
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return rowColor;
            },
          ),
        );
      }).toList();
    }
  }
}