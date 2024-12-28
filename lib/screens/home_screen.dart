import 'package:darttracker/utils/dialog_utils.dart';
import 'package:darttracker/views/widgets/dart_board/dartboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/theme_notifier.dart';

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
              child: ElevatedButton(
                onPressed: () {
                  showNewGameDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  minimumSize: const Size(200, 60),
                ),
                child: const Text('New Game'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  minimumSize: const Size(200, 60),
                ),
                child: const Text('Game History'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  minimumSize: const Size(200, 60),
                ),
                child: const Text('Darts Rules'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
