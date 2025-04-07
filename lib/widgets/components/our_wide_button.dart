import 'package:flutter/material.dart';

/// Elevated button z ustawionymi na sztywno parametrami wyglądu
/// Szeroki przycisk
class OurWideButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final Size minimumSize;

  const OurWideButton({
    super.key, 
    required this.text, 
    required this.onPressed, 
    required this.color, 
    this.textColor = Colors.black,
    this.minimumSize = const Size(double.infinity, 50), // Szerokość na cały ekran, wysokość 50
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize,
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20, 
            //fontWeight: FontWeight.bold
          )
        ),
      ),
    );
  }
}