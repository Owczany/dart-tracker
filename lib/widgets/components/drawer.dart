import 'package:darttracker/screens/home_screen.dart';
import 'package:darttracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OurDrawer extends StatelessWidget {
  final CurrentScreen screen;
  const OurDrawer({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,

        // Determinates the behavior of scrolling
        physics: const AlwaysScrollableScrollPhysics(),
        // Item list
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(child: Text(AppLocalizations.of(context)!.menu)),
          ),
          _buildListTile(context,
              text: AppLocalizations.of(context)!.mainScreen, onTap: () {
            if (screen != CurrentScreen.home) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }
          }),
          _buildListTile(context, text: AppLocalizations.of(context)!.newGame),
          _buildListTile(context, text: AppLocalizations.of(context)!.history),
          _buildListTile(context, text: AppLocalizations.of(context)!.stats),
          _buildListTile(
            context,
            text: AppLocalizations.of(context)!.settings,
            onTap: () {
              if (screen != CurrentScreen.settings) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              }
            },
          ),
          _buildListTile(context, text: 'Exit') // Wyjdź z aplikacji
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String text, Function()? onTap}) {
    return ListTile(
      title: Text(text),
      onTap: onTap,
    );
  }
}

enum CurrentScreen {
  home,
  settings,
  history,
}
