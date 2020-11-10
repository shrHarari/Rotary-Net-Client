import 'package:flutter/material.dart';

class BubblesBoxDetailMessage extends StatelessWidget {
  final RichText aRichText;
  final Color bubbleColor;

  const BubblesBoxDetailMessage({Key key,
    this.bubbleColor,
    this.aRichText});

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[

        Container(
          decoration: BoxDecoration(
            color: Colors.amber,
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
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),

          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 15.0, right: 30.0, bottom: 15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    child: aRichText
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 0,
          right: 0,
          child: CustomPaint(
            painter: BubblesBoxDecorationPinBorder(aBubbleColor: bubbleColor),
          ),
        ),

        Positioned(
          top: 0.0,
          right: 0.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
            child: CustomPaint(
              painter: BubblesBoxDecorationPin(aBubbleColor: bubbleColor),
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
  Color aBubbleColor;
  BubblesBoxDecorationPin({this.aBubbleColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = aBubbleColor;

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
  Color aBubbleColor;
  BubblesBoxDecorationPinBorder({this.aBubbleColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = aBubbleColor;
    paint.color = Colors.amber;

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