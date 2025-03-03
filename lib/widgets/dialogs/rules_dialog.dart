import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RulesDialog extends StatefulWidget {
  const RulesDialog({super.key});

  @override
  RulesDialogState createState() => RulesDialogState();
}

class RulesDialogState extends State<RulesDialog> {

  void initstate() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.game_rules),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              '1. Celem gry jest zredukowanie początkowej liczby punktów (501, 301 lub niestandardowej) do zera. Rzucając w tarczę, trafiona wartość jest odejmowana od początkowego wyniku. Możesz wybrać, czy gra ma się zakończyć, gdy osiągniesz dokładnie 0, czy wystarczy że je przekroczysz (zdobywając np. -5 punktów)',
              softWrap: true,
            ),
            Text('2. Tarcza ma 20 sekcji, z numerami od 1 do 20. Oprócz tego są też obszary podwójne (x2) oraz potrójne (x3). Trafienie takiego obszaru mnoży wartość danej sekcji przez trafiony mnożnik. Sam środek tarczy nazywa się Bulleye i jest warty 25x2 punktów.'),
            Text('3. Zasada 3: Opis zasady 3.'),

            // Dodaj więcej zasad według potrzeby
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.close)
        ),
      ],
    );
  }
}

void showRulesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const RulesDialog();
    },
  );
}