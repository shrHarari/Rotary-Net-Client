import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/event_populated_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_screen.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_widgets.dart';
import 'package:rotary_net/shared/action_button_decoration.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/message_dialog_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class EventSearchResultPageListTile extends StatefulWidget {
  static const routeName = '/EventSearchResultPageListTile';
  final EventPopulatedObject argEventPopulatedObject;

  EventSearchResultPageListTile({Key key, @required this.argEventPopulatedObject}) : super(key: key);

  @override
  _EventSearchResultPageListTileState createState() => _EventSearchResultPageListTileState();
}

class _EventSearchResultPageListTileState extends State<EventSearchResultPageListTile> {

  AssetImage eventImageDefaultAsset;
  EventPopulatedObject displayEventPopulatedObject;
  bool allowDeleteEvent = false;
  bool loading = true;

  @override
  void initState() {
    eventImageDefaultAsset = AssetImage('${Constants.rotaryEventImageDefaultFolder}/EventImageDefaultPicture.jpg');

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => executeAfterBuildComplete(context));
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   WidgetsBinding.instance.addPostFrameCallback((_) => executeAfterBuildComplete(context));
  // }

  executeAfterBuildComplete(BuildContext context){
    setState(() {
      loading = false;
    });
  }

  //#region Get Delete Event Permission
  bool getDeleteEventPermission()  {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;
    bool _allowDeleteEvent = false;

    switch (_connectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _allowDeleteEvent = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        /// Check if the ConnectedUser is the Event Composer
        if ((displayEventPopulatedObject.eventComposerId != null) && (displayEventPopulatedObject.eventComposerId == _connectedUserObj.personCardId))
          _allowDeleteEvent = true;
        break;

      case  Constants.UserTypeEnum.Guest:
        _allowDeleteEvent = false;
    }
    return _allowDeleteEvent;
  }
  //#endregion

  //#region Open Event Detail Screen
  openEventDetailScreen(BuildContext context) async {
    Widget hebrewEventTimeLabel = await EventDetailWidgets.buildEventDateTimeLabel(
        displayEventPopulatedObject.eventStartDateTime,
        displayEventPopulatedObject.eventEndDateTime);

    final returnEventDataMap = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPageScreen(
          argEventPopulatedObject: widget.argEventPopulatedObject,
          argHebrewEventTimeLabel: hebrewEventTimeLabel,
        ),
      ),
    );

    if (returnEventDataMap != null) {
      setState(() {
        displayEventPopulatedObject = returnEventDataMap["EventPopulatedObject"];
        hebrewEventTimeLabel = returnEventDataMap["HebrewEventTimeLabel"];
      });
    }
  }
  //#endregion

  //#region Remove Message From List
  Future <void> removeEventFromList(EventPopulatedObject aEventPopulatedObject) async {

    setState(() {
      loading = true;
    });

    final eventsBloc = BlocProvider.of<EventsListBloc>(context);
    await eventsBloc.deleteEventByEventId(aEventPopulatedObject);

    setState(() {
      loading = false;
    });
  }
  //#endregion

  //#region Open Message Dialog To Confirm Deleting [--->>> Option]
  Future<bool> openMessageDialogToConfirmDeleting() async {

    return await showDialog(
        context: context,
        builder: (context) {
          return MessageDialogWidget(
            argDialogTitle: Text("האם להסיר את האירוע ${displayEventPopulatedObject.eventName} ?"),
            argDialogActions: <MessageDialogActionObject>[
              MessageDialogActionObject(title: "אישור", onPressed:(){return Navigator.of(context).pop(true);}),
              MessageDialogActionObject(title: "ביטול פעולה", onPressed:(){return Navigator.of(context).pop(false);})
            ],
          );
        }
    ) ?? false;
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    displayEventPopulatedObject = widget.argEventPopulatedObject;
    allowDeleteEvent = getDeleteEventPermission();

    return loading ? EventImageTileLoading()
      : Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 5.0),
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  image: DecorationImage(
                      image: (displayEventPopulatedObject.eventPictureUrl == null) || (displayEventPopulatedObject.eventPictureUrl == '')
                          ? eventImageDefaultAsset
                          : NetworkImage(displayEventPopulatedObject.eventPictureUrl),
                      fit: BoxFit.cover
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                decoration:BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.grey[600].withOpacity(0.4), Colors.transparent.withOpacity(0.0)]
                    )
                ),
              ),

              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top:15.0, right: 20.0, left: 20.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              displayEventPopulatedObject.eventName,
                              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            displayEventPopulatedObject.eventLocation,
                            style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (allowDeleteEvent)
                Positioned(
                    bottom: 10.0,
                    child: buildDeleteEventButton(context)
                ),
            ],
          ),
          onTap: ()
          {
            // Hide Keyboard
            FocusScope.of(context).requestFocus(FocusNode());
            openEventDetailScreen(context);
          },
        ),
      );
  }

  //#region Build Delete Event Button
  Widget buildDeleteEventButton(BuildContext context) {
    // final bloc = BlocProvider.of<EventsListBloc>(context);
    // return StreamBuilder<List<EventPopulatedObject>>(
    //   stream: bloc.eventsPopulatedStream,
    //   initialData: bloc.eventsListPopulated,
    //   builder: (context, snapshot) {
        // List<EventPopulatedObject> currentUsersList =
        // (snapshot.connectionState == ConnectionState.waiting)
        //     ? bloc.eventsListPopulated
        //     : snapshot.data;

      return ActionButtonDecoration(
            argButtonType: ButtonType.Circle,
            argHeight: null,
            argButtonText: '',
            argIcon: Icons.delete,
            argIconSize: 20.0,
            onPressed: () async {
              bool returnVal = await openMessageDialogToConfirmDeleting();
              if (returnVal) await removeEventFromList(displayEventPopulatedObject);
              // await bloc.deleteEventByEventId(displayEventPopulatedObject);
            });
    //   },
    // );
  }
  //#endregion
}
