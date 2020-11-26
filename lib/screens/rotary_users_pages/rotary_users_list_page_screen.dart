import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/rotary_users_pages/rotary_users_list_page_header_search_box.dart';
import 'package:rotary_net/screens/rotary_users_pages/rotary_users_list_page_header_title.dart';
import 'package:rotary_net/screens/rotary_users_pages/rotary_users_list_page_tile.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/error_message_screen.dart';

class RotaryUsersListPageScreen extends StatefulWidget {
  static const routeName = '/RotaryUsersListPageScreen';
  final ConnectedUserObject argConnectedUserObject;

  RotaryUsersListPageScreen({Key key, @required this.argConnectedUserObject}) : super(key: key);

  @override
  _RotaryUsersListPageScreenState createState() => _RotaryUsersListPageScreenState();
}

class _RotaryUsersListPageScreenState extends State<RotaryUsersListPageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  String currentSearchText = "";
  setSearchText(String aSearchText) {
    setState(() {
      currentSearchText = aSearchText;
    });
  }

  @override
  Widget build(BuildContext context) {

    final usersBloc = BlocProvider.of<RotaryUsersListBloc>(context);

    return StreamBuilder<List<UserObject>>(
        stream: usersBloc.usersStream,
        initialData: usersBloc.usersList,
        builder: (context, snapshot) {
          List<UserObject> currentUsersList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? usersBloc.usersList
              : snapshot.data;

        return Scaffold(
          key: _scaffoldKey,
          body: Container(
            child: Stack(
              children: [
                /// ----------- Header - Application Logo [Title] & Search Box Area [TextBox] -----------------
                CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: false,
                      floating: false,
                      delegate: RotaryUsersListPageHeaderTitle(
                        minExtent: 140.0,
                        maxExtent: 140.0,
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: RotaryUsersListPageHeaderSearchBox(
                        minExtent: 100.0,
                        maxExtent: 100.0,
                        usersBloc: usersBloc,
                        argSearchTextFunction: setSearchText,
                      ),
                    ),

                    // (snapshot.connectionState == ConnectionState.waiting) ?
                    // SliverFillRemaining(
                    //     child: Loading()
                    // ) :

                    (snapshot.hasError) ?
                    SliverFillRemaining(
                      child: DisplayErrorTextAndRetryButton(
                        errorText: 'שגיאה בשליפה',
                        buttonText: 'נסה שוב',
                        onPressed: () {},
                      ),
                    ) :

                    (snapshot.hasData) ?
                    SliverFixedExtentList(
                      itemExtent: 130.0,
                      delegate: SliverChildBuilderDelegate((context, index)
                        {
                          return RotaryUsersListPageTile(
                            argUserObj: currentUsersList[index],
                            argSearchText: currentSearchText,
                          );
                        },
                        childCount: currentUsersList.length,
                      ),
                    ) :

                    //========================================
                    SliverFillRemaining(
                      child: Center(child: Text('אין תוצאות')),
                    ),
                  ],
                ),

                /// --------------- Application Menu ---------------------
                PageHeaderApplicationMenu(
                  argDisplayTitleLogo: false,
                  argDisplayTitleLabel: false,
                  argTitleLabelText: '',
                  argDisplayApplicationMenu: false,
                  argApplicationMenuFunction: null,
                  argDisplayExit: true,
                  argReturnFunction: null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
