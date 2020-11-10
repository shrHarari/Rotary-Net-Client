import 'package:flutter/material.dart';

class BubblesBoxRotaryMessage extends StatelessWidget {
  final Widget argContent;
  final Alignment argContentAlignment;
  final Color argBubbleBackgroundColor;
  final Color argBubbleBorderColor;
  final bool displayPin;

  const BubblesBoxRotaryMessage({Key key,
    @required this.argContent,
    this.argContentAlignment = Alignment.center,
    @required this.argBubbleBackgroundColor,
    @required this.argBubbleBorderColor,
    this.displayPin = true});

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: argBubbleBorderColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: argBubbleBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
        ),

        Container(
          alignment: argContentAlignment,
          margin: const EdgeInsets.all(2.0),
          child: argContent,
        ),

        if (displayPin)
          Positioned(
            top: 0.0,
            right: 0.0,
            child: CustomPaint(
              painter: BubblesBoxDecorationPinBorder(argBubbleBorderColor: argBubbleBorderColor),
            ),
          ),

        if (displayPin)
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
              child: CustomPaint(
                painter: BubblesBoxDecorationPin(argBubbleBackgroundColor: argBubbleBackgroundColor),
              ),
            ),
          ),
      ],
    );
  }
}

// Draw the Bubble Pin
// The Pin location is set on positioning which call this function
class BubblesBoxDecorationPin extends CustomPainter {
  Color argBubbleBackgroundColor;
  BubblesBoxDecorationPin({this.argBubbleBackgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = argBubbleBackgroundColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(-15, 0);
    path.lineTo(0, -15);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// Draw the Bubble Pin
// The Pin location is set on positioning which call this function
class BubblesBoxDecorationPinBorder extends CustomPainter {
  final Color argBubbleBorderColor;
  BubblesBoxDecorationPinBorder({this.argBubbleBorderColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = argBubbleBorderColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(-17, 0);
    path.lineTo(0, -17);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}