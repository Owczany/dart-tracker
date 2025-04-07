import 'package:darttracker/widgets/dialogs/new_game_players_dialog.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/game_settings_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/our_only_number_text_field.dart';

/// Generuje okno dialogowe do ustawień nowego meczu
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
            //ustawianie trybu gry
            const SizedBox(height: 16),

            Center(
              child: Text(
                '${AppLocalizations.of(context)!.settings_game_mode}:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),

            Consumer<GameSettingsNotifier>(
              builder: (context, gameSettingsNotifier, child) {
                return DropdownButton<int>(
                  value: gameSettingsNotifier.gameMode,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Text(
                        AppLocalizations.of(context)!.settings_easyMode,
                        softWrap: true,
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text(
                        AppLocalizations.of(context)!.settings_proMode,
                        softWrap: true,
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text(
                        AppLocalizations.of(context)!.settings_custom,
                        softWrap: true,
                      ),
                    ),
                  ],
                  onChanged: (int? newValue) {
                    if (newValue == 0) {
                      gameSettingsNotifier.setAllGameMode(gameMode: 0, doubleIn: false, doubleOut: false, lowerThan0: true, removeLastRound: true);
                    } else if (newValue == 1) {
                      gameSettingsNotifier.setAllGameMode(gameMode: 1, doubleIn: true, doubleOut: true, lowerThan0: false, removeLastRound: true);
                    } else {
                      gameSettingsNotifier.setAllGameMode(gameMode: 2, doubleIn: false, doubleOut: false, lowerThan0: true, removeLastRound: true);
                    }
                  },
                );
              },
            ),
            //ustawianie opcji gry custom
            Consumer<GameSettingsNotifier> (
              builder: (context, gameSettingsNotifier, child) {
                if (gameSettingsNotifier.gameMode == 2) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row (
                        children: [
                          Checkbox(
                            value: gameSettingsNotifier.doubleIn,
                            onChanged: (bool? value) {
                              gameSettingsNotifier.toggleDoubleIn();
                            },
                          ),
                          Expanded (
                            child: Text(
                              AppLocalizations.of(context)!.double_in, // (Pierwszy rzut musi trafić w podwójne pole.) (First throw must hit into double field)
                              softWrap: true,
                            ),
                          )
                        ]
                      ),

                      Row (
                        children: [
                          Checkbox(
                            value: gameSettingsNotifier.doubleOut,
                            onChanged: (bool? value) {
                              gameSettingsNotifier.toggleDoubleOut();
                              gameSettingsNotifier.validateSettings();
                            },
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.double_out, // (Ostatni rzut musi trafić w podwójne pole.)  (Last throw must hit into double field)
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Transform.scale (
                            scale: 0.75,
                            child: Switch(
                              value: gameSettingsNotifier.lowerThan0,
                              onChanged: (bool? value) {
                                gameSettingsNotifier.toggleLowerThan0();
                              gameSettingsNotifier.validateSettings();
                              },
                            ),
                          ),
                          
                          if (gameSettingsNotifier.lowerThan0)
                            Expanded (
                              child: Text(
                                AppLocalizations.of(context)!.settings_lower_than_0,
                                softWrap: true,
                              )
                            )
                          else
                            Expanded (
                              child: Text(
                                AppLocalizations.of(context)!.settings_exactly_0,
                                softWrap: true,
                              )
                            )
                        ]
                      ),
                      if (gameSettingsNotifier.doubleOut || !gameSettingsNotifier.lowerThan0)
                        Row(
                          children: [
                            Transform.scale (
                              scale: 0.75,
                              child: Switch(
                                value: gameSettingsNotifier.removeLastRound,
                                onChanged: (bool? value) {
                                  gameSettingsNotifier.toggleRemoveLastRound();
                                },
                              ),
                            ),
                            
                            if (gameSettingsNotifier.removeLastRound)
                              Expanded (
                                child: Text(
                                  AppLocalizations.of(context)!.settings_remove_last_round,
                                  softWrap: true,
                                )
                              )
                            else
                              Expanded (
                                child: Text(
                                  AppLocalizations.of(context)!.settings_remove_incorect_throws,
                                  softWrap: true,
                                )
                              )
                          ]
                        )
                    ],
                  );
                } else if (gameSettingsNotifier.gameMode == 0){
                  return Text (
                      AppLocalizations.of(context)!.settings_easyMode_hint,
                      softWrap: true,
                    );
                } else if (gameSettingsNotifier.gameMode == 1) {
                  return Text (
                      AppLocalizations.of(context)!.settings_proMode_hint,
                      softWrap: true,
                    );
                } else {
                  return const SizedBox.shrink();
                }
              }
            ),
            
            // Ustawianie wyniku gry
            const SizedBox(height: 16),
            Center(
              child: Text (
                '${AppLocalizations.of(context)!.settings_score}:',
                style: const TextStyle (
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 4),

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
                        // Pokaż dialog do wpisania własnego początkowego wyniku gry
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

/// Generuje dialog do wpisania własnego początkowego wyniku gry
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

/// Generuje okno dialogowe do ustawień nowego meczu
void showNewGameSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const NewGameSettingsDialog();
    },
  );
}
