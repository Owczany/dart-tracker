import 'package:darttracker/widgets/dialogs/new_game_dialog.dart';
import 'package:darttracker/widgets/adapters/dartboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_notifier.dart';
import '../widgets/components/default_button.dart';

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
                text: 'New Game',
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: DefaultButton(
                onPressed: () {},
                text: 'Game History',
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: DefaultButton(
                onPressed: () {},
                text: 'Darts Rules',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
