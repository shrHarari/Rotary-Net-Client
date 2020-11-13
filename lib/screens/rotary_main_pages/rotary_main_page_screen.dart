import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/messages_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_screen.dart';
import 'package:rotary_net/screens/message_detail_pages/rotary_main_page_message_list_tile.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_screen.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_action_image_icons.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_header_search_box.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_header_title.dart';
import 'package:rotary_net/screens/settings/application_setting_screen.dart';
import 'package:rotary_net/shared/constants.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class RotaryMainPageScreen extends StatefulWidget {
  static const routeName = '/RotaryMainPage';

  @override
  _RotaryMainPageScreenState createState() => _RotaryMainPageScreenState();
}

class _RotaryMainPageScreenState extends State<RotaryMainPageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool userHasPermission = false;
  bool loading = false;

  SearchTypeEnum currentSearchType = SearchTypeEnum.PersonCard;
  Color personCardBackgroundColor = Colors.amberAccent;
  Color eventsBackgroundColor = Colors.white;

  TextEditingController searchController = new TextEditingController();

  MessagesListBloc messagesBloc;
  List<MessagePopulatedObject> currentMessagesList;

  @override
  void initState() {

    messagesBloc = BlocProvider.of<MessagesListBloc>(context);
    messagesBloc.getMessagesListPopulated();

    //#region Lock Screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //#endregion

    userHasPermission = getUserPermission();
    super.initState();
  }

  @override
  dispose(){
    //#region UnLock Screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //#endregion
    super.dispose();
  }

  //#region Handle Refresh Screen
  Future handleRefreshScreen() async {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;

    messagesBloc.setPersonCardId(_connectedUserObj.personCardId);
    messagesBloc.getMessagesListPopulated();
    return null;
  }
  //#endregion

  //#region Get User Permission
  bool getUserPermission()  {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;

    bool _userHasPermission = false;

    switch (_connectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _userHasPermission = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        _userHasPermission = true;
        break;
      case  Constants.UserTypeEnum.Guest:
        _userHasPermission = false;
    }
    return _userHasPermission;
  }
  //#endregion

  //#region Open Application Settings
  Future<void> openApplicationSettings() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationSettingsScreen(),
      ),
    );
  }
  //#endregion

  //#region Open Person Cards Search Result Screen
  Future<void> openPersonCardsSearchResultScreen(String aValueToSearch) async {
    /// Navigate to PersonCardsSearchResultScreen Screen
    if (searchController.text != "") {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PersonCardSearchResultPage(
                  searchText: aValueToSearch
              ),
        ),
      );

      if (result == null) {
        setState(() {
          searchController.text = '';
        });
      } else {
        setState(() {
          searchController.text = result;
        });
      }
    }
  }
  //#endregion

  //#region Open Events Search Result Screen
  Future<void> openEventsSearchResultScreen(String aValueToSearch) async {
    /// Navigate to EventsSearchResultScreen Screen
    if (searchController.text != "") {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EventSearchResultPage(
                  searchText: aValueToSearch
              ),
        ),
      );

      if (result == null) {
        setState(() {
          searchController.text = '';
        });
      } else {
        setState(() {
          searchController.text = result;
        });
      }
    }
  }
  //#endregion

  //#region Execute Search By Type
  Future<void> executeSearchByType(String aValueToSearch, SearchTypeEnum aSearchType) async {
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      currentSearchType = aSearchType;
    });

    switch (currentSearchType) {
      case SearchTypeEnum.PersonCard:
        setState(() {
          personCardBackgroundColor = Colors.amberAccent;
          eventsBackgroundColor = Colors.white;
        });

        if (searchController.text != "")
        {
          openPersonCardsSearchResultScreen(aValueToSearch);
        }
        break;

      case SearchTypeEnum.Event:
        setState(() {
          personCardBackgroundColor = Colors.white;
          eventsBackgroundColor = Colors.amberAccent;
        });

        if (searchController.text != "")
        {
          openEventsSearchResultScreen(aValueToSearch);
        }
        break;
    }
  }
  //#endregion

  //#region Open Menu
  Future<void> openMenu() async {
    // Open Menu from Left side
    FocusScope.of(context).requestFocus(FocusNode()); // Hide Keyboard
    _scaffoldKey.currentState.openDrawer();
  }
  //# endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    StreamBuilder<List<MessagePopulatedObject>>(
      stream: messagesBloc.messagesPopulatedStream,
      initialData: messagesBloc.messagesListPopulated,
      builder: (context, snapshot) {
        currentMessagesList =
        (snapshot.connectionState == ConnectionState.waiting)
            ? messagesBloc.messagesListPopulated
            : snapshot.data;

      return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,

          drawer: Container(
            width: 250,
            child: Drawer(
              child: ApplicationMenuDrawer(),
            ),
          ),

          body:
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background/main_screen.jpg"),
                    fit: BoxFit.cover
                )
            ),
            child:
            Column(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          /// ----------- Header - Application Logo [Title] -----------------
                          RotaryMainPageHeaderTitle(),
                          /// ----------- Header - Search Box Area [TextBox] -----------------
                          RotaryMainPageHeaderSearchBox(
                            searchController: searchController,
                            argExecuteSearchFunc: executeSearchByType
                          ),
                          /// ----------- Body - Action Image Icons -----------------
                          RotaryMainPageActionImageIcons(
                            searchController: searchController,
                            argExecuteSearchFunc: executeSearchByType,
                            argPersonCardBackgroundColor: personCardBackgroundColor,
                            argEventsBackgroundColor: eventsBackgroundColor,
                          )
                        ],
                      ),
                      /// ----------- Header - Application Menu -----------------
                      buildApplicationMenuRow(),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: handleRefreshScreen,
                    child: Container(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          /// ----------- Body - Error Message -----------------
                          (snapshot.hasError) ?
                          SliverFillRemaining(
                            child: DisplayErrorTextAndRetryButton(
                              errorText: 'שגיאה בשליפת כרטיסי הביקור',
                              buttonText: 'נסה שוב',
                              onPressed: () {},
                            ),
                          ) :

                          /// ----------- Body - Messages List -----------------
                          (snapshot.hasData) ?
                          Container(
                            child: SliverFixedExtentList(
                              itemExtent: 220.0,
                              delegate: SliverChildBuilderDelegate((context, index) {
                                  return RotaryMainPageMessageListTile(
                                    argMessagePopulatedObject: currentMessagesList[index],
                                  );
                                },
                                childCount: currentMessagesList.length,
                              ),
                            ),
                          ) :

                          SliverFillRemaining(
                            child: Center(
                                child: Text('קראת את כל הודעותיך, רענן מסך...')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      }
    );
  }
  
  //#region Build Application Menu Row
  Widget buildApplicationMenuRow() {
    /// ----------- Header - Application Menu -----------------
    return SafeArea(
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
              icon: Icon(Icons.build, color: Colors.white),
              onPressed: () async {
                await openApplicationSettings();
                },
            ),
          ),
        ],
      ),
    );
  }
  //# endregion
}

