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
        title: const Text('Dart Tracker'),
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
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Zlicz punkty'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Stwórz party'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Zobacz historię'),
              ),
            ),
            Dartboard(),
          ],
        ),
      ),
    );
  }
}
