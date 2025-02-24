import 'package:darttracker/screens/home_screen.dart';
import 'package:darttracker/themes/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Darts Tracker',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'), //! Ustawione na razie na sztywno do testów
              theme: themeNotifier.currentTheme,
              home: const HomeScreen());
        },
      ),
    );
  }
}