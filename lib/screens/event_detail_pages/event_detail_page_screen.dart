import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/event_populated_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_edit_page_screen.dart';
import 'package:rotary_net/screens/event_detail_pages/event_composer_detail_section.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/action_button_decoration.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class EventDetailPageScreen extends StatefulWidget {
  static const routeName = '/EventDetailPageScreen';
  final EventPopulatedObject argEventPopulatedObject;
  final Widget argHebrewEventTimeLabel;

  EventDetailPageScreen({Key key, @required this.argEventPopulatedObject, @required this.argHebrewEventTimeLabel}) : super(key: key);

  @override
  _EventDetailPageScreenState createState() => _EventDetailPageScreenState();
}

class _EventDetailPageScreenState extends State<EventDetailPageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  EventPopulatedObject displayEventPopulatedObject;
  Widget hebrewEventTimeLabel;
  AssetImage eventImageDefaultAsset;

  bool allowUpdate = false;
  String error = '';
  bool loading = false;

  @override
  void initState() {
    displayEventPopulatedObject = widget.argEventPopulatedObject;
    hebrewEventTimeLabel = widget.argHebrewEventTimeLabel;
    eventImageDefaultAsset = AssetImage('${Constants.rotaryEventImageDefaultFolder}/EventImageDefaultPicture.jpg');

    allowUpdate = getUpdatePermission();

    super.initState();
  }

  //#region Get Update Permission
  bool getUpdatePermission()  {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;
    bool _allowUpdate = false;

    switch (_connectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _allowUpdate = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        /// Check if the ConnectedUser is the Event Composer
        if ((displayEventPopulatedObject.eventComposerId != null) && (displayEventPopulatedObject.eventComposerId == _connectedUserObj.personCardId))
          _allowUpdate = true;
        break;
      case  Constants.UserTypeEnum.Guest:
        _allowUpdate = false;
    }
    return _allowUpdate;
  }
  //#endregion

  //#region Open Menu
  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }
  //#endregion

  //#region Open Event Detail Edit Screen
  openEventDetailEditScreen(EventPopulatedObject aEventPopulatedObj) async {
    final returnEventDataMap = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailEditPageScreen(
            argEventPopulatedObject: displayEventPopulatedObject,
            argHebrewEventTimeLabel: hebrewEventTimeLabel
        ),
      ),
    );

    if (returnEventDataMap != null) {
      EventPopulatedObject _eventPopulatedObject = returnEventDataMap["EventPopulatedObject"];
      Widget _hebrewEventTimeLabel = returnEventDataMap["HebrewEventTimeLabel"];

      setState(() {
        displayEventPopulatedObject = _eventPopulatedObject;
        if (_hebrewEventTimeLabel != null) hebrewEventTimeLabel = _hebrewEventTimeLabel;

      });
    }
  }
  //#endregion

  //#region Exit And Navigate Back
  Future<void> exitAndNavigateBack() async {
    /// Return multiple data using MAP
    final returnEventDataMap = {
      "EventPopulatedObject": displayEventPopulatedObject,
      "HebrewEventTimeLabel": hebrewEventTimeLabel,
    };
    Navigator.pop(context, returnEventDataMap);
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
      Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blue[50],

        drawer: Container(
          width: 250,
          child: Drawer(
            child: ApplicationMenuDrawer(),
          ),
        ),

        body: buildMainScaffoldBody(),
      );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      width: double.infinity,
      child: Column(
          children: [
            /// --------------- Page Header Application Menu ---------------------
            Container(
              height: 160,
              color: Colors.lightBlue[400],
              child: PageHeaderApplicationMenu(
                argDisplayTitleLogo: true,
                argDisplayTitleLabel: false,
                argTitleLabelText: '',
                argDisplayApplicationMenu: true,
                argApplicationMenuFunction: openMenu,
                argDisplayExit: false,
                argReturnFunction: exitAndNavigateBack,
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                child: buildEventDetailDisplay(displayEventPopulatedObject),
              ),
            ),
          ]
      ),
    );
  }

  /// ====================== Event All Fields ==========================
  Widget buildEventDetailDisplay(EventPopulatedObject aEventPopulatedObj) {

    return Column(
      children: <Widget>[
        /// ------------------- Event Image -------------------------
        Container(
          height: 200.0,
          width: double.infinity,
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: (aEventPopulatedObj.eventPictureUrl == null) || (aEventPopulatedObj.eventPictureUrl == '')
                    ? eventImageDefaultAsset
                    : NetworkImage(aEventPopulatedObj.eventPictureUrl),
                fit: BoxFit.cover
            ),
          ),
        ),

        /// ---------------------- Event Name -------------------------
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 30.0, bottom: 20.0),
          child:
          Row(
            textDirection: TextDirection.rtl,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Text(
                  aEventPopulatedObj.eventName,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),

              if (allowUpdate)
                Expanded(
                    flex: 2,
                    child: buildEditEventButton(openEventDetailEditScreen, aEventPopulatedObj)
                ),
            ],
          ),
        ),

        /// --------------------- Event Content -------------------------
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: <Widget>[

                  /// ------------------ Event Description ---------------------
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 20.0),
                      child: displayEventDescriptionRichText(),
                    ),
                  ),

                  /// -------------- Event Details (Icon Images) ---------------
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          if (aEventPopulatedObj.eventLocation != "") buildDetailImageIcon(Icons.location_on, aEventPopulatedObj.eventLocation, Utils.launchInMapByAddress),
                          if (aEventPopulatedObj.eventManager != "") buildDetailImageIcon(Icons.person, aEventPopulatedObj.eventManager, Utils.sendEmail),
                          if (aEventPopulatedObj.eventStartDateTime != null) buildEventDetailImageIcon(Icons.event_available, aEventPopulatedObj, Utils.addEventToCalendar),
                        ],
                      ),
                    ),
                  ),

                  /// -------------- Composer Detail Section -------------------
                  buildComposerDetailSection(aEventPopulatedObj),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //#region Display Event Description Rich Text
  RichText displayEventDescriptionRichText () {

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: '${displayEventPopulatedObject.eventDescription} ',
            style: TextStyle(
                fontFamily: 'Heebo-Light',
                fontSize: 20.0,
                height: 1.5,
                color: Colors.black87
            ),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Build Detail Image Icon
  Widget buildDetailImageIcon(IconData aIcon, String aTitle, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(aTitle);},
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                    color: Colors.blue[500],
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  aTitle,
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 14.0),
                ),
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region Build Event Detail Image Icon
  Widget buildEventDetailImageIcon(IconData aIcon, EventPopulatedObject aEventPopulatedObj, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              elevation: 0.0,
              onPressed: () {
                aFunc(
                    aEventPopulatedObj.eventName, aEventPopulatedObj.eventDescription, aEventPopulatedObj.eventLocation,
                    aEventPopulatedObj.eventStartDateTime, aEventPopulatedObj.eventEndDateTime);
              },
              color: Colors.blue[10],
              child: IconTheme(
                  data: IconThemeData(
                    color: Colors.blue[500],
                  ),
                  child: Icon(
                    aIcon,
                    size: 20,
                  ),
                ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: hebrewEventTimeLabel,
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region Build Composer Detail Section
  Widget buildComposerDetailSection(EventPopulatedObject aEventPopulatedObj) {

    PersonCardRoleAndHierarchyIdPopulatedObject hierarchyPopulatedObject =
      PersonCardRoleAndHierarchyIdPopulatedObject.createPersonCardRoleAndHierarchyIdAsPopulatedObject(
          aEventPopulatedObj.eventComposerId,
          aEventPopulatedObj.composerFirstName,
          aEventPopulatedObj.composerLastName,
          aEventPopulatedObj.areaId,
          aEventPopulatedObj.areaName,
          aEventPopulatedObj.clusterId,
          aEventPopulatedObj.clusterName,
          aEventPopulatedObj.clubId,
          aEventPopulatedObj.clubName,
          aEventPopulatedObj.clubAddress,
          aEventPopulatedObj.clubMail,
          aEventPopulatedObj.roleId,
          aEventPopulatedObj.roleName);

    return EventComposerDetailSection(
      argHierarchyPopulatedObject: hierarchyPopulatedObject);
  }
  //#endregion

  //#region Build Edit Event Button
  Widget buildEditEventButton(Function aFunc, EventPopulatedObject aEventPopulatedObj) {
    return ActionButtonDecoration(
        argButtonType: ButtonType.Circle,
        argHeight: null,
        argButtonText: '',
        argIcon: Icons.edit,
        argIconSize: 20.0,
        onPressed: () async {
          await aFunc(aEventPopulatedObj);
        });
  }
  //#endregion
}