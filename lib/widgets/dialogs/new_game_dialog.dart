import 'package:darttracker/models/player_field.dart';
import 'package:darttracker/models/match.dart';
import 'package:darttracker/screens/score_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewGameDialog extends StatefulWidget {
  const NewGameDialog({super.key});

  @override
  NewGameDialogState createState() => NewGameDialogState();
}

class NewGameDialogState extends State<NewGameDialog> {
  final List<PlayerField> _playerFields = [];
  bool _isAnyEditing = false;

  @override
  void initState() {
    super.initState();
    _playerFields.add(PlayerField(
      controller: TextEditingController(),
      focusNode: FocusNode(),
    ));
  }

  @override
  void dispose() {
    for (var playerField in _playerFields) {
      playerField.dispose();
    }
    super.dispose();
  }

  void _addNewWidget() {
    setState(() {
      if (_playerFields.isNotEmpty &&
          _playerFields.last.controller.text.isNotEmpty) {
        _playerFields.last.save();
      }
      _playerFields.add(PlayerField(
        controller: TextEditingController(),
        focusNode: FocusNode(),
      ));
      if (_playerFields.length > 1) {
        _playerFields[_playerFields.length - 2].isReadOnly = true;
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_playerFields.last.focusNode);
      }
    });
  }

  void _removeWidget(int index) {
    setState(() {
      _playerFields[index].dispose();
      _playerFields.removeAt(index);
      _isAnyEditing = _playerFields.any((field) => field.isEditing);
    });
  }

  void _editWidget(int index) {
    setState(() {
      _playerFields[index].edit();
      _isAnyEditing = true;
      FocusScope.of(context).requestFocus(_playerFields[index].focusNode);
    });
  }

  void _saveWidget(int index) {
    setState(() {
      _playerFields[index].save();
      _isAnyEditing = false;
      FocusScope.of(context).requestFocus(_playerFields.last.focusNode);
    });
  }

  bool _isLastFieldEmpty() {
    return _playerFields.isNotEmpty &&
        _playerFields.last.controller.text.isEmpty;
  }

  bool _isFirstFieldSaved() {
    return _playerFields.isNotEmpty && _playerFields.first.player != null;
  }

  bool _canStartGame() {
    return _isFirstFieldSaved() &&
        (_playerFields.length == 1 || _isLastFieldEmpty());
  }

  void _startGame() {
    final match = Match(
      players: _playerFields
          .where((field) => field.player != null)
          .map((field) => field.player!)
          .toList(),
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ScoreBoardScreen(match: match)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.newGame),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(AppLocalizations.of(context)!.new_game_enter_players_names),
          const SizedBox(height: 10),
          ..._playerFields.asMap().entries.map((entry) {
            int index = entry.key;
            PlayerField playerField = entry.value;
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: playerField.controller,
                    focusNode: playerField.focusNode,
                    readOnly: playerField.isReadOnly ||
                        (_isAnyEditing && !playerField.isEditing),
                    enabled: !_isAnyEditing || playerField.isEditing,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.player} ${index + 1}',
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(playerField.isEditing
                      ? Icons.check
                      : (index == _playerFields.length - 1
                          ? Icons.add
                          : Icons.edit)),
                  onPressed: _isAnyEditing && !playerField.isEditing ||
                          (index == _playerFields.length - 1 &&
                              playerField.controller.text.isEmpty)
                      ? null
                      : () {
                          if (playerField.isEditing) {
                            _saveWidget(index);
                          } else if (index == _playerFields.length - 1) {
                            _addNewWidget();
                          } else {
                            _editWidget(index);
                          }
                        },
                ),
                if (index != _playerFields.length - 1)
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed:
                        _isAnyEditing ? null : () => _removeWidget(index),
                  ),
              ],
            );
          }),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isAnyEditing
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: _isAnyEditing || !_canStartGame() ? null : _startGame,
          child: Text(AppLocalizations.of(context)!.start),
        ),
      ],
    );
  }
}

void showNewGameDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const NewGameDialog();
    },
  );
}
