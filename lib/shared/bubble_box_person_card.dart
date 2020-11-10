import 'package:flutter/material.dart';

class BubblesBoxPersonCard extends StatelessWidget {

  final String aText;
  final Color bubbleColor;
  final bool isWithShadow;
  final bool isWithGradient;

  const BubblesBoxPersonCard({Key key, this.bubbleColor, this.aText, this.isWithShadow, this.isWithGradient});

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          DecoratedBox(
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
                    color: bubbleColor
                  ),
                ],
                gradient: isWithGradient
                    ? LinearGradient(
                      colors: [bubbleColor, Colors.blue[50]],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                    : LinearGradient(
                      colors: [bubbleColor, bubbleColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    ),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 15.0, right: 30.0, bottom: 15.0),
                child: Text.rich(
                  buildTextSpan(aText),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              painter: BubblesBoxDecorationPin(aBubbleColor: bubbleColor),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan buildTextSpan(String aDescription){
    return TextSpan(
        style: TextStyle(fontSize: 14),
        children: [
          TextSpan(
              text: aDescription,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  //decorationStyle: TextDecorationStyle.wavy,
                  //decorationColor: Colors.red,
                  fontWeight: FontWeight.bold
              ))
        ]
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
