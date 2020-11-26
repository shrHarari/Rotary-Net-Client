import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_header.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_tab_person_card.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_tab_user.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class PersonalAreaScreen extends StatefulWidget {
  static const routeName = '/PersonalAreaScreen';

  PersonalAreaScreen({Key key}) : super(key: key);

  @override
  _PersonalAreaScreenState createState() => _PersonalAreaScreenState();
}

class _PersonalAreaScreenState extends State<PersonalAreaScreen> {
  ConnectedUserObject currentConnectedUserObj;

  final PersonCardService personCardService = PersonCardService();
  Future<PersonCardObject> personCardForBuild;
  PersonCardObject currentPersonCard;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loading = false;
  bool allowDisplayPersonCard = false;

  @override
  void initState() {
    currentConnectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;
    personCardForBuild = getPersonalCardFromServer(currentConnectedUserObj.personCardId);
    allowDisplayPersonCard = getPersonCardPermission();

    super.initState();
  }

  //#region Get PersonCard Permission
  bool getPersonCardPermission()  {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;
    bool _allowDisplayPersonCard = false;

    switch (_connectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _allowDisplayPersonCard = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        _allowDisplayPersonCard = true;
        break;
      case  Constants.UserTypeEnum.Guest:
        _allowDisplayPersonCard = false;
    }
    return _allowDisplayPersonCard;
  }
  //endregion

  //#region Get PersonalCard From Server
  Future<PersonCardObject> getPersonalCardFromServer(String aPersonCardId) async {
    dynamic personCardsObj = await personCardService.getPersonCardByPersonId(aPersonCardId);
    return personCardsObj;
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PersonCardObject>(
      future: personCardForBuild,
      builder: (context, snapshot) {
        if (snapshot.hasData) currentPersonCard = snapshot.data;

        var radius = Radius.circular(5);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.blue[50],

          drawer: Container(
            width: 250,
            child: Drawer(
              child: ApplicationMenuDrawer(),
            ),
          ),

          body: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// --------------- Page Header Application Menu ---------------------
                PersonalAreaPageHeader(),

                (snapshot.connectionState == ConnectionState.waiting) ?
                  Container(child: Loading()) :

                (snapshot.hasError) ?
                  Container(
                    child: DisplayErrorText(
                      errorText: 'כרטיס ביקור חסר',
                    ),
                  ) :

                (snapshot.hasData) || (currentConnectedUserObj != null) ?
                Expanded(
                  child: DefaultTabController(
                      length: (allowDisplayPersonCard) ? 2 : 1,
                      initialIndex: (allowDisplayPersonCard) ? 1 : 0,
                      child: Scaffold(
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(25),
                          child: Container(
                            color: Colors.lightBlue[400],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TabBar(
                                  indicatorColor: Colors.white,
                                  labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),   //For Selected tab
                                  unselectedLabelStyle: TextStyle(fontSize: 14.0),                      //For Un-selected Tabs
                                  tabs: <Widget>[
                                    if (allowDisplayPersonCard) Tab(text :"כרטיס ביקור"),
                                    Tab(text :"פרטי משתמש"),
                                  ],
                                  indicator: ShapeDecoration(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: radius, topLeft: radius)),
                                      color: Colors.lightBlue[700]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        body: TabBarView(
                          children: [
                            /// --------------- TAB: PersonCard ---------------------
                            if (allowDisplayPersonCard)
                              PersonalAreaPageTabPersonCard(
                                argPersonCardObject: currentPersonCard,
                                argConnectedUserObject: currentConnectedUserObj
                            ),

                            /// --------------- TAB: User ---------------------
                            PersonalAreaPageTabUser(argConnectedUser: currentConnectedUserObj),
                          ],
                        ),
                      ),
                    ),
                ) :

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                    width: double.infinity,
                    child: Center(child: Text('אין תוצאות')),
                  ),
                ),
              ]
            ),
          ),
        );
      }
    );
  }
}

