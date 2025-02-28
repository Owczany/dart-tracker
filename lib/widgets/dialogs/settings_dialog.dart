import 'package:darttracker/utils/locate_provider.dart';
import 'package:darttracker/widgets/components/our_only_number_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:darttracker/models/dartboard_notifier.dart';
import 'package:darttracker/models/game_settings_notifier.dart';

class SettingsDialog extends StatefulWidget {
  final bool isMainMenu;
  const SettingsDialog({super.key, required this.isMainMenu});

  @override
  SettingsDialogState createState() => SettingsDialogState();
}

class SettingsDialogState extends State<SettingsDialog> {
  late bool isMainMenu;
  final TextStyle tittleStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    isMainMenu = widget.isMainMenu;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.settings),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ustawianie języka
            Text(AppLocalizations.of(context)!.settings_choose_language,
                style: tittleStyle),
            const SizedBox(height: 8),
            Consumer<LocaleProvider>(builder: (context, localeProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Switch(
                    value: localeProvider.locale.languageCode == 'en',
                    onChanged: (bool value) {
                      localeProvider.setLocale(Locale(value ? 'en' : 'pl'));
                    },
                  ),
                  Text(
                    localeProvider.locale.languageCode == 'en'
                        ? 'English'
                        : 'Polski',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),

            // ustawianie tarczy
            Text(AppLocalizations.of(context)!.settings_board_version,
                style: tittleStyle),
            const SizedBox(height: 8),
            Consumer<DartboardNotifier>(
              builder: (context, dartboardNotifier, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Switch(
                      value: dartboardNotifier.boardVersion,
                      onChanged: (bool value) {
                        dartboardNotifier.toggleBoardVersion();
                      },
                    ),
                    Text(
                      dartboardNotifier.boardVersion
                          ? AppLocalizations.of(context)!.settings_touch
                          : AppLocalizations.of(context)!.settings_type,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // wyświetlanie numerów na tarczy
            Text(AppLocalizations.of(context)!.settings_show_numbers,
                style: tittleStyle),
            const SizedBox(height: 8),
            Consumer<DartboardNotifier>(
              builder: (context, dartboardNotifier, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Switch(
                      value: dartboardNotifier.showNumbers,
                      onChanged: (bool value) {
                        dartboardNotifier.toggleShowNumbers();
                      },
                    ),
                    Text(
                      dartboardNotifier.showNumbers
                          ? AppLocalizations.of(context)!.on
                          : AppLocalizations.of(context)!.off,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            //ustawianie trybu gry (easyMode, normalMode):
            if (isMainMenu)
              Text(AppLocalizations.of(context)!.settings_game_mode,
                  style: tittleStyle),
            if (isMainMenu) const SizedBox(height: 8),
            if (isMainMenu)
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
                                ? AppLocalizations.of(context)!
                                    .settings_easyMode
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
            if (isMainMenu) const SizedBox(height: 16),

            // ustawianie wyniku gry
            if (isMainMenu)
              Text(AppLocalizations.of(context)!.settings_points_to_win,
                  style: tittleStyle),
            if (isMainMenu) const SizedBox(height: 8),
            if (isMainMenu)
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
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }
}

/// Funkcja wyświetlająca dialog do wpisania customowego wyniku gry
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
                  int? typedValue = int.tryParse(controller1.text);
                  if (typedValue != null && typedValue > 1) {
                    gameSettingsNotifier.setGameStartingScore(typedValue);
                    errorMessage = null;

                    Navigator.of(context).pop();
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

/// Funkcja wyświetlająca dialog ustawień (zmiana wyniku gry jest ukryta, jeżeli changableScore = false)
void showSettingsDialog(BuildContext context, {bool isMainMenu = true}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SettingsDialog(isMainMenu: isMainMenu);
    },
  );
}
