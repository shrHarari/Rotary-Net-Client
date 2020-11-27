import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_edit_page_screen.dart';

class EventSearchResultPageHeaderSearchBox implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  EventsListBloc eventsBloc;
  TextEditingController searchController;

  EventSearchResultPageHeaderSearchBox({
    @required this.minExtent,
    @required this.maxExtent,
    @required this.eventsBloc,
    @required this.searchController,
  });

  //#region Open Event Detail Edit Screen
  openEventDetailEditScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailEditPageScreen(
            argEventPopulatedObject: null,
            argHebrewEventTimeLabel: null
        ),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: Colors.lightBlue[400],
      child: SafeArea(
        child: Stack(
          children: [
            // Positioned(
            //     left: -20.0,
            //     child: Padding(
            //       padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            //       child: buildInsertEventImageButton(context, openEventDetailEditScreen),
            //     )
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, top: 10.0, right: 50.0, bottom: 10.0),
              child: TextField(
                maxLines: 1,
                controller: searchController,
                textAlign: TextAlign.right,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                    fontSize: 14.0,
                    height: 0.8,
                    color: Colors.black
                ),
                onSubmitted: (searchText) async {
                  eventsBloc.getEventsListPopulatedBySearchQuery(searchText);
                  },
                // onChanged: (searchText) {eventsBloc.getEventsListBySearchQuery(searchText);},
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        eventsBloc.getEventsListPopulatedBySearchQuery(searchController.text);
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "מילת חיפוש",
                    fillColor: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Widget buildInsertEventImageButton(BuildContext context, Function aFunc) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () async {
        await aFunc(context);
      },
      color: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(side: BorderSide(color: Colors.blue)),
      child:
      IconTheme(
        data: IconThemeData(
          color: Colors.lightBlue[700],
        ),
        child: Icon(
          Icons.event,
          size: 20,
        ),
      ),
    );
  }

  @override
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration => null;

  @override
  TickerProvider get vsync => null;
}
