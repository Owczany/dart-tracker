import 'package:darttracker/widgets/components/our_only_number_text_field.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/match.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  SettingsDialogState createState() => SettingsDialogState();
}

class SettingsDialogState extends State<SettingsDialog> {
  late Match match;

  void initstate() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Settings"),
      content: Column (
        children: <Widget>[
          //ustawianie tarczy
          const Text("Board Version:"),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Row(
                children: [
                  Switch(
                    value: Match.boardVersion,
                    onChanged: (bool value) {
                      setState(() {
                        Match.boardVersion = value;
                      });
                    },
                  ),
                  Text(
                    Match.boardVersion ? "Touch" : "Manual",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            },
          ),

          //ustawianie wyniku gry
          const Text("Points to get:"),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<int>(
                value: Match.gameScore,
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
                        final TextEditingController controller1 = TextEditingController();
                        // Pokaż dialog do wpisania swojego wyniku gry
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            int customValue = Match.gameScore > 1 ? Match.gameScore : 501;
                            return AlertDialog(
                              title: const Text("Enter Custom Score (bigger than 1)"),
                              content: OurOnlyNumberTextField(
                                controller: controller1, 
                                text: 'for example: 420', 
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    int? typedValue = int.tryParse(controller1.text);
                                    if (typedValue != null) {
                                      customValue = typedValue;
                                    }

                                    if (customValue > 1) {
                                      setState(() {
                                        Match.gameScore = customValue;
                                      });
                                      Navigator.of(context).pop();
                                    }
                                    else {
                                      //TODO: takiego wyniku nie można osiągnąć
                                    }
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
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
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close')
        ),
      ],
    );
  }
}


void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SettingsDialog();
    },
  );
}