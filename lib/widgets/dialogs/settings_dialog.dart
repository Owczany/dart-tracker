import 'package:darttracker/widgets/components/our_only_number_text_field.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/match.dart';

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
      title: const Text("Settings"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            // ustawianie tarczy
            const Text("Board Version:"),
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
                      Match.boardVersion ? "Touch" : "Type",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // wyświetlanie numerów na tarczy
            const Text("Show numbers on the board:"),
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
                      Match.showNumbers ? "On" : "Off",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // ustawianie wyniku gry
            if (changableScore)
              const Text("Points to win:"),
            if (changableScore)
              const SizedBox(height: 8),
            if (changableScore)
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButton<int>(
                    value: Match.gameScore,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<int>(
                        value: 501,
                        child: Text("501 (Classic)"),
                      ),
                      const DropdownMenuItem<int>(
                        value: 301,
                        child: Text("301 (Quick)"),
                      ),
                      const DropdownMenuItem<int>(
                        value: -1,
                        child: Text("Custom"),
                      ),
                      if (Match.gameScore > 1 && Match.gameScore != 501 && Match.gameScore != 301)
                        DropdownMenuItem<int>(
                          value: Match.gameScore,
                          child: Text("${Match.gameScore} (custom)"),
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
          child: const Text('Close'),
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
            title: const Text("Enter Custom Score (bigger than 1)"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OurOnlyNumberTextField(
                  controller: controller1,
                  text: 'For example: 420',
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
                      errorMessage = "Invalid value! Enter a number greater than 1.";
                    });
                  }
                },
                child: const Text('Ok'),
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