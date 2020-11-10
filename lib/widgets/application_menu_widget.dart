import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_edit_page_screen.dart';
import 'package:rotary_net/screens/menu_pages/about_screen.dart';
import 'package:rotary_net/screens/menu_pages/privacy_policy_screen.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_edit_page_screen.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_page_widgets.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_screen.dart';
import 'package:rotary_net/screens/rotary_users_pages/rotary_users_list_page_screen.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class ApplicationMenuDrawer extends StatefulWidget {

  ApplicationMenuDrawer({Key key}) : super(key: key);

  @override
  _ApplicationMenuDrawerState createState() => _ApplicationMenuDrawerState();
}

class _ApplicationMenuDrawerState extends State<ApplicationMenuDrawer> {

  ConnectedUserObject currentConnectedUserObj;
  bool userHasPermission = false;
  Widget hebrewMessageCreatedTimeLabel;

  @override
  void initState() {
    currentConnectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;
    userHasPermission = getUserPermission();
    super.initState();
  }

  //#region Get User Permission
  bool getUserPermission()  {
    bool _userHasPermission = false;

    switch (currentConnectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _userHasPermission = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        _userHasPermission = false;
        break;
      case  Constants.UserTypeEnum.Guest:
        _userHasPermission = false;
    }
    return _userHasPermission;
  }
  //#endregion

  //#region Open Personal Area Screen
  openPersonalAreaScreen() async {
    // Drawer --> Close the drawer
    Navigator.of(context).pop();

    // Drawer --> Open PersonalAreaScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalAreaScreen(),
      ),
    );
  }
  //#endregion

  //#region Exit From App
  void exitFromApp() async {
    /// Update SecureStorage [Remove StayConnected]
    final ConnectedUserService connectedUserService = ConnectedUserService();
    await connectedUserService.exitFromApplicationUpdateSecureStorage();

    exit(0);
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
//    final height = MediaQuery.of(context).size.height;
    return Drawer(
      elevation: 10.0,
      child:
        Column(
          children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
//              height: height * .28,
              child: DrawerHeader(
                child:
                Column(
                  children: <Widget>[
                    buildPersonalAreaIcon(),
                    buildUserWelcomeTitle(),          // שלום אורח
                    buildPersonalAreaTitle(context),  // לאיזור האישי
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.dvr),
                  title: Text('אודות'),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutScreen(),
                      ),
                    )
                  },
                ),
                ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text('מדיניות הפרטיות'),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen(),
                      ),
                    )
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('תנאי שימוש'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('הגדרות'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                Divider(),

                if (userHasPermission)
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text('הוספת אירוע'),
                    onTap:  () =>
                    {
                      Navigator.of(context).pop(),

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EventDetailEditPageScreen(
                                  argEventObject: null,
                                  argHebrewEventTimeLabel: null)
                        ),
                      ),
                    },
                  ),

                if (userHasPermission)
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text('הוספת הודעה'),
                    onTap: () async =>
                    {
                      Navigator.of(context).pop(),

                      hebrewMessageCreatedTimeLabel = await MessageDetailWidgets.buildMessageCreatedTimeLabel(DateTime.now()),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MessageDetailEditPageScreen(
                                  argMessagePopulatedObject: null,
                                  argHebrewMessageCreatedTimeLabel: hebrewMessageCreatedTimeLabel
                                )
                        ),
                      ),
                    },
                  ),

                if (userHasPermission) Divider(),

                if (userHasPermission)
                  ListTile(
                    leading: Icon(Icons.verified_user),
                    title: Text('ניהול משתמשים'),
                    onTap: () => {
                      Navigator.of(context).pop(),

                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          RotaryUsersListPageScreen(argConnectedUserObject: currentConnectedUserObj)
                        ),
                      ),
                    },
                  ),
                if (userHasPermission) Divider(),

                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('יציאה'),
                  onTap: () => {
                    exitFromApp()
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //#region Build Personal Area Icon
  Widget buildPersonalAreaIcon ()
  {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: MaterialButton(
        onPressed: () {},
        color: Colors.lightBlue,
        textColor: Colors.white,
        child: Icon(
          Icons.person_outline,
          size: 30,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      ),
    );
  }
  //#endregion

  //#region Build User Welcome Title
  Widget buildUserWelcomeTitle ()
  {
    String userTitle = 'אורח';
    if (currentConnectedUserObj != null && currentConnectedUserObj.firstName != '') {
      userTitle = '${currentConnectedUserObj.firstName} ${currentConnectedUserObj.lastName}';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RichText(
        text: new TextSpan(
            text: 'שלום ',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
            ),
//            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
            TextSpan(
              text: userTitle,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }
  //#endregion

  //#region Build Personal Area Title
  Widget buildPersonalAreaTitle (BuildContext context)
  {
    return InkWell(
      onTap: () {openPersonalAreaScreen();},
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          'לאיזור האישי',
          style: TextStyle(color: Colors.blue, fontSize: 14),
        ),
      ),
    );
  }
  //#endregion
}
