import 'package:darttracker/screens/score_board_screen.dart';
import 'package:flutter/material.dart';

import '../models/player.dart';

class NewGameDialog extends StatefulWidget {
  const NewGameDialog({super.key});

  @override
  NewGameDialogState createState() => NewGameDialogState();
}

class NewGameDialogState extends State<NewGameDialog> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  final List<bool> _isReadOnly = [];
  final List<bool> _isEditing = [];
  final List<Player> _players = [];
  bool _isAnyEditing = false;

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController());
    _focusNodes.add(FocusNode());
    _isReadOnly.add(false);
    _isEditing.add(false);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _addNewWidget() {
    setState(() {
      if (_controllers.isNotEmpty && _controllers.last.text.isNotEmpty) {
        _players.add(Player(name: _controllers.last.text, scores: [0]));
      }
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      _isReadOnly.add(false);
      _isEditing.add(false);
      if (_controllers.length > 1) {
        _isReadOnly[_controllers.length - 2] = true;
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNodes.last);
      }
    });
  }

  void _removeWidget(int index) {
    setState(() {
      _controllers[index].dispose();
      _focusNodes[index].dispose();
      _controllers.removeAt(index);
      _focusNodes.removeAt(index);
      _isReadOnly.removeAt(index);
      _isEditing.removeAt(index);
      if (index < _players.length) {
        _players.removeAt(index);
      }
      _isAnyEditing = _isEditing.contains(true);
    });
  }

  void _editWidget(int index) {
    setState(() {
      _isReadOnly[index] = false;
      _isEditing[index] = true;
      _isAnyEditing = true;
      FocusScope.of(context).requestFocus(_focusNodes[index]);
    });
  }

  void _saveWidget(int index) {
    setState(() {
      if (_controllers[index].text.isNotEmpty) {
        if (index < _players.length) {
          _players[index] =
              Player(name: _controllers[index].text, scores: [0]);
        } else {
          _players
              .add(Player(name: _controllers[index].text, scores: [0]));
        }
      }
      _isReadOnly[index] = true;
      _isEditing[index] = false;
      _isAnyEditing = false;
      FocusScope.of(context).requestFocus(_focusNodes.last);
    });
  }

  bool _isLastFieldEmpty() {
    return _controllers.isNotEmpty && _controllers.last.text.isEmpty;
  }

  bool _isFirstFieldSaved() {
    return _players.isNotEmpty && _players.first.name.isNotEmpty;
  }

  bool _canStartGame() {
    return _isFirstFieldSaved() &&
        (_controllers.length == 1 || _isLastFieldEmpty());
  }

  void _startGame() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ScoreBoardScreen(
            players: _players, playerNumber: 0, roundNumber: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Game'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Enter player names:'),
          const SizedBox(height: 10),
          ..._controllers.asMap().entries.map((entry) {
            int index = entry.key;
            TextEditingController controller = entry.value;
            FocusNode focusNode = _focusNodes[index];
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    readOnly: _isReadOnly[index] ||
                        (_isAnyEditing && !_isEditing[index]),
                    enabled: !_isAnyEditing || _isEditing[index],
                    decoration: InputDecoration(
                      labelText: 'Player ${index + 1}',
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(_isEditing[index]
                      ? Icons.check
                      : (index == _controllers.length - 1
                          ? Icons.add
                          : Icons.edit)),
                  onPressed: _isAnyEditing && !_isEditing[index] ||
                          (index == _controllers.length - 1 &&
                              controller.text.isEmpty)
                      ? null
                      : () {
                          if (_isEditing[index]) {
                            _saveWidget(index);
                          } else if (index == _controllers.length - 1) {
                            _addNewWidget();
                          } else {
                            _editWidget(index);
                          }
                        },
                ),
                if (index != _controllers.length - 1)
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
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isAnyEditing || !_canStartGame() ? null : _startGame,
          child: const Text('Start'),
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
