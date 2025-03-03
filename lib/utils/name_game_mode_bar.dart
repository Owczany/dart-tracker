import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/match.dart';

Widget nameGameModeBar(bool name, ThemeData theme, BuildContext context, Match match) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 16, left: 16, right: 16, bottom: 0,
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(30), // Owalne rogi
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (name)
            Expanded(
              child: Text(
                '${AppLocalizations.of(context)!.player}: ${match.players[match.playerNumber].name}',
                overflow: TextOverflow.ellipsis, // obcinanie za długich nazw użytkowników
                style: const TextStyle (fontSize: 16)
              ),
            ),
          Text(
            '${AppLocalizations.of(context)!.settings_mode}: ${
              match.gameMode == 0 
                  ? AppLocalizations.of(context)!.settings_easyMode 
                  : match.gameMode == 1 
                      ? AppLocalizations.of(context)!.settings_proMode
                      : AppLocalizations.of(context)!.settings_custom}',
            style: const TextStyle (fontSize: 16),
          ),
        ],
      ),
    ),
  );
}