import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_edit_page_screen.dart';
import 'package:rotary_net/screens/message_detail_pages/message_composer_detail_section.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/action_button_decoration.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

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
        /// Check if the ConnectedUser is the Message Composer
        if ((displayMessagePopulatedObject.composerId != null) && (displayMessagePopulatedObject.composerId == _connectedUserObj.personCardId))
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
            child: PageHeaderApplicationMenu(
              argDisplayTitleLogo: true,
              argDisplayTitleLabel: false,
              argTitleLabelText: '',
              argDisplayApplicationMenu: false,
              argApplicationMenuFunction: null,
              argDisplayExit: true,
              argReturnFunction: null,
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

  //#region Build Composer Detail Section
  Widget buildComposerDetailSection(MessagePopulatedObject aMessagePopulatedObj) {

    PersonCardRoleAndHierarchyIdPopulatedObject hierarchyPopulatedObject =
        PersonCardRoleAndHierarchyIdPopulatedObject.createPersonCardRoleAndHierarchyIdAsPopulatedObject(
          aMessagePopulatedObj.composerId,
          aMessagePopulatedObj.composerFirstName,
          aMessagePopulatedObj.composerLastName,
          aMessagePopulatedObj.areaId,
          aMessagePopulatedObj.areaName,
          aMessagePopulatedObj.clusterId,
          aMessagePopulatedObj.clusterName,
          aMessagePopulatedObj.clubId,
          aMessagePopulatedObj.clubName,
          aMessagePopulatedObj.clubAddress,
          aMessagePopulatedObj.clubMail,
          aMessagePopulatedObj.roleId,
          aMessagePopulatedObj.roleName);

    return MessageComposerDetailSection(
      argHierarchyPopulatedObject: hierarchyPopulatedObject);
  }
  //#endregion

  //#region Build Edit Message Circle Button
  Widget buildEditMessageCircleButton(Function aFunc) {
    return ActionButtonDecoration(
        argButtonType: ButtonType.Circle,
        argHeight: null,
        argButtonText: '',
        argIcon: Icons.edit,
        argIconSize: 20.0,
        onPressed: () async {
          await aFunc(widget.argMessagePopulatedObject);
        });
  }
  //#endregion
}