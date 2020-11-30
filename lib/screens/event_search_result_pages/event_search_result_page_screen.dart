import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/objects/event_populated_object.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_header_search_box.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_header_title.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_list_tile.dart';
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/loading.dart';

class EventSearchResultPage extends StatefulWidget {
  static const routeName = '/EventSearchResultPage';
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
    eventsBloc.getEventsListPopulatedBySearchQuery(searchController.text);
  }

  //#region Handle Refresh Screen
  Future handleRefreshScreen() async {

    eventsBloc.getEventsListPopulatedBySearchQuery(searchController.text);
    return null;
  }
  //#endregion

  //#region Open Menu
  Future<void> openMenu() async {
    _scaffoldKey.currentState.openDrawer();
  }
  //#endregion

  //#region Exit And Navigate Back
  Future<void> exitAndNavigateBack() async {
    Navigator.pop(context, searchController.text);
  }
  //#endregion

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<EventPopulatedObject>>(
      stream: eventsBloc.eventsPopulatedStream,
      initialData: eventsBloc.eventsListPopulated,
      builder: (context, snapshot) {
        List<EventPopulatedObject> currentEventsList =
            (snapshot.connectionState == ConnectionState.waiting)
                ? eventsBloc.eventsListPopulated
                : snapshot.data;

        return Scaffold(
          key: _scaffoldKey,
          drawer: Container(
            width: 250,
            child: Drawer(
              child: ApplicationMenuDrawer(),
            ),
          ),

          body: Stack(
            children: [
              /// ----------- Header - Application Logo [Title] & Search Box Area [TextBox] -----------------
              RefreshIndicator(
                onRefresh: handleRefreshScreen,
                child: CustomScrollView(
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

                    (snapshot.connectionState == ConnectionState.waiting) ?
                    SliverFillRemaining(
                        child: Loading()
                    ) :

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
                      delegate: SliverChildBuilderDelegate((context, index) {
                          return EventSearchResultPageListTile(
                            argEventPopulatedObject: currentEventsList[index],
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
              ),

              /// --------------- Page Header Application Menu ---------------------
              PageHeaderApplicationMenu(
                argDisplayTitleLogo: false,
                argDisplayTitleLabel: false,
                argTitleLabelText: '',
                argDisplayApplicationMenu: true,
                argApplicationMenuFunction: openMenu,
                argDisplayExit: false,
                argReturnFunction: exitAndNavigateBack,
              ),
            ],
          ),
        );
      },
    );
  }
}
