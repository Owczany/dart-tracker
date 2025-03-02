import 'package:darttracker/models/game_settings_notifier.dart';
import 'package:darttracker/models/match.dart';
import 'package:darttracker/utils/app_bar_util.dart';
import 'package:darttracker/widgets/components/our_wide_button.dart';
import 'package:darttracker/screens/end_game_screen.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:darttracker/widgets/components/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/adapters/touch_points_painter.dart';
import '../widgets/adapters/dartboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:darttracker/models/dartboard_notifier.dart';

/// To jest ekran gry, gdzie gracz wklepuje swoje rzuty
class GameScreen extends StatefulWidget {
  final Match match;

  const GameScreen({super.key, required this.match});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late Match match;
  final List<Offset> throws = []; // Przechowuje współrzędne wyklikanych rzutów
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

  //Kontroler do utrzymywania powiększenia przy klikniękciu rzutu
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    match = widget.match;
  }

  /// metoda do wyliczania punktów na podstawie współrzędnych rzutu
  int calculateThrow(Offset throw_, BuildContext context, bool needsDoubleIn) {
    final RenderBox box =
        dartboardKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = box.size;
    
    //sprawdzanie warunku doubleIn
    int answer = match.calculateThrow(throw_, size, needsDoubleIn);
    if (needsDoubleIn &&
        answer != 0) {
            match.players[match.playerNumber].getsIn = true;
        }
    return answer;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dartboardNotifier = context.watch<DartboardNotifier>();
    final gameSettingsNotifier = context.watch<GameSettingsNotifier>();

    return Scaffold(
        appBar: AppBarInGameUtil.createAppBarInGame(
            '${AppLocalizations.of(context)!.round} ${match.roundNumber}',
            theme,
            context),
        body: Container(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              // Nazwa gracza
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 0),
                child: Text(
                  match.players[match.playerNumber].name,
                ),
              ),

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
                    //powiększanie tarczy
                    transformationController: _transformController,
                    boundaryMargin:
                        const EdgeInsets.all(20), // Margines do przewijania
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Stack(children: [
                      //rysowanie tarczy
                      Dartboard(key: dartboardKey),

                      // reagowanie na kliknięcia przy tarczy dotykowej
                      if (dartboardNotifier.boardVersion)
                        GestureDetector(
                          onTapDown: (details) {

                            //ograniczenie na max 3 rzuty
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
                                Container(), //potrzebny, żeby był znany rozmiar obszaru do klikania
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
                    //przycisk usunięcia ostatniego rzutu
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

                    // nawigacja do tabelki wyników
                    OurWideButton(
                      text: AppLocalizations.of(context)!.confirm,
                      onPressed: () {
                        List<int> points = [];

                        if (dartboardNotifier.boardVersion) {
                          if (throws.length != 3) {
                            showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                    .game_screen_mark_3_throws);
                          } else {
                            for (Offset throw_ in throws) {
                              //sprawdzanie warunku doubleIn
                              if (gameSettingsNotifier.doubleIn &&
                                  !match.players[match.playerNumber].getsIn) 
                              {
                                  points.add(calculateThrow(throw_, context, true));
                              } else {
                                match.players[match.playerNumber].getsIn = true;
                                points.add(calculateThrow(throw_, context, false));

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
                              //sprawdzanie warunku doubleIn
                              if (gameSettingsNotifier.doubleIn &&
                                  !match.players[match.playerNumber].getsIn &&
                                  typedMults[i] != 2)
                                {
                                  points.add(0);
                                } else {
                                  match.players[match.playerNumber].getsIn = true;
                                  points.add(typedThrows[i] * typedMults[i]);

                                }
                            }
                          }
                        }

                        //sprawdzenie, czy ilość rzutów się zgadza
                        if (points.length == 3) {
                          //ustalanie punktacji obecnego gracza
                          int howMuch = match.processThrows(points);
                          if (howMuch == 0) {
                            showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                    .game_screen_too_many_points);
                          } else if (howMuch == 1) {
                            showErrorSnackbar(
                                context,
                                AppLocalizations.of(context)!
                                    .game_screen_one_point);
                          }
                          if (match.isGameOver()) {
                            //odpowiednie przekierowanie jeśli już ktoś wygrał (wtedy jego wynik w ostatniej rundzie to 0)
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
