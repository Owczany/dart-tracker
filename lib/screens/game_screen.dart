import 'package:darttracker/models/game_settings_notifier.dart';
import 'package:darttracker/models/match.dart';
import 'package:darttracker/models/pair.dart';
import 'package:darttracker/utils/app_bar_util.dart';
import 'package:darttracker/utils/name_game_mode_bar.dart';
import 'package:darttracker/widgets/adapters/dartboard.dart';
import 'package:darttracker/widgets/adapters/touch_points_painter.dart';
import 'package:darttracker/widgets/components/our_wide_button.dart';
import 'package:darttracker/screens/end_game_screen.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/widgets/components/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:darttracker/models/dartboard_notifier.dart';

/// Ekran gry do zaznaczania rzutów na tarczy
class GameScreen extends StatefulWidget {
  final Match match;

  const GameScreen({super.key, required this.match});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late Match match;
  final List<Offset> throws = []; // Przechowuje współrzędne zaznaczonych rzutów
  List<int> typedThrows = [
    0,
    0,
    0
  ]; // Przechowuje wartości rzutów wybrane z list rozwijalnych
  List<int> typedMults = [
    1,
    1,
    1
  ]; // Przechowuje mnożniki rzutów wybranych z list rozwijalnych
  final GlobalKey dartboardKey = GlobalKey();

  // Kontroler do utrzymywania powiększenia przy zaznaczeniu rzutu
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    match = widget.match;
  }

  /// Metoda do wyliczania punktów na podstawie współrzędnych rzutu
  Pair<int, int> calculateThrow(Offset throw_, BuildContext context) {
    final RenderBox box =
        dartboardKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = box.size;
    
    //sprawdzanie warunku doubleIn
    return match.calculateThrow(throw_, size);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dartboardNotifier = context.watch<DartboardNotifier>();
    final gameSettingsNotifier = context.watch<GameSettingsNotifier>();

    return Scaffold(
        appBar: AppBarInGameUtil.createAppBarInGame(
            title: '${AppLocalizations.of(context)!.round} ${match.roundNumber}',
            theme: theme, 
            context: context,
            endOfGame: false),
            
        body: Container(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              // Pasek z nazwą gracza i trybem gry
              nameGameModeBar(true, theme, context, match),

              // Dodanie list rozwijalnych
              if (!dartboardNotifier.boardVersion)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buildDropdowns(
                        context, setState, typedThrows, typedMults),
                  ),
                ),

              Expanded(
                child: InteractiveViewer(
                    // Powiększanie tarczy
                    transformationController: _transformController,
                    boundaryMargin:
                        const EdgeInsets.all(20),
                    minScale: 1,
                    maxScale: 3.0,
                    child: Stack(children: [
                      // Rysowanie tarczy
                      Dartboard(key: dartboardKey),

                      // Reagowanie na kliknięcia przy tarczy dotykowej
                      if (dartboardNotifier.boardVersion)
                        GestureDetector(
                          onTapDown: (details) {

                            // Ograniczenie na max 3 rzuty
                            if (throws.length == 3) {
                              showErrorSnackbar(
                                  context,
                                  AppLocalizations.of(context)!
                                      .game_screen_only_3_darts);
                            } else {
                              // Przekształcenie globalnych współrzędnych na lokalne
                              setState(() {
                                throws.add((details.localPosition));
                              });
                            }
                          },
                          child: CustomPaint(
                            painter: TouchPointsPainter(touchPositions: throws),
                            child:
                                Container(), // Potrzebny, żeby był znany rozmiar obszaru dotykowego
                          ),
                        ),
                    ])),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: dartboardNotifier.boardVersion
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.center,
                  children: [
                    // Przycisk usunięcia ostatniego rzutu
                    if (dartboardNotifier.boardVersion)
                      OurWideButton(
                        text: AppLocalizations.of(context)!.cancel,
                        onPressed: () {
                          setState(() {
                            if (throws.isNotEmpty) {
                              throws.removeLast();
                            }
                          });
                        },
                        color: theme.colorScheme.error,
                        textColor: theme.colorScheme.onError,
                        minimumSize: const Size(150, 70),
                      ),

                    // Nawigacja do tabeli wyników
                    OurWideButton(
                      text: AppLocalizations.of(context)!.confirm,
                      onPressed: () {
                        List<Pair<int,int>> points = [];

                        if (dartboardNotifier.boardVersion) {
                          if (throws.length != 3) {
                            showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                    .game_screen_mark_3_throws);
                          } else {
                            for (Offset throw_ in throws) {
                              // Sprawdzanie warunku doubleIn
                              if (gameSettingsNotifier.doubleIn &&
                                  !match.players[match.playerNumber].getsIn)
                              {
                                  points.add(calculateThrow(throw_, context));
                              } else {
                                match.players[match.playerNumber].getsIn = true;
                                points.add(calculateThrow(throw_, context));
                              }

                            }
                          }
                        } else {
                          bool isGoodtyped = true;
                          for (int i = 0; i < 3; i++) {
                            if (typedThrows[i] == 25 &&
                                typedMults[i] == 3) {
                              showErrorSnackbar(
                                  context,
                                  AppLocalizations.of(context)!
                                      .game_screen_incorect_mult);
                              isGoodtyped = false;
                              break;
                            }
                          }
                          if (isGoodtyped) {
                            for (int i = 0; i < 3; i++) {
                                points.add(Pair(typedThrows[i], typedMults[i]));
                            }
                          }
                        }

                        // Sprawdzenie, czy ilość rzutów się zgadza
                        if (points.length == 3) {
                          
                          // Komunikaty, gdy rzut nie został zaliczony
                          RoundResult message = match.processThrows(points);
                          switch (message) {
                            case RoundResult.allThrowsAccepted:
                            break;
                            case RoundResult.roundInvalidLowerThan0: // 0 przekroczone, usunięta cała runda
                              showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                  .game_screen_lowerThan0_error2,
                              );
                            break;
                            case RoundResult.roundInvalidDoubleOut: // doubleOut, usunięta cała runda
                              showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                  .game_screen_doubleOut_error2,
                              );
                            break;
                            case RoundResult.someThrowsInvalidLowerThan0: // 0 przekroczone, usunięte tylko niepoprawne rzuty
                              showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                  .game_screen_lowerThan0_error,
                              );
                            break;
                            case RoundResult.someThrowsInvalidDoubleIn: // doubleIn, usunięte tylko niepoprawne rzuty
                              showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                  .game_screen_doubleIn_error,
                              );
                            break;
                            case RoundResult.lastThrowInvalidDoubleOut: // doubleOut, usunięty tylko ostatni rzut
                              showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                  .game_screen_doubleOut_error,
                              );
                            break;
                            case RoundResult.someThrowsInvalidLowerThan0AndDoubleOut: // 0 przekroczone i doubleOut, usunięte tylko niepoprawne rzuty
                              showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                  .game_screen_lowerThan0_doubleOut_error,
                              );
                            break;
                          }
                          if (match.isGameOver()) {
                            // Odpowiednie przekierowanie jeśli już ktoś wygrał
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EndGameScreen(
                                  match: match,
                                ),
                                settings:
                                    const RouteSettings(name: 'EndGameScreen'),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScoreBoardScreen(
                                  match: match,
                                ),
                                settings: const RouteSettings(
                                    name: 'ScoreBoardScreen'),
                              ),
                            );
                          }
                        }
                      },
                      color: theme.colorScheme.secondary,
                      textColor: theme.colorScheme.onSecondary,
                      minimumSize: const Size(150, 70),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

/// Zwraca listę rozwijalną możliwych wartości rzutu
List<DropdownMenuItem<int>> _getDropdownItems(BuildContext context) {
  List<int> values = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    25
  ];
  List<DropdownMenuItem<int>> items = [];
  for (int i = 0; i < values.length; i++) {
    items.add(DropdownMenuItem<int>(
        value: values[i],
        child: values[i] == 0
            ? Text(AppLocalizations.of(context)!.game_screen_miss)
            : Text(values[i].toString())));
  }
  return items;
}

/// Zwraca listę rozwijalną możliwych mnożników
List<DropdownMenuItem<int>> _getDropDownMults() {
  List<int> values = [1, 2, 3];
  List<DropdownMenuItem<int>> items = [];
  for (int i = 0; i < values.length; i++) {
    items.add(
        DropdownMenuItem<int>(value: values[i], child: Text('x${values[i]}')));
  }
  return items;
}

/// Tworzy listę widgetów z list rozwijalnych
List<Widget> _buildDropdowns(BuildContext context, StateSetter setState,
    List<int> typedThrows, List<int> typedMults) {
  List<Widget> widgets = [];
  for (int i = 0; i < 3; i++) {
    widgets.add(Expanded(
        child: Column(children: [
      DropdownButtonFormField<int>(
        value: typedThrows[i],
        items: _getDropdownItems(context),
        onChanged: (newValue) {
          setState(() {
            typedThrows[i] = newValue!;
            //_controller1.text = newValue.toString();
          });
        },
        decoration: InputDecoration(
          labelText:
              '${AppLocalizations.of(context)!.game_screen_throw} ${i + 1}',
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 10),
      DropdownButtonFormField(
        value: typedMults[i],
        items: _getDropDownMults(),
        onChanged: (newValue) {
          setState(() {
            typedMults[i] = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText:
              '${AppLocalizations.of(context)!.game_screen_multiplicator} ${i + 1}',
          border: const OutlineInputBorder(),
        ),
      )
    ])));
    if (i != 2) {
      widgets.add(const SizedBox(width: 10));
    }
  }
  return widgets;
}
