import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//#region OBJECT TYPE: Message Dialog Action Object
class MessageDialogActionObject {
  final String title;
  final VoidCallback onPressed;

  MessageDialogActionObject({this.title, this.onPressed});
}
//#endregion

class MessageDialogWidget extends StatefulWidget {
  final Widget argDialogTitle;
  final List<MessageDialogActionObject> argDialogActions;

  MessageDialogWidget({Key key, @required this.argDialogTitle, @required this.argDialogActions});

  @override
  _MessageDialogWidgetState createState() => _MessageDialogWidgetState();
}

class _MessageDialogWidgetState extends State<MessageDialogWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return AlertDialog(
      content: Container(
        height: 100,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              ),
            ),

            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: widget.argDialogTitle,
                  ),

                  buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //#region Build Action Buttons
  Widget buildActionButtons() {

    return Row(
      children: widget.argDialogActions.map<Widget>(
            (actionButton) => buildActionButtonWidget(actionButton),
      ).toList());
  }

  Widget buildActionButtonWidget(MessageDialogActionObject aDialogActions) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: RaisedButton(
        child: Text(aDialogActions.title),
        onPressed: () {aDialogActions.onPressed(); },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        textColor: Colors.white,
        color: Colors.blue[400],
      ),
    );
  }
  //#endregion
}

