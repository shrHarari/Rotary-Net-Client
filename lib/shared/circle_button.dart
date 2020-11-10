import 'package:flutter/material.dart';

Widget circleButtonBackground(double aBackgroundButtonSize, Color aBackgroundColor) {
  return Container(
    width: aBackgroundButtonSize,
    height: aBackgroundButtonSize,
    decoration: BoxDecoration(
      color: aBackgroundColor,
      shape: BoxShape.circle,
    ),
  );
}

class CircleButton extends StatelessWidget {
  final String buttonText;
  final double backgroundButtonSize;
  final double foregroundButtonSize;
  final Color backgroundColor;
  final Color foregroundColor;
  final GestureTapCallback onTap;

  const CircleButton({Key key, this.buttonText, this.backgroundButtonSize, this.foregroundButtonSize, this.backgroundColor, this.foregroundColor, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        circleButtonBackground(backgroundButtonSize, backgroundColor),
        Positioned(
          top: (backgroundButtonSize-foregroundButtonSize)/2,
          left:  (backgroundButtonSize-foregroundButtonSize)/2,
          child: InkResponse(
            onTap: onTap,
            child: Container(
              width: foregroundButtonSize,
              height: foregroundButtonSize,
              decoration: BoxDecoration(
                color: foregroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                      color: backgroundColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}