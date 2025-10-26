// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'otp_controller.dart';
import 'otp_digit_field.dart';

class OtpField extends StatefulWidget {
  const OtpField(
      {required this.controller,
      this.size = const Size.square(40),
      this.spacing = 0.0,
      this.inactiveDecoration,
      this.activeDecoration,
      super.key});

  final OtpController controller;
  final Size size;
  final double spacing;
  final Decoration? inactiveDecoration;
  final Decoration? activeDecoration;

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> with TextInputClient {
  TextInputConnection? _connection;

  int get length => widget.controller.length;

  late final List<FocusNode> _nodes;

  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(length, (i) {
      return FocusNode(debugLabel: 'Focus Node $i')
        ..addListener(() => _onFocusChange(i));
    });
  }

  @override
  void dispose() {
    for (final node in _nodes) {
      node.dispose();
    }
    _closeConnection();
    super.dispose();
  }

  void _onFocusChange(int index) {
    if (_nodes[index].hasFocus) {
      _currentIndex = index;
      if (_connection == null || !_connection!.attached) {
        _openConnection();
      } else {
        _connection!.setEditingState(
            TextEditingValue(text: widget.controller.digitAt(index)));
      }
    } else {
      final isOtpFieldFocused = _nodes.any((node) => node.hasFocus);
      if (!isOtpFieldFocused) {
        _closeConnection();
      }
    }
  }

  void _openConnection() {
    _connection = TextInput.attach(this, const TextInputConfiguration());
    _connection!.setEditingState(
        TextEditingValue(text: widget.controller.digitAt(_currentIndex)));
    _connection!.show();
  }

  void _closeConnection() {
    _connection?.close();
    _connection = null;
  }

  void _onBackSpace() {
    if (widget.controller.digitAt(_currentIndex).isNotEmpty) {
      widget.controller.setDigitAt(_currentIndex, '');
    }
    if (_currentIndex != 0) {
      FocusScope.of(context).requestFocus(_nodes[_currentIndex - 1]);
      _currentIndex--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final preferredWidth =
            (widget.size.width * length) + (widget.spacing * (length - 1));
        return SizedBox(
          width: math.min(constraints.maxWidth, preferredWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(length, (i) {
              return KeyboardListener(
                focusNode: _nodes[i],
                onKeyEvent: (event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace) {
                    _onBackSpace();
                  }
                },
                child: GestureDetector(
                    onTap: () {
                      if (i == 0 || widget.controller.digitAt(i).isNotEmpty) {
                        FocusScope.of(context).requestFocus(_nodes[i]);
                        _currentIndex = i;
                      }
                    },
                    child: ListenableBuilder(
                      listenable: widget.controller,
                      builder: (context, child) {
                        return SizedBox.fromSize(
                          size: widget.size,
                          child: OtpDigitField(
                            focusNode: _nodes[i],
                            digit: widget.controller.digitAt(i),
                            style: Theme.of(context).textTheme.titleSmall,
                            activeDecoration: widget.activeDecoration,
                            inactiveDecoration: widget.inactiveDecoration,
                          ),
                        );
                      },
                    )),
              );
            }),
          ),
        );
      }),
    );
  }

  @override
  void connectionClosed() => _closeConnection();

  @override
  AutofillScope? get currentAutofillScope => throw UnimplementedError();

  @override
  TextEditingValue? get currentTextEditingValue =>
      TextEditingValue(text: widget.controller.digitAt(_currentIndex));

  @override
  void performAction(TextInputAction action) {
    if (action == TextInputAction.done) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void showAutocorrectionPromptRect(int start, int end) {
    // TODO: implement showAutocorrectionPromptRect
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    final regex = RegExp(r'^\d+$');
    _connection!.setEditingState(TextEditingValue.empty);
    if (value.text.isNotEmpty && regex.hasMatch(value.text)) {
      widget.controller.setDigitAt(_currentIndex, value.text[0]);

      if (_currentIndex < length - 1) {
        FocusScope.of(context).requestFocus(_nodes[_currentIndex + 1]);
        _currentIndex++;
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    // TODO: implement updateFloatingCursor
  }
}
