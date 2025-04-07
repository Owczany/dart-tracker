import 'package:darttracker/utils/app_bar_util.dart';
import 'package:darttracker/utils/name_game_mode_bar.dart';
import 'package:darttracker/widgets/components/our_wide_button.dart';
import 'package:darttracker/screens/game_screen.dart';
import 'package:darttracker/widgets/adapters/score_board.dart';
import 'package:flutter/material.dart';
import 'package:darttracker/models/match.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Ekran punktacji wyświetlany pomięrzy turami
class ScoreBoardScreen extends StatelessWidget {
  final Match match;

  const ScoreBoardScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarInGameUtil.createAppBarInGame(
        title: AppLocalizations.of(context)!.score_board_screen_scores_after_each_round, 
        theme: theme,
        context: context, 
        endOfGame: false),
      
      body: Container (
        color: theme.scaffoldBackgroundColor,
        child: Stack(
          children: [
            Column(
              children: [
                nameGameModeBar(false, theme, context, match),
                Expanded(
                  //tabelka wyników
                  child: Center(
                    child: ScoreBoard(match: match),
                  ),
                ),

                // Przycisk przejścia do następnej tury
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OurWideButton(
                    text: '${AppLocalizations.of(context)!.score_board_screen_next_player}: ${match.players[match.playerNumber].name}',
                    onPressed: () {
                      // Przekierowanie z powrotem do game_screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(match: match),
                          settings: const RouteSettings(name: 'GameScreen')
                        ),
                      );
                    },
                    color: theme.colorScheme.primary,
                    textColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ]
        )
      )
    );
  }
}
