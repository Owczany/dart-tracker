import 'package:darttracker/views/widgets/dart_board/dartboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Witaj w dart trackerze!'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
          // Zlicz punkty
          Center(
            child: Text('Zlicz punkty'),
          ),

          Center(child: Text(AppLocalizations.of(context)!.dartboard),),

          // Stwórz party
          Center(child: Text('Stwórz party')),

          // Zobacz hisotrię
          Center(
            child: Text('Zobacz historię'),
          ),

          Dartboard(),

        ],
      ),
    );
  }
}
