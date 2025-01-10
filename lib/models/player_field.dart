import 'package:darttracker/models/player.dart';
import 'package:flutter/material.dart';

class PlayerField {
  final TextEditingController controller;
  final FocusNode focusNode;
  bool isReadOnly;
  bool isEditing;
  Player? player;

  PlayerField({
    required this.controller,
    required this.focusNode,
    this.isReadOnly = false,
    this.isEditing = false,
    this.player,
  });

  void edit() {
    isReadOnly = false;
    isEditing = true;
  }

  void save() {
    if (controller.text.isNotEmpty) {
      player = Player(name: controller.text);
    }
    isReadOnly = true;
    isEditing = false;
  }

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}
