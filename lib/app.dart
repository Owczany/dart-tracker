import 'package:darttracker/screens/home_screen.dart';
import 'package:darttracker/themes/theme_notifier.dart';
import 'package:darttracker/models/dartboard_notifier.dart';
import 'package:darttracker/utils/locate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => DartboardNotifier()),
      ],
      child: Consumer3<ThemeNotifier, LocaleProvider, DartboardNotifier>(
        builder:
            (context, themeNotifier, localeProvider, dartboardNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppLocalizations.of(context)?.appTitle ?? 'Dart Tracker',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeProvider.locale, // Ustawienie języka
            theme: themeNotifier.currentTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
