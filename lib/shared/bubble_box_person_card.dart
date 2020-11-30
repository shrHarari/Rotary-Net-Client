import 'package:flutter/material.dart';

class BubblesBoxPersonCard extends StatelessWidget {
  final String argText;
  final Color argBubbleBackgroundColor;
  final Color argBubbleBackgroundColorDark;
  final Color argBubbleBorderColor;
  final bool isWithShadow;
  final bool isWithGradient;
  final bool displayPin;

  const BubblesBoxPersonCard({
    Key key,
    @required this.argText,
    @required this.argBubbleBackgroundColor,
    this.argBubbleBackgroundColorDark,
    @required this.argBubbleBorderColor,
    this.isWithShadow = false,
    this.isWithGradient = false,
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  boxShadow: [
                    isWithShadow ? BoxShadow(
                      blurRadius: 10.0,
                      offset: Offset(5, 5),
                      color: Colors.black54,
                    ) :
                    BoxShadow(
                      blurRadius: 0.0,
                      offset: Offset(0, 0),
                      color: argBubbleBackgroundColor
                    ),
                  ],
                  gradient: isWithGradient
                      ? LinearGradient(
                        colors: [argBubbleBackgroundColor, argBubbleBackgroundColorDark],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      )
                      : LinearGradient(
                        colors: [argBubbleBackgroundColor, argBubbleBackgroundColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      ),
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 15.0),
                child: Text.rich(
                  buildTextSpan(argText),
                  textDirection: TextDirection.rtl,
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

  TextSpan buildTextSpan(String aDescription){
    return TextSpan(
        style: TextStyle(fontSize: 14),
        children: [
          TextSpan(
              text: aDescription,
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ))
        ]
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
    // paint.color = Colors.white;

    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(-17, 0);
    path.lineTo(0, -19);

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
  final Color argPinBorderColor;
  BubblesBoxDecorationPinBorder({this.argPinBorderColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = argPinBorderColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(-20, 0);
    path.lineTo(0, -22);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
//#endregion
