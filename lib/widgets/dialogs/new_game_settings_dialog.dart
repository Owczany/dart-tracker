import 'package:darttracker/widgets/dialogs/new_game_players_dialog.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/game_settings_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/our_only_number_text_field.dart';

class NewGameSettingsDialog extends StatefulWidget {
  const NewGameSettingsDialog({super.key});

  @override
  State<NewGameSettingsDialog> createState() => _NewGameSettingsDialogState();
}

class _NewGameSettingsDialogState extends State<NewGameSettingsDialog> {
  final TextStyle tittleStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.newGameSettings),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 16),
            Consumer<GameSettingsNotifier>(
              builder: (context, gameSettingsNotifier, child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Switch(
                          value: gameSettingsNotifier.easyMode,
                          onChanged: (bool value) {
                            gameSettingsNotifier.toggleEasyMode();
                          },
                        ),
                        Text(
                          gameSettingsNotifier.easyMode
                              ? AppLocalizations.of(context)!.settings_easyMode
                              : AppLocalizations.of(context)!
                                  .settings_normalMode,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        gameSettingsNotifier.easyMode
                            ? AppLocalizations.of(context)!
                                .settings_easyMode_hint
                            : AppLocalizations.of(context)!
                                .settings_normalMode_hint,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<GameSettingsNotifier>(
              builder: (context, gameSettingsNotifier, child) {
                return DropdownButton<int>(
                  value: gameSettingsNotifier.gameStartingScore,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<int>(
                      value: 501,
                      child: Text(
                          "501 (${AppLocalizations.of(context)!.settings_classic})"),
                    ),
                    DropdownMenuItem<int>(
                      value: 301,
                      child: Text(
                          "301 (${AppLocalizations.of(context)!.settings_quick})"),
                    ),
                    DropdownMenuItem<int>(
                      value: -1,
                      child:
                          Text(AppLocalizations.of(context)!.settings_custom),
                    ),
                    if (gameSettingsNotifier.gameStartingScore > 1 &&
                        gameSettingsNotifier.gameStartingScore != 501 &&
                        gameSettingsNotifier.gameStartingScore != 301)
                      DropdownMenuItem<int>(
                        value: gameSettingsNotifier.gameStartingScore,
                        child: Text(
                            "${gameSettingsNotifier.gameStartingScore} (${AppLocalizations.of(context)!.settings_custom})"),
                      ),
                  ],
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      if (newValue == -1) {
                        // Pokaż dialog do wpisania swojego wyniku gry
                        _showCustomScoreDialog(context, gameSettingsNotifier);
                      } else {
                        gameSettingsNotifier.setGameStartingScore(newValue);
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.close)),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              showNewGamePlayersDialog(context);
            },
            child: Text(AppLocalizations.of(context)!.confirm))
      ],
    );
  }
}

void _showCustomScoreDialog(
    BuildContext context, GameSettingsNotifier gameSettingsNotifier) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController controller1 = TextEditingController();
      String? errorMessage;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogSetState) {
          return AlertDialog(
            title: Text(
                "${AppLocalizations.of(context)!.settings_entering_score} (${AppLocalizations.of(context)!.settings_entering_hint} 1)"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OurOnlyNumberTextField(
                  controller: controller1,
                  text: '${AppLocalizations.of(context)!.settings_fe}: 420',
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.close),
              ),
              TextButton(
                onPressed: () {
                  int? typedValue = int.tryParse(controller1.text);
                  if (typedValue != null && typedValue > 1) {
                    gameSettingsNotifier.setGameStartingScore(typedValue);
                    errorMessage = null;

                    Navigator.of(context).pop();

                    dialogSetState(() {});
                  } else {
                    dialogSetState(() {
                      errorMessage =
                          "${AppLocalizations.of(context)!.settings_entering_error} 1.";
                    });
                  }
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        },
      );
    },
  );
}

void showNewGameSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const NewGameSettingsDialog();
    },
  );
}
