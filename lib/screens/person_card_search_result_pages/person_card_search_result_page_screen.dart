import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/person_cards_list_bloc.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_header_search_box.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_header_title.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_list_tile.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/loading.dart';

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

  //#region Handle Refresh Screen
  Future handleRefreshScreen() async {

    personCardsBloc.getPersonCardsListBySearchQuery(searchController.text);
    return null;
  }
  //#endregion

  //#region Open Menu
  Future<void> openMenu() async {
    // Open Menu from Left side
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

          body: Stack(
            children: <Widget>[
              /// ----------- Header - Application Logo [Title] & Search Box Area [TextBox] -----------------
              RefreshIndicator(
                onRefresh: handleRefreshScreen,
                child: CustomScrollView(
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

                    (snapshot.connectionState == ConnectionState.waiting) ?
                    SliverFillRemaining(
                        child: Loading()
                    ) :

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
                                  argPersonCardObject: currentPersonCardsList[index],
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
