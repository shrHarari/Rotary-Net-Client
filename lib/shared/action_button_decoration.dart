import 'package:flutter/material.dart';

enum ButtonType {
  Decorated,
  Rectangle,
  Circle
}

class ActionButtonDecoration extends StatelessWidget {
  final ButtonType argButtonType;
  final double argHeight;
  final String argButtonText;
  final IconData argIcon;
  final double argIconSize;
  final VoidCallback onPressed;

  const ActionButtonDecoration({
    @required this.argButtonType,
    this.argHeight,
    this.argButtonText,
    this.argIcon,
    this.argIconSize,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (argButtonType) {
      case ButtonType.Decorated:
        return updateDecoratedButton();
        break;
      case ButtonType.Rectangle:
        return updateRectangleButton();
        break;
      case ButtonType.Circle:
        return updateCircleButton();
        break;
      default:
        return updateDecoratedButton();
        break;
    }
  }

  //#region Decorated Button
  Widget updateDecoratedButton() {
    return InkWell(
      onTap: onPressed,
      child:
      Container(
        height: argHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff1959a9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  argIcon,
                  color:Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff2872ba),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  argButtonText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //#endregion

  //#region Circle Button
  Widget updateCircleButton() {
    return MaterialButton(
      elevation: 0.0,
      onPressed: onPressed,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(side: BorderSide(color: Colors.blue)),
      child: IconTheme(
        data: IconThemeData(
          color: Colors.black,
        ),
        child: Icon(
          argIcon,
          size: argIconSize,
        ),
      ),
    );
  }
  //#endregion

  //#region Rectangle Button
  Widget updateRectangleButton() {
    return RaisedButton.icon(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      label: Text(
        argButtonText,
        style: TextStyle(
            color: Colors.white,fontSize: 16.0
        ),
      ),
      icon: Icon(
        argIcon,
        color:Colors.white,
      ),
      textColor: Colors.white,
      color: Colors.blue[400],
    );
  }
  //#endregion
}