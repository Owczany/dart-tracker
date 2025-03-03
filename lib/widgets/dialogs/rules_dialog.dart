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
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              '1. ${AppLocalizations.of(context)!.rules_game_goal}\n',
              softWrap: true,
            ),
            Text(
              '2. ${AppLocalizations.of(context)!.rules_dartboard_description}\n',
              softWrap: true,
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_game_modes}:\n',
              softWrap: true,
              style: const TextStyle (
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              AppLocalizations.of(context)!.settings_easyMode,
              softWrap: true,
              style: const TextStyle (
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_easyMode_description}\n',
              softWrap: true,
            ),
            Text(
              AppLocalizations.of(context)!.settings_proMode,
              softWrap: true,
              style: TextStyle (
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_proMode_description}\n',
              softWrap: true,
            ),
            Text(
              AppLocalizations.of(context)!.settings_custom,
              softWrap: true,
              style: TextStyle (
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_customMode_description}\n',
              softWrap: true,
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_available_game_rules}:\n',
              softWrap: true,
              style: const TextStyle (
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              AppLocalizations.of(context)!.double_in,
              softWrap: true,
              style: TextStyle (
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_doubleIn_description}\n',
              softWrap: true,
            ),
            Text(
              AppLocalizations.of(context)!.double_out,
              softWrap: true,
              style: const TextStyle (
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_doubleOut_description}\n',
              softWrap: true,
            ),
            const Text(
              '0?',
              softWrap: true,
              style: TextStyle (
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_lowerThan0_description}\n',
              softWrap: true,
            ),
            Text(
              AppLocalizations.of(context)!.rules_penalty,
              softWrap: true,
              style: const TextStyle (
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.rules_penalty_description}\n',
              softWrap: true,
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
}

void showRulesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const RulesDialog();
    },
  );
}