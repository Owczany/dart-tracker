import 'package:darttracker/widgets/dialogs/history_dialog.dart';
import 'package:darttracker/widgets/dialogs/new_game_players_dialog.dart';
import 'package:darttracker/widgets/adapters/dartboard.dart';
import 'package:darttracker/widgets/dialogs/new_game_settings_dialog.dart';
import 'package:darttracker/widgets/dialogs/rules_dialog.dart';
import 'package:darttracker/widgets/dialogs/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_notifier.dart';
import '../widgets/components/our_thin_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/dartboard_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Darts Tracker'),
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
              showSettingsDialog(context);
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Consumer<DartboardNotifier>(
              builder: (context, dartboardNotifier, child) {
                return Dartboard();
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: OurThinButton(
                onPressed: () {
                  showNewGameSettingsDialog(context);
                },
                text: AppLocalizations.of(context)!.newGame,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: OurThinButton(
                onPressed: () {
                  showHistoryDialog(context);
                },
                text: AppLocalizations.of(context)!.history,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: OurThinButton(
                onPressed: () {
                  showRulesDialog(context);
                },
                text: AppLocalizations.of(context)!.dartRules,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
