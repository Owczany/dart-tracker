import 'package:darttracker/themes/theme_notifier.dart';
import 'package:darttracker/widgets/dialogs/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarInGameUtil {
  /// Metoda do potwierdzenia wyjścia z meczu
  static void _onBackPressed(BuildContext context, bool endOfGame) {
    bool confirm = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.app_bar_leaving),
          content: Text(
            endOfGame ?
              AppLocalizations.of(context)!.app_bar_leaving_end_game
              : AppLocalizations.of(context)!.app_bar_lost_data
            ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                confirm = false;
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () {
                confirm = true;
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    ).then((_) {
      if (confirm) Navigator.pop(context);
    });
  }

  /// zwraca AppBar z tytułem, przyciskiem zmiany motywu i przyciskiem ustawień; w ustawieniach nie ma możliwości zmiany wyniku gry
  static AppBar createAppBarInGame(
      String title, ThemeData theme, BuildContext context, bool endOfGame) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: theme.appBarTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          //wyświetlanie potwierdzenia wyjścia, gdy jesteśmy w trakcie rozgrywki
          String? currentScreen = ModalRoute.of(context)?.settings.name;
          if (currentScreen == 'GameScreen' ||
              currentScreen == 'EndGameScreen' ||
              currentScreen == 'ScoreBoardScreen') {
            _onBackPressed(context, endOfGame);
          } else {
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            showSettingsDialog(context, isMainMenu: false);
          },
          icon: const Icon(Icons.settings),
        )
      ],
    );
  }
}
