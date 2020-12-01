import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/messages_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_page_screen.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_page_widgets.dart';
import 'package:rotary_net/shared/bubble_box_detail_message.dart';
import 'package:intl/date_symbol_data_local.dart' as SymbolData;
import 'package:intl/intl.dart' as Intl;
import 'package:rotary_net/widgets/message_dialog_widget.dart';

class RotaryMainPageMessageListTile extends StatelessWidget {
  final BuildContext argParentContext;
  final MessagePopulatedObject argMessagePopulatedObject;

  const RotaryMainPageMessageListTile({Key key, this.argParentContext, this.argMessagePopulatedObject}) : super(key: key);

  //#region Message Content

  static const MAX_LINES = 4;
  static const MAX_LENGTH_DISPLAY_LAST_LINE = 25;
  static const MAX_LENGTH_LINE = 30;

  //#region Get Text styles
  static const TextStyle messageMainTextStyle = TextStyle(
    fontFamily: 'Heebo-Light',
    fontSize: 16.0,
    height: 1.5,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle messageEndTextStyle = TextStyle(
      fontFamily: 'Heebo-Light',
      fontSize: 16.0,
      height: 1.5,
      color: Colors.black45,
      fontWeight: FontWeight.bold,
  );

  static const TextStyle messageMetaDataStyle = TextStyle(
      fontFamily: 'Heebo-Light',
      fontSize: 16.0,
      height: 1.5,
      color: Colors.black87
  );

  static const TextStyle messageRemarkStyle = TextStyle(
      fontFamily: 'Heebo-Light',
      fontSize: 16.0,
      height: 1.5,
      color: Colors.black45,
      fontWeight: FontWeight.bold,
  );
  //#endregion

  //#region Get Composer Name
  RichText getComposerName() {
    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        text: '[${argMessagePopulatedObject.composerFirstName} ${argMessagePopulatedObject.composerLastName}]: ',
        style: messageMetaDataStyle,
      ),
    );
  }
  //#endregion

  //#region Get Message Content Layout
  Widget getMessageContentLayout(String aText) {
    bool _isExpanded = false;
    Container returnWidget;

    return LayoutBuilder(
        builder: (context, size) {
          final span = TextSpan(text: aText, style: messageMainTextStyle);
          final textPainter = TextPainter(text: span, maxLines: MAX_LINES, textDirection: TextDirection.rtl);
          textPainter.layout(maxWidth: size.maxWidth, minWidth: 0);

          List<LineMetrics> lines = textPainter.computeLineMetrics();
          int numberOfLines = lines.length;

          if (numberOfLines > MAX_LINES)
          {
            returnWidget = Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Text(aText, style: messageMainTextStyle, maxLines: MAX_LINES,),
                  Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Material(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 0.5,
                              child:  InkWell(
                                // onTap: _handleOnTap,
                                child: Icon( _isExpanded ? Icons.expand_less : Icons.expand_more,
                                  color: Colors.grey.withOpacity(0.8),),
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'קרא עוד ...',
                              style: messageRemarkStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            returnWidget = Container(
              child: Container(
                child: Text(aText, style: messageMainTextStyle,),
              ),
            );
          }
          return returnWidget;
        }
    );
  }
  //#endregion

  //#region Get Hebrew Message Created DateTime
  RichText getHebrewMessageCreatedDateTime() {
    SymbolData.initializeDateFormatting("he", null);
    var formatterStartDate = Intl.DateFormat.yMMMMEEEEd('he');
    String hebrewMessageCreatedDateTime = formatterStartDate.format(argMessagePopulatedObject.messageCreatedDateTime);

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: '\n[תאריך]: ',
            style: messageMetaDataStyle,
          ),
          TextSpan(
            text: hebrewMessageCreatedDateTime,
            style: messageMetaDataStyle,
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Get Message Content
  Widget getMessageContent(String aText) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getComposerName(),

          getMessageContentLayout(aText),

          getHebrewMessageCreatedDateTime()
        ],
      ),
    );
  }
  //#endregion

  //#endregion

  //#region Open Message Detail Screen
  openMessageDetailScreen(BuildContext context) async {
    Widget hebrewMessageCreatedTimeLabel = await MessageDetailWidgets.buildMessageCreatedTimeLabel(argMessagePopulatedObject.messageCreatedDateTime);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailPageScreen(
          argMessagePopulatedObject: argMessagePopulatedObject,
          argHebrewMessageCreatedTimeLabel: hebrewMessageCreatedTimeLabel,
        ),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context) {

    //#region Remove Message From List
    Future <void> removeMessageFromList(MessagePopulatedObject aMessagePopulatedObject) async {

      var userGlobal = ConnectedUserGlobal();
      String connectedPersonCardId = userGlobal.getConnectedUserObject().personCardId;

      final messagesBloc = BlocProvider.of<MessagesListBloc>(argParentContext);
      await messagesBloc.removeMessageFromPersonCardMessageQueue(aMessagePopulatedObject, connectedPersonCardId);
    }
    //#endregion

    //#region Undo And Add Message Back To List
    void undoAndAddMessageBackToList(MessagePopulatedObject aMessagePopulatedObject) async {

      var userGlobal = ConnectedUserGlobal();
      String connectedPersonCardId = userGlobal.getConnectedUserObject().personCardId;

      final messagesBloc = BlocProvider.of<MessagesListBloc>(argParentContext);
      await messagesBloc.addMessageBackToPersonCardMessageQueue(aMessagePopulatedObject, connectedPersonCardId);
    }
    //#endregion

    //#region Handle Dismiss
    handleDismiss() async {
      // Get a reference to the swiped item
      final copiedMessagePopulatedObject = MessagePopulatedObject.copy(argMessagePopulatedObject);
      // Remove it from the list
      await removeMessageFromList(argMessagePopulatedObject);

      final scaffold = Scaffold.of(argParentContext);
      scaffold.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('ההודעה של ' +
                      argMessagePopulatedObject.composerFirstName + " " +
                      argMessagePopulatedObject.composerLastName + " נמחקה",
                    style: TextStyle(color: Colors.white, fontSize: 14.0, ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              Row(
                children: [
                  FlatButton(
                    child: Text('אישור',
                      style: TextStyle(color: Colors.blue, fontSize: 14.0),
                    ),
                    onPressed: () {
                      Scaffold.of(argParentContext).hideCurrentSnackBar(reason: SnackBarClosedReason.action);
                    },
                  ),
                  FlatButton(
                    child: Text('ביטול פעולה',
                      style: TextStyle(color: Colors.blue, fontSize: 14.0),
                    ),
                    onPressed: () {
                      // Undo ===>>> Insert Back Message
                      undoAndAddMessageBackToList(copiedMessagePopulatedObject);
                      Scaffold.of(argParentContext).hideCurrentSnackBar(reason: SnackBarClosedReason.action);
                    },
                  ),
                ],
              ),
            ],
          ),
          // action: SnackBarAction(
          //     label: "בטל פעולה",
          //     textColor: Colors.yellow,
          //     onPressed: () {
          //       // Undo ===>>> Insert Back Message
          //       undoAndAddMessageBackToList(copiedMessageWithDescriptionObject);
          //     }),
        ),
      )
          .closed
          .then((reason) {
          if (reason != SnackBarClosedReason.action) {
            // The SnackBar was dismissed by some other means
            // that's not clicking of action button
            // Make API call to backend
          }
        }
      );
    }
    //#endregion

    //#region Open Message Dialog To Confirm Deleting [--->>> Option]
    Future<bool> openMessageDialogToConfirmDeleting() async {

      return await showDialog(
          context: argParentContext,
          builder: (context) {
            return MessageDialogWidget(
              argDialogTitle: Text("האם להסיר את ההודעה ?"),
              argDialogActions: <MessageDialogActionObject>[
                MessageDialogActionObject(title: "אישור", onPressed:(){return Navigator.of(context).pop(true);}),
                MessageDialogActionObject(title: "ביטול פעולה", onPressed:(){return Navigator.of(context).pop(false);})
              ],
            );
          }
      ) ?? false;
    }
    //#endregion

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0, bottom:5.0),
      child: Dismissible(
        key: ObjectKey(argMessagePopulatedObject),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (_) => openMessageDialogToConfirmDeleting(),
        child: GestureDetector(
          child: BubblesBoxDetailMessage(
            argContent: getMessageContent(argMessagePopulatedObject.messageText),
            argContentAlignment: Alignment.centerRight,
            argBubbleBackgroundColor: Colors.white,
            argBubbleBorderColor: Colors.amber,
          ),
          onTap: ()
          {
            FocusScope.of(context).requestFocus(FocusNode());
            openMessageDetailScreen(context);
          },
        ),

        onDismissed: (DismissDirection direction) {
          handleDismiss();
        },

        // background: buildBackgroundListItem(),
        background: BubblesBoxDetailMessage(
          argContent: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Icon(Icons.delete, color: Colors.red, size: 36.0),
              Text(
                "מחיקת הודעה של "
                    "[${argMessagePopulatedObject.composerFirstName} "
                    "${argMessagePopulatedObject.composerLastName}]",
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          argContentAlignment: Alignment.center,
          argBubbleBackgroundColor: Colors.grey[200],
          argBubbleBorderColor: Colors.red,
          displayPin: false,
        ),

        secondaryBackground: Container(
            color: const Color.fromRGBO(0, 96, 100, 0.8),
            child: const ListTile(
                trailing: const Icon(Icons.favorite,
                    color: Colors.white, size: 36.0)
            )
        ),
      ),
    );
  }

  //#region Build Background ListItem [--->>> Option]
  Widget buildBackgroundListItem(Completer<bool> aCompleter) {
    return Container(
      // color: const Color.fromRGBO(183, 28, 28, 0.8),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text('האם למחוק את ההודעה של ' +
                  argMessagePopulatedObject.composerFirstName + " " +
                  argMessagePopulatedObject.composerLastName + " ?",
                style: TextStyle(color: Colors.red, fontSize: 14.0, ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              FlatButton(
                child: Text('מחיקה',
                  style: TextStyle(color: Colors.blue, fontSize: 14.0),
                ),
                onPressed: () {
                  aCompleter.complete(true);
                },
              ),
              FlatButton(
                child: Text('ביטול',
                  style: TextStyle(color: Colors.blue, fontSize: 14.0),
                ),
                onPressed: () {
                  aCompleter.complete(false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  //#endregion
}
