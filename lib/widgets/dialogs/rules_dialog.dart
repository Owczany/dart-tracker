import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Generuje okno dialogowe z informacją o zasadach gdy i opisem ustawień meczu
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
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            _onlyWrapText(
              '1. ${AppLocalizations.of(context)!.rules_game_goal}\n'
            ),
            _onlyWrapText(
              '2. ${AppLocalizations.of(context)!.rules_dartboard_description}\n'
            ),
            _boldBigText(
              '${AppLocalizations.of(context)!.rules_game_modes}:\n'
            ),
            _boldText(
              AppLocalizations.of(context)!.settings_easyMode
            ),
            _onlyWrapText(
              '${AppLocalizations.of(context)!.rules_easyMode_description}\n'
            ),
            _boldText(
              AppLocalizations.of(context)!.settings_proMode
            ),
            _onlyWrapText(
              '${AppLocalizations.of(context)!.rules_proMode_description}\n'
            ),
            _boldText(
              AppLocalizations.of(context)!.settings_custom
            ),
            _onlyWrapText(
              '${AppLocalizations.of(context)!.rules_customMode_description}\n'
            ),
            _boldBigText(
              '${AppLocalizations.of(context)!.rules_available_game_rules}:\n'
            ),
            _boldText(
              AppLocalizations.of(context)!.double_in
            ),
            _onlyWrapText(
              '${AppLocalizations.of(context)!.rules_doubleIn_description}\n'
            ),
            _boldText(
              AppLocalizations.of(context)!.double_out
            ),
            _onlyWrapText(
              '${AppLocalizations.of(context)!.rules_doubleOut_description}\n'
            ),
            _boldText(
              '0?'
            ),
            _onlyWrapText(
              '${AppLocalizations.of(context)!.rules_lowerThan0_description}\n'
            ),
            _boldText(
              AppLocalizations.of(context)!.rules_penalty
            ),
            _onlyWrapText(
              '${AppLocalizations.of(context)!.rules_penalty_description}\n'
            ),

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
  
  Text _onlyWrapText(String text) {
    return Text(
      text,
      softWrap: true,
    );
  }
  Text _boldText(String text) {
    return Text(
      text,
      softWrap: true,
      style: const TextStyle (
        fontWeight: FontWeight.bold
      ),
    );
  }
  Text _boldBigText(String text) {
    return Text(
      text,
      softWrap: true,
      style: const TextStyle (
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
    );
  }
}

/// Generuje okno dialogowe z informacją o zasadach gry i opisem ustawień meczu
void showRulesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const RulesDialog();
    },
  );
}