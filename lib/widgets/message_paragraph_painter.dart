import 'package:flutter/material.dart';
import 'dart:ui' as UI;

class MessageParagraphPainter extends CustomPainter {
  final String argTextPainter;
  final TextStyle argTextStyle;
  final int argMaxLines;
  final int argCurrentLines;
  final TextDirection argTextDirection;
  final Color argBackgroundColor;

  MessageParagraphPainter(
      this.argTextPainter,
      this.argTextStyle,
      this.argMaxLines,
      this.argCurrentLines,
      this.argTextDirection,
      this.argBackgroundColor,
      );

  @override
  void paint(Canvas canvas, Size size) {
    // Background to expose where the canvas is
    canvas.drawRect(
        Offset(0, 0) & size,
        Paint()..color = argBackgroundColor
    );

    // Since text is overflowing, you have two options: clipping before drawing text or/and defining max lines.
    // canvas.clipRect(Offset(10, 0) & size);

    final paragraphStyle = UI.ParagraphStyle(
        textAlign: TextAlign.justify,
        maxLines: argMaxLines,
        textDirection: argTextDirection
    );

    final paragraphBuilder = UI.ParagraphBuilder(paragraphStyle)
    ..pushStyle(argTextStyle.getTextStyle()) // To use multiple styles
    ..addText(argTextPainter);

    final constraints = UI.ParagraphConstraints(width: size.width - 40);

    final UI.Paragraph paragraph = paragraphBuilder.build();

    paragraph.layout(constraints); // Paragraph need to have specified width

    Offset _offset;
    switch (argCurrentLines) {
      case 1: _offset = Offset(20.0, 30.0);
      break;
      case 2: _offset = Offset(20.0, 15.0);
      break;
      default: _offset = Offset(20.0, 5.0);
    }
    canvas.drawParagraph(paragraph, _offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Just for example, in real environment should be implemented!
  }
}