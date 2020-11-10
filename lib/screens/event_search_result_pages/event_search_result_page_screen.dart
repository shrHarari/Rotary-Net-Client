import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_list_tile.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_header_search_box.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_header_title.dart';
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';

class EventSearchResultPage extends StatefulWidget {
  static const routeName = '/PersonCardSearchResultPage';
  final String searchText;

  EventSearchResultPage({Key key, @required this.searchText}) : super(key: key);

  @override
  _EventSearchResultPageState createState() => _EventSearchResultPageState();
}

class _EventSearchResultPageState extends State<EventSearchResultPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  final EventService eventService = EventService();
  EventsListBloc eventsBloc;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.searchText);

    eventsBloc = BlocProvider.of<EventsListBloc>(context);
    eventsBloc.getEventsListBySearchQuery(searchController.text);
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<EventObject>>(
      stream: eventsBloc.eventsStream,
      initialData: eventsBloc.eventsList,
      builder: (context, snapshot) {
        List<EventObject> currentEventsList =
        (snapshot.connectionState == ConnectionState.waiting)
            ? eventsBloc.eventsList
            : snapshot.data;

        return Scaffold(
          key: _scaffoldKey,
          drawer: Container(
            width: 250,
            child: Drawer(
              child: ApplicationMenuDrawer(),
            ),
          ),

          body: Container(
            child: Stack(
              children: [
                /// ----------- Header - Application Logo [Title] & Search Box Area [TextBox] -----------------
                CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: false,
                      floating: false,
                      delegate: EventSearchResultPageHeaderTitle(
                        minExtent: 140.0,
                        maxExtent: 140.0,
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: EventSearchResultPageHeaderSearchBox(
                        minExtent: 100.0,
                        maxExtent: 100.0,
                        eventsBloc: eventsBloc,
                        searchController: searchController,
                      ),
                    ),

                    // (snapshot.connectionState == ConnectionState.waiting) ?
                    // SliverFillRemaining(
                    //     child: Loading()
                    // ) :

                    (snapshot.hasError) ?
                    SliverFillRemaining(
                      child: DisplayErrorTextAndRetryButton(
                        errorText: 'שגיאה בשליפת אירועים',
                        buttonText: 'נסה שוב',
                        onPressed: () {},
                      ),
                    ) :

                    (snapshot.hasData) ?
                    SliverFixedExtentList(
                      itemExtent: 200.0,
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return EventSearchResultPageListTile(
                            argEventObj: currentEventsList[index],
                          );
                        },
                        childCount: currentEventsList.length,
                      ),
                    ) :
                    //========================================
                    SliverFillRemaining(
                      child: Center(child: Text('אין תוצאות')),
                    ),
                  ],
                ),

                /// --------------- Application Menu ---------------------
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// Menu Icon --->>> Open Drawer Menu
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
                        child: IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () async {await openMenu();},
                        ),
                      ),

                      /// Back Icon --->>> Back to previous screen
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward, color: Colors.white),
                          onPressed: () {Navigator.pop(context, searchController.text);},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
