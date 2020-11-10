import 'package:flutter/material.dart';

//#region Rotary Error Message Screen
class RotaryErrorMessageScreen extends StatelessWidget {
  final String errTitle;
  final String errMsg;

  RotaryErrorMessageScreen({this.errTitle, this.errMsg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
          title: Text('Rotary / $errTitle'),
        ),
        body: Center(
          child: Container(
            color: Colors.blue[100],
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.0,),
                Text(
                  '$errMsg',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20.0),
                  ),
                ],
              ),
          ),
        )
    );
  }
}
//#endregion

//#region Display Error Text
class DisplayErrorText extends StatelessWidget {
  final String errorText;

  const DisplayErrorText({Key key, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorText,
            style: Theme.of(context).textTheme.headline5
          ),
        ],
      ),
    );
  }
}
//#endregion

//#region Display Error Text And Retry Button
class DisplayErrorTextAndRetryButton extends StatelessWidget {
  final String errorText;
  final String buttonText;
  final VoidCallback onPressed;

  const DisplayErrorTextAndRetryButton({Key key, this.errorText, this.buttonText, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              errorText,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(buttonText,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.white)),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
//#endregion
