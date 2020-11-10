import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_edit_page_screen.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';

class MessageDetailPageScreen extends StatefulWidget {
  static const routeName = '/MessageDetailPageScreen';
  final MessagePopulatedObject argMessagePopulatedObject;
  final Widget argHebrewMessageCreatedTimeLabel;

  MessageDetailPageScreen({Key key, @required this.argMessagePopulatedObject, this.argHebrewMessageCreatedTimeLabel}) : super(key: key);

  @override
  _MessageDetailPageScreenState createState() => _MessageDetailPageScreenState();
}

class _MessageDetailPageScreenState extends State<MessageDetailPageScreen> {

  MessagePopulatedObject displayMessagePopulatedObject;
  Widget hebrewMessageCreatedTimeLabel;

  bool allowUpdate = false;
  String error = '';
  bool loading = false;

  @override
  void initState() {
    displayMessagePopulatedObject = widget.argMessagePopulatedObject;
    hebrewMessageCreatedTimeLabel = widget.argHebrewMessageCreatedTimeLabel;

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
        _allowUpdate = true;
        break;
      case  Constants.UserTypeEnum.Guest:
        _allowUpdate = false;
    }
    return _allowUpdate;
  }
  //#endregion

  //#region Open Message Detail Edit Screen
  openMessageDetailEditScreen(MessagePopulatedObject aMessageObj) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailEditPageScreen(
            argMessagePopulatedObject: displayMessagePopulatedObject,
            argHebrewMessageCreatedTimeLabel: hebrewMessageCreatedTimeLabel
        ),
      ),
    );

    if (result != null) {
      setState(() {
        displayMessagePopulatedObject = result;
      });
    }
  }
  //#endregion

  //#region Display Message Rich Text
  RichText displayMessageContentRichText () {

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: '${displayMessagePopulatedObject.messageText} ',
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

  //#region Open Composer Person Card Detail Screen
  openComposerPersonCardDetailScreen(String aComposerGuidId) async {

    PersonCardService _personCardService = PersonCardService();
    PersonCardObject _personCardObj = await _personCardService.getPersonCardByPersonId(aComposerGuidId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailPageScreen(
            argPersonCardObject: _personCardObj
        ),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      backgroundColor: Colors.blue[50],

      body: buildMainScaffoldBody(),
    );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          /// --------------- Title Area ---------------------
          Container(
            height: 160,
            color: Colors.lightBlue[400],
            child: SafeArea(
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  /// ----------- Header - First line - Application Logo -----------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: MaterialButton(
                              elevation: 0.0,
                              onPressed: () {},
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              child: Icon(
                                Icons.account_balance,
                                size: 30,
                              ),
                              padding: EdgeInsets.all(20),
                              shape: CircleBorder(side: BorderSide(color: Colors.white)),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(Constants.rotaryApplicationName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// --------------- Application Menu ---------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      /// Exit Icon --->>> Close Screen
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.close, color: Colors.white, size: 26.0,),
                            onPressed: () {
                              Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              child: buildMessageDetailDisplay(displayMessagePopulatedObject),
            ),
          ),
        ]
      ),
    );
  }

  /// ====================== Message All Fields ==========================
  Widget buildMessageDetailDisplay(MessagePopulatedObject aMessageObj) {
    return Column(
      children: <Widget>[
        /// ---------------- Message Content ----------------------
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: <Widget>[
                  /// --------------- MessageWithDescriptionObj Details [Metadata]---------------------
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      buildComposerDetailSection(aMessageObj),

                      if (allowUpdate)
                        Positioned(
                          left: 20.0,
                          bottom: -25.0,
                          child: buildEditMessageCircleButton(openMessageDetailEditScreen)
                        ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 0.0),
                    child: displayMessageContentRichText(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //#region Composer Detail Section

  //#region Build Composer Detail Section
  Widget buildComposerDetailSection(MessagePopulatedObject aMessagePopulatedObj) {

    return Container(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),

      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          bottom: BorderSide(
            color: Colors.amber,
            width: 2.0,
          ),
        ),
      ),

      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            if (aMessagePopulatedObj.composerFirstName != "")
              buildComposerDetailName(Icons.person, aMessagePopulatedObj, openComposerPersonCardDetailScreen),

            if (aMessagePopulatedObj.areaName != "")
              buildComposerDetailAreaClusterClub(Icons.location_on, aMessagePopulatedObj, Utils.launchInMapByAddress),
          ],
        ),
      ),
    );
  }
  //#endregion

  //#region Build Composer Detail Name
  Widget buildComposerDetailName(IconData aIcon, MessagePopulatedObject aMessageObj, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              elevation: 0.0,
              onPressed: () {
                aFunc(aMessageObj.composerId);
                },
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.black,
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(5),
              shape: CircleBorder(side: BorderSide(color: Colors.black)),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                aMessageObj.composerFirstName + ' ' + aMessageObj.composerLastName,
                style: TextStyle(color: Colors.grey[900], fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            Text(
              '[${aMessageObj.roleName}]',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region Build Composer Detail Area Cluster Club
  Widget buildComposerDetailAreaClusterClub(IconData aIcon, MessagePopulatedObject aMessageObj, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(aMessageObj.clubAddress);},
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.black,
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(5),
              shape: CircleBorder(side: BorderSide(color: Colors.black)),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'מועדון:',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        '${aMessageObj.clubName}',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'אשכול:',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0),
                      ),
                    ),

                    Text(
                      '${aMessageObj.areaName} / ${aMessageObj.clusterName}',
                      style: TextStyle(color: Colors.grey[900], fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await Utils.sendEmail(aMessageObj.clubMail);
                        },
                        child: Text(
                          '${aMessageObj.clubMail}',
                          style: TextStyle(color: Colors.blue,
                              fontSize: 14.0,
                              decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }
  //#endregion

  //#endregion

  //#region Build Edit Message Circle Button
  Widget buildEditMessageCircleButton(Function aFunc) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () async {
        await aFunc(widget.argMessagePopulatedObject);
      },
      color: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(side: BorderSide(color: Colors.blue)),
      child: IconTheme(
        data: IconThemeData(
          color: Colors.black,
        ),
        child: Icon(
          Icons.edit,
          size: 20,
        ),
      ),
    );
  }
  //#endregion
}