import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/person_cards_list_bloc.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_list_tile.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_header_search_box.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_header_title.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';

class PersonCardSearchResultPage extends StatefulWidget {
  static const routeName = '/PersonCardSearchResultPage';
  final String searchText;

  PersonCardSearchResultPage({Key key, @required this.searchText}) : super(key: key);

  @override
  _PersonCardSearchResultPageState createState() => _PersonCardSearchResultPageState();
}

class _PersonCardSearchResultPageState extends State<PersonCardSearchResultPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  final PersonCardService personCardService = PersonCardService();

  PersonCardsListBloc personCardsBloc;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.searchText);

    personCardsBloc = BlocProvider.of<PersonCardsListBloc>(context);
    personCardsBloc.getPersonCardsListBySearchQuery(searchController.text);
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<PersonCardObject>>(
      stream: personCardsBloc.personCardsStream,
      initialData: personCardsBloc.personCardsList,
      builder: (context, snapshot) {
        List<PersonCardObject> currentPersonCardsList =
        (snapshot.connectionState == ConnectionState.waiting)
            ? personCardsBloc.personCardsList
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
              children: <Widget>[
                /// ----------- Header - Application Logo [Title] & Search Box Area [TextBox] -----------------
                CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: false,
                      floating: false,
                      delegate: PersonCardSearchResultPageHeaderTitle(
                        minExtent: 140.0,
                        maxExtent: 140.0,
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: PersonCardSearchResultPageHeaderSearchBox(
                        minExtent: 100.0,
                        maxExtent: 100.0,
                        personCardsBloc: personCardsBloc,
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
                          errorText: 'שגיאה בשליפת כרטיסי הביקור',
                          buttonText: 'נסה שוב',
                          onPressed: () {},
                        ),
                      ) :

                      (snapshot.hasData) ?
                        SliverFixedExtentList(
                            itemExtent: 130.0,
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return PersonCardSearchResultPageListTile(
                                  argPersonCardObj: currentPersonCardsList[index],
                                );
                              },
                            childCount: currentPersonCardsList.length,
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
