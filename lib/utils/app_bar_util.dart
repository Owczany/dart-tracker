import 'package:darttracker/themes/theme_notifier.dart';
import 'package:darttracker/widgets/dialogs/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarInGameUtil {
  
  /// Metoda do potwierdzenia wyjścia z meczu
  static void _onBackPressed(BuildContext context) {
    bool confirm = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to leave this match?'),
          content: const Text('All data will be lost.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                confirm = false;
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                confirm = true;
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((_) {
      if (confirm) Navigator.pop(context);
    });
  }
  /// zwraca AppBar z tytułem, przyciskiem zmiany motywu i przyciskiem ustawień; w ustawieniach nie ma możliwości zmiany wyniku gry
  static AppBar createAppBarInGame (String title, ThemeData theme, BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: theme.appBarTheme.backgroundColor,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Tu można dodać dowolną akcję przed powrotem
          _onBackPressed(context);
        },
      ),
      actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
            icon: const Icon(Icons.brightness_6),
          ),
          IconButton(
            onPressed: () {
              showSettingsDialog(context, changableScore: false);
            },
            icon: const Icon(Icons.settings),
          )
        ],
    );
  }
}