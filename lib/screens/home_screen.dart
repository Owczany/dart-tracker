import 'package:darttracker/widgets/components/drawer.dart';
import 'package:darttracker/widgets/dialogs/new_game_dialog.dart';
import 'package:darttracker/widgets/adapters/dartboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_notifier.dart';
import '../widgets/components/default_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        ],
      ),
      drawer: const OurDrawer(screen: CurrentScreen.home,),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Dartboard(),
            const SizedBox(height: 30),
            Center(
              child: DefaultButton(
                onPressed: () {
                  showNewGameDialog(context);
                },
                text: AppLocalizations.of(context)!.newGame,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: DefaultButton(
                onPressed: () {},
                text: AppLocalizations.of(context)!.history,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: DefaultButton(
                onPressed: () {},
                text: AppLocalizations.of(context)!.dartRules,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
