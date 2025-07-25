import 'package:flutter/material.dart';

/// Elevated button z ustawionymi na sztywno parametrami wyglądu
/// Cieńki przycisk
class OurThinButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const OurThinButton({required this.onPressed, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 20),
        minimumSize: const Size(200, 60),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      child: Text(text),
    );
  }
}
