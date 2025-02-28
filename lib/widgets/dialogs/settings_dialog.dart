import 'package:darttracker/utils/locate_provider.dart';
import 'package:darttracker/widgets/components/our_only_number_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:darttracker/models/dartboard_notifier.dart';
import 'package:darttracker/models/game_settings_notifier.dart';
import 'package:darttracker/themes/theme_notifier.dart';
import 'package:darttracker/themes/light_theme.dart';
import 'package:darttracker/themes/dark_theme.dart';

class SettingsDialog extends StatefulWidget {
  final bool isMainMenu;
  const SettingsDialog({super.key, required this.isMainMenu});

  @override
  SettingsDialogState createState() => SettingsDialogState();
}

class SettingsDialogState extends State<SettingsDialog> {
  late bool isMainMenu;
  final TextStyle tittleStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    isMainMenu = widget.isMainMenu;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.settings),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ustawianie języka
            Text(AppLocalizations.of(context)!.settings_choose_language,
                style: tittleStyle),
            const SizedBox(height: 8),
            Consumer<LocaleProvider>(builder: (context, localeProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Switch(
                    value: localeProvider.locale.languageCode == 'en',
                    onChanged: (bool value) {
                      localeProvider.setLocale(Locale(value ? 'en' : 'pl'));
                    },
                  ),
                  Text(
                    localeProvider.locale.languageCode == 'en'
                        ? 'English'
                        : 'Polski',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),

            // ustawianie motywu
            Text(AppLocalizations.of(context)!.settings_choose_theme,
                style: tittleStyle),
            const SizedBox(height: 8),
            Consumer<ThemeNotifier>(builder: (context, themeNotifier, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Switch(
                    value: themeNotifier.currentTheme == DarkTheme.themeData,
                    onChanged: (bool value) {
                      themeNotifier.toggleTheme();
                    },
                  ),
                  Text(
                    themeNotifier.currentTheme == DarkTheme.themeData
                        ? AppLocalizations.of(context)!.settings_theme_dark
                        : AppLocalizations.of(context)!.settings_theme_light,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            }),
            if (!isMainMenu) ...[
              const SizedBox(height: 16),

              // ustawianie tarczy
              Text(AppLocalizations.of(context)!.settings_board_version,
                  style: tittleStyle),
              const SizedBox(height: 8),
              Consumer<DartboardNotifier>(
                builder: (context, dartboardNotifier, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch(
                        value: dartboardNotifier.boardVersion,
                        onChanged: (bool value) {
                          dartboardNotifier.toggleBoardVersion();
                        },
                      ),
                      Text(
                        dartboardNotifier.boardVersion
                            ? AppLocalizations.of(context)!.settings_touch
                            : AppLocalizations.of(context)!.settings_type,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // wyświetlanie numerów na tarczy
              Text(AppLocalizations.of(context)!.settings_show_numbers,
                  style: tittleStyle),
              const SizedBox(height: 8),
              Consumer<DartboardNotifier>(
                builder: (context, dartboardNotifier, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch(
                        value: dartboardNotifier.showNumbers,
                        onChanged: (bool value) {
                          dartboardNotifier.toggleShowNumbers();
                        },
                      ),
                      Text(
                        dartboardNotifier.showNumbers
                            ? AppLocalizations.of(context)!.on
                            : AppLocalizations.of(context)!.off,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }
}


/// Funkcja wyświetlająca dialog ustawień (zmiana wyniku gry jest ukryta, jeżeli changableScore = false)
void showSettingsDialog(BuildContext context, {bool isMainMenu = true}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SettingsDialog(isMainMenu: isMainMenu);
    },
  );
}
