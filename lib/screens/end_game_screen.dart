import 'package:darttracker/models/match.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/utils/app_bar_util.dart';
import 'package:darttracker/utils/name_game_mode_bar.dart';
import 'package:darttracker/widgets/components/our_wide_button.dart';
import 'package:darttracker/widgets/adapters/score_board.dart';
import 'package:darttracker/widgets/components/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import '../utils/locate_provider.dart';

class EndGameScreen extends StatefulWidget {
  final Match match;
  final bool hideButtons;

  const EndGameScreen(
      {super.key, required this.match, this.hideButtons = false});

  @override
  EndGameScreenState createState() => EndGameScreenState();
}

class EndGameScreenState extends State<EndGameScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarInGameUtil.createAppBarInGame(
          '${widget.match.players[widget.match.playerNumber].name} ${AppLocalizations.of(context)!.end_game_screen_won}!',
          theme,
          context),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Stack(
          children: [
            Column(
              children: [
                nameGameModeBar(false, theme, context, widget.match),
                Expanded(
                  //tabelka wyników
                  child: Center(
                    child: ScoreBoard(match: widget.match, endOfGame: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //przycisk powrotu do HomeScreen
                      if (!widget.hideButtons) ...[
                        const SizedBox(height: 16), // Odstęp między przyciskami
                        //przycisk zapisu gry do pamięci
                        OurWideButton(
                          text:
                              '${AppLocalizations.of(context)!.end_game_screen_saving}...',
                          onPressed: () async {
                            print(
                                'Players: ${widget.match.players}, Player Number: ${widget.match.playerNumber}, Date Time: ${widget.match.dateTime}, Game Mode: ${widget.match.gameMode}, Round Number: ${widget.match.roundNumber}, Game Starting Score: ${widget.match.gameStartingScore}');
                            await Match.saveMatch(widget.match);
                            if (!mounted) return;
                            showSuccessSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                    .end_game_screen_saved);
                          },
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16), // Odstęp między przyciskami

                        //przycisk nowej szybkiej gry
                        OurWideButton(
                          text: AppLocalizations.of(context)!
                              .end_game_screen_quick_start,
                          onPressed: () {
                            final newMatch = widget.match.quickStart();
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
/* niepotrebne już
  void showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
*/
}
