import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}