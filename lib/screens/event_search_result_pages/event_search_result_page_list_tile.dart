import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_screen.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_widgets.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/shared/loading.dart';

class EventSearchResultPageListTile extends StatefulWidget {
  static const routeName = '/EventSearchResultPageListTile';
  final EventObject argEventObject;

  EventSearchResultPageListTile({Key key, @required this.argEventObject}) : super(key: key);

  @override
  _EventSearchResultPageListTileState createState() => _EventSearchResultPageListTileState();
}

class _EventSearchResultPageListTileState extends State<EventSearchResultPageListTile> {

  AssetImage eventImageDefaultAsset;
  EventObject displayEventObject;
  bool loading = true;

  @override
  void initState() {
    displayEventObject = widget.argEventObject;
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

  //#region Open Event Detail Screen
  openEventDetailScreen(BuildContext context) async {
    Widget hebrewEventTimeLabel = await EventDetailWidgets.buildEventDateTimeLabel(displayEventObject.eventStartDateTime, displayEventObject.eventEndDateTime);

    final returnEventDataMap = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPageScreen(
          argEventObject: widget.argEventObject,
          argHebrewEventTimeLabel: hebrewEventTimeLabel,
        ),
      ),
    );

    if (returnEventDataMap != null) {
      setState(() {
        displayEventObject = returnEventDataMap["EventObject"];
        hebrewEventTimeLabel = returnEventDataMap["HebrewEventTimeLabel"];
      });
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
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
                      image: (displayEventObject.eventPictureUrl == null) || (displayEventObject.eventPictureUrl == '')
                          ? eventImageDefaultAsset
                          : NetworkImage(displayEventObject.eventPictureUrl),
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
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top:15.0, right: 20.0, left: 20.0),
                        child: Column(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                displayEventObject.eventName,
                                style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                displayEventObject.eventLocation,
                                style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 10.0,
                  child: _buildDeleteEventButton(context)
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
  Widget _buildDeleteEventButton(BuildContext context) {
    final bloc = BlocProvider.of<EventsListBloc>(context);
    return StreamBuilder<List<EventObject>>(
      stream: bloc.eventsStream,
      initialData: bloc.eventsList,
      builder: (context, snapshot) {
        List<EventObject> currentUsersList =
        (snapshot.connectionState == ConnectionState.waiting)
            ? bloc.eventsList
            : snapshot.data;

        return MaterialButton(
          onPressed: () async {
            await bloc.deleteEventByEventId(displayEventObject);
          },
          color: Colors.white,
          shape: CircleBorder(side: BorderSide(color: Colors.blue)),
          child:
          IconTheme(
            data: IconThemeData(
              color: Colors.black,
            ),
            child: Icon(
              Icons.delete,
              size: 20,
            ),
          ),
        );
      },
    );
  }
  //#endregion
}
