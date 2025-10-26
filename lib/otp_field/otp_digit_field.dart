import 'dart:async';

import 'package:flutter/material.dart';

class OtpDigitField extends StatefulWidget {
  const OtpDigitField({
    super.key,
    required this.digit,
    required this.focusNode,
    this.style,
    this.inactiveDecoration,
    this.activeDecoration,
  });

  final FocusNode focusNode;
  final String digit;
  final TextStyle? style;
  final Decoration? inactiveDecoration;
  final Decoration? activeDecoration;

  @override
  State<OtpDigitField> createState() => OtpDigitFieldState();
}

class OtpDigitFieldState extends State<OtpDigitField> {
  final Decoration _defaultDecoration =
      BoxDecoration(border: Border.all(color: Colors.black));

  late TextStyle style = widget.style ?? const TextStyle();
  late Decoration inactiveDecoration =
      widget.inactiveDecoration ?? _defaultDecoration;
  late Decoration activeDecoration =
      widget.activeDecoration ?? _defaultDecoration;

  late bool hasFocus = widget.focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() => _updateValues());
      }
    });
  }

  @override
  void didUpdateWidget(covariant OtpDigitField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateValues();
  }

  void _updateValues() {
    hasFocus = widget.focusNode.hasFocus;
    style = widget.style ?? const TextStyle();
    inactiveDecoration = widget.inactiveDecoration ?? _defaultDecoration;
    activeDecoration = widget.activeDecoration ?? _defaultDecoration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: hasFocus ? activeDecoration : inactiveDecoration,
      child: _OtpDigitBox(
        digit: widget.digit,
        style: style,
        isFocused: hasFocus,
      ),
    );
  }
}

class _OtpDigitBox extends LeafRenderObjectWidget {
  const _OtpDigitBox(
      {required this.digit, required this.style, required this.isFocused});

  final String digit;
  final TextStyle style;
  final bool isFocused;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _OtpRenderBox(
      digit: digit,
      style: style,
      isFocused: isFocused,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _OtpRenderBox renderObject) {
    renderObject
      ..digit = digit
      ..style = style
      ..isFocused = isFocused;
  }
}

class _OtpRenderBox extends RenderBox {
  _OtpRenderBox({
    required String digit,
    required TextStyle style,
    required bool isFocused,
  })  : _digit = digit,
        _style = style,
        _isFocused = isFocused;

  String _digit;

  String get digit => _digit;

  set digit(String value) {
    if (digit == value) return;
    _digit = value;
    markNeedsPaint();
  }

  TextStyle _style;

  TextStyle get style => _style;

  set style(TextStyle value) {
    if (style == value) return;
    _style = value;
    markNeedsPaint();
  }

  bool _isFocused;

  bool get isFocused => _isFocused;

  set isFocused(bool value) {
    if (isFocused == value) return;
    _isFocused = value;
    if (isFocused) {
      _startCaretAnimation();
    } else {
      _endCaretAnimation();
    }
    markNeedsPaint();
  }

  Timer? _caretTimer;
  bool showCaret = false;

  void _startCaretAnimation() {
    showCaret = true;
    _caretTimer ??= Timer.periodic(const Duration(milliseconds: 500), (_) {
      showCaret = !showCaret;
      markNeedsPaint();
    });
  }

  void _endCaretAnimation() {
    showCaret = false;
    _caretTimer?.cancel();
    _caretTimer = null;
  }

  @override
  void performLayout() {
    size = constraints.smallest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final rect = offset & size;

    // Draw Text
    final textPainter = TextPainter(
        text: TextSpan(text: digit, style: style),
        textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: size.width);
    final textSize = textPainter.size / 2;
    final textOffset = rect.center - Offset(textSize.width, textSize.height);
    textPainter.paint(canvas, textOffset);

    if (showCaret) {
      final boxes = textPainter.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 1),
      );
      final glyphBox = boxes.isNotEmpty ? boxes.first : null;
      double caretHeight = textPainter.preferredLineHeight;
      double caretTopOffset = rect.top;
      if (glyphBox != null) {
        caretHeight = glyphBox.toRect().height;
        caretTopOffset = rect.top + (rect.height - caretHeight) / 2;
      }

      final caretPrototype =
          Rect.fromLTWH(textOffset.dx, caretTopOffset, 1, caretHeight);
      final caretOffset = textPainter.getOffsetForCaret(
          const TextPosition(offset: 1), caretPrototype);

      canvas.drawRect(
          caretPrototype.shift(caretOffset), Paint()..color = Colors.black);
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;
}
