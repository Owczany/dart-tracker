import 'package:flutter/material.dart';

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
      title: const Text('Game Rules'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('1. Zasada 1: Opis zasady 1.'),
            Text('2. Zasada 2: Opis zasady 2.'),
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
          child: const Text('Close')
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