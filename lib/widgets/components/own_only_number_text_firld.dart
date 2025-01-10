import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OwnOnlyNumberTextFirld extends StatelessWidget {
  final controller;
  final String text;

  OwnOnlyNumberTextFirld ({
    super.key,
    required this.controller,
    required this.text
  });


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(labelText: text),
    );
  }
}