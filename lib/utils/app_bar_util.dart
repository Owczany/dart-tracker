import 'package:darttracker/themes/theme_notifier.dart';
import 'package:darttracker/widgets/dialogs/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarInGameUtil {
  /// zwraca AppBar z tytułem, przyciskiem zmiany motywu i przyciskiem ustawień; w ustawieniach nie ma możliwości zmiany wyniku gry
  static createAppBarInGame (String title, ThemeData theme, BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: theme.appBarTheme.backgroundColor,
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