import 'package:flutter/material.dart';

class BubblesBoxDetailMessage extends StatelessWidget {
  final Widget argContent;
  final Alignment argContentAlignment;
  final Color argBubbleBackgroundColor;
  final Color argBubbleBorderColor;
  final bool displayPin;

  const BubblesBoxDetailMessage({
    Key key,
    @required this.argContent,
    this.argContentAlignment = Alignment.centerRight,
    @required this.argBubbleBackgroundColor,
    @required this.argBubbleBorderColor,
    this.displayPin = true});

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: argBubbleBorderColor, width: 2.0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
          child: Container(
            // margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: argBubbleBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),

            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 15.0, right: 30.0, bottom: 15.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      alignment: argContentAlignment,
                      child: argContent
                  ),
                ),
              ),
            ),
          ),
        ),

        if (displayPin)
          Positioned(
            top: 6.0,
            right: 4.0,
            child: CustomPaint(
              painter: BubblesBoxDecorationPinBorder(argPinBorderColor: argBubbleBorderColor),
            ),
          ),

        if (displayPin)
          Positioned(
            top: 6.0,
            right: 4.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
              child: CustomPaint(
                painter: BubblesBoxDecorationPin(argPinBackgroundColor: argBubbleBackgroundColor),
              ),
            ),
          ),
      ],
    );
  }
}

//#region Draw the Bubble Pin
class BubblesBoxDecorationPin extends CustomPainter {
  Color argPinBackgroundColor;
  BubblesBoxDecorationPin({this.argPinBackgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = argPinBackgroundColor;

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
//#endregion

//#region Draw the Bubble Pin Border
class BubblesBoxDecorationPinBorder extends CustomPainter {
  Color argPinBorderColor;
  BubblesBoxDecorationPinBorder({this.argPinBorderColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = argPinBorderColor;
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
//#endregion