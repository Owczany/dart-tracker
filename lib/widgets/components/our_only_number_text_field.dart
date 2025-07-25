import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pole tekstowe do wpisania tylko liczb
class OurOnlyNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;

  const OurOnlyNumberTextField ({
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