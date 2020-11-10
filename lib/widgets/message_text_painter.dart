import 'package:flutter/material.dart';

class MessageTextPainter extends CustomPainter {
  final String argTextPainter;
  final TextStyle argTextStyle;
  final int argMaxLines;
  final TextDirection argTextDirection;

  MessageTextPainter(this.argTextPainter, this.argTextStyle, this.argMaxLines, this.argTextDirection);

  @override
  void paint(Canvas canvas, Size size) {
    // Background to expose where the canvas is
    canvas.drawRect(Offset(0, 0) & size, Paint()..color = Colors.red[100]);

    // Since text is overflowing, you have two options: clipping before drawing text or/and defining max lines.
    canvas.clipRect(Offset(0, 0) & size);

    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: argTextPainter, style: argTextStyle), // TextSpan could be whole TextSpans tree :)
        textAlign: TextAlign.justify,
        maxLines: argMaxLines, // In both TextPainter and Paragraph there is no option to define max height, but there is `maxLines`
        textDirection: argTextDirection // It is necessary for some weird reason... IMO should be LTR for default since well-known international languages (english, esperanto) are written left to right.
    )
      ..layout(maxWidth: size.width - 12.0 - 12.0); // TextPainter doesn't need to have specified width (would use infinity if not defined).
    // BTW: using the TextPainter you can check size the text take to be rendered (without `paint`ing it).
    textPainter.paint(canvas, const Offset(12.0, 36.0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Just for example, in real environment should be implemented!
  }
}