import 'package:darttracker/models/match.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/utils/app_bar_util.dart';
import 'package:darttracker/widgets/components/our_wide_button.dart';
import 'package:darttracker/widgets/adapters/score_board.dart';
import 'package:darttracker/widgets/components/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Ekran końca gry
class EndGameScreen extends StatefulWidget {
  final Match match;
  final bool hideButtons;

  const EndGameScreen(
      {super.key, required this.match, this.hideButtons = false});

  @override
  EndGameScreenState createState() => EndGameScreenState();
}

class EndGameScreenState extends State<EndGameScreen> {
  late Match match;
  late bool hideButtons;

  @override
  void initState() {
    super.initState();
    match = widget.match;
    hideButtons = widget.hideButtons;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarInGameUtil.createAppBarInGame(
          title: '${match.players[match.playerNumber].name} ${AppLocalizations.of(context)!.end_game_screen_won}!',
          theme: theme,
          context: context,
          endOfGame: true),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  // Tabela wyników
                  child: Center(
                    child: ScoreBoard(match: match, endOfGame: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!hideButtons) ...[
                        const SizedBox(height: 16),
                        // Przycisk zapisu gry do pamięci
                        OurWideButton(
                          text:
                              '${AppLocalizations.of(context)!.end_game_screen_saving}...',
                          onPressed: () async {
                            /*
                            print(
                                'Players: ${match.players}, Player Number: ${match.playerNumber}, Date Time: ${match.dateTime}, Game mode: ${match.gameMode}, Round Number: ${match.roundNumber}, Game Starting Score: ${match.gameStartingScore}');
                            */
                            bool success = await Match.saveMatch(match);
                            if (!mounted) return;
                            if (success) {
                              showSuccessSnackbar(
                                  context,
                                  AppLocalizations.of(context)!
                                      .end_game_screen_saved);
                            } else {
                              showErrorSnackbar(
                                  context,
                                  AppLocalizations.of(context)!
                                      .end_game_screen_already_saved);
                            }
                          },
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16),

                        // Przycisk nowej szybkiej gry
                        OurWideButton(
                          text: AppLocalizations.of(context)!
                              .end_game_screen_quick_start,
                          onPressed: () {
                            final newMatch = match.quickStart();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScoreBoardScreen(match: newMatch),
                                settings: const RouteSettings(
                                    name: 'ScoreBoardScreen'),
                              ),
                            );
                          },
                          color: theme.colorScheme.secondary,
                          textColor: theme.colorScheme.onSecondary,
                        ),
                      ],
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
