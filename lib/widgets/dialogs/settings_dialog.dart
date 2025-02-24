import 'package:darttracker/widgets/components/our_only_number_text_field.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/match.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsDialog extends StatefulWidget {
  final bool changableScore;
  const SettingsDialog({super.key, required this.changableScore});

  @override
  SettingsDialogState createState() => SettingsDialogState();
}

class SettingsDialogState extends State<SettingsDialog> {
  late bool changableScore;
  //late Match match;

  @override
  void initState() {
    super.initState();
    changableScore = widget.changableScore;
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

            // ustawianie tarczy
            Text(AppLocalizations.of(context)!.settings_board_version),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Switch(
                      value: Match.boardVersion,
                      onChanged: (bool value) {
                        setState(() {
                          Match.boardVersion = value;
                          Match.boardversionNotifier.value = value;
                        });
                      },
                    ),
                    Text(
                      Match.boardVersion 
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
            Text(AppLocalizations.of(context)!.settings_show_numbers),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Switch(
                      value: Match.showNumbers,
                      onChanged: (bool value) {
                        setState(() {
                          Match.showNumbers = value;
                          Match.showNumbersNotifier.value = value;
                        });
                      },
                    ),
                    Text(
                      Match.showNumbers
                          ? AppLocalizations.of(context)!.on
                          : AppLocalizations.of(context)!.off,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // ustawianie wyniku gry
            if (changableScore)
              Text(AppLocalizations.of(context)!.settings_points_to_win),
            if (changableScore)
              const SizedBox(height: 8),
            if (changableScore)
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButton<int>(
                    value: Match.gameScore,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<int>(
                        value: 501,
                        child: Text("501 (${AppLocalizations.of(context)!.settings_classic})"),
                      ),
                      DropdownMenuItem<int>(
                        value: 301,
                        child: Text("301 (${AppLocalizations.of(context)!.settings_quick})"),
                      ),
                      DropdownMenuItem<int>(
                        value: -1,
                        child: Text(AppLocalizations.of(context)!.settings_custom),
                      ),
                      if (Match.gameScore > 1 && Match.gameScore != 501 && Match.gameScore != 301)
                        DropdownMenuItem<int>(
                          value: Match.gameScore,
                          child: Text("${Match.gameScore} (${AppLocalizations.of(context)!.settings_custom})"),
                        ),
                    ],
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          if (newValue == -1) {
                            // Pokaż dialog do wpisania swojego wyniku gry
                            _showCustomScoreDialog(context, setState);
                          } else {
                            Match.gameScore = newValue;
                          }
                        });
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
void _showCustomScoreDialog(BuildContext context, StateSetter setState) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController controller1 = TextEditingController();
      String? errorMessage;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogSetState) {
          return AlertDialog(
            title: Text("${AppLocalizations.of(context)!.settings_entering_score} (${AppLocalizations.of(context)!.settings_entering_hint} 1)"),
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
                    Match.gameScore = typedValue;
                    errorMessage = null;

                    Navigator.of(context).pop();

                    setState(() {});
                  } else {
                    dialogSetState(() {
                      errorMessage = "${AppLocalizations.of(context)!.settings_entering_error} 1.";
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
void showSettingsDialog(BuildContext context, {bool changableScore = true}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SettingsDialog(changableScore: changableScore);
    },
  );
}