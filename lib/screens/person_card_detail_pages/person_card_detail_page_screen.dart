import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_edit_page_screen.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/rotary_club_service.dart';
import 'package:rotary_net/services/rotary_cluster_service.dart';
import 'package:rotary_net/services/rotary_role_service.dart';
import 'package:rotary_net/shared/bubble_box_person_card.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/person_card_image_avatar.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/action_button_decoration.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';

class PersonCardDetailPageScreen extends StatefulWidget {
  static const routeName = '/PersonCardDetailPageScreen';
  final PersonCardObject argPersonCardObject;

  PersonCardDetailPageScreen({Key key, @required this.argPersonCardObject}) : super(key: key);

  @override
  _PersonCardDetailPageScreenState createState() => _PersonCardDetailPageScreenState();
}

class _PersonCardDetailPageScreenState extends State<PersonCardDetailPageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  Future<PersonCardRoleAndHierarchyObject> personCardRoleAndHierarchyObjectForBuild;
  PersonCardRoleAndHierarchyObject displayPersonCardRoleAndHierarchyObject;
  PersonCardObject displayPersonCardObject;
  RichText displayPersonCardHierarchyTitle;

  bool allowUpdate = false;
  String error = '';
  bool loading = false;

  @override
  void initState() {
    displayPersonCardObject = widget.argPersonCardObject;
    allowUpdate = getUpdatePermission();

    personCardRoleAndHierarchyObjectForBuild = getPersonCardRoleAndHierarchyForBuild();

    super.initState();
  }

  //#region Get PersonCard Role And Hierarchy For Build
  Future<PersonCardRoleAndHierarchyObject> getPersonCardRoleAndHierarchyForBuild() async {
    setState(() {
      loading = true;
    });

    RotaryRoleService _rotaryRoleService = RotaryRoleService();
    RotaryRoleObject _rotaryRoleObj = await _rotaryRoleService.getRotaryRoleByRoleId(displayPersonCardObject.roleId);

    RotaryAreaService _rotaryAreaService = RotaryAreaService();
    RotaryAreaObject _rotaryAreaObj = await _rotaryAreaService.getRotaryAreaByAreaId(displayPersonCardObject.areaId);

    RotaryClusterService _rotaryClusterService = RotaryClusterService();
    RotaryClusterObject _rotaryClusterObj = await _rotaryClusterService.getRotaryClusterByClusterId(displayPersonCardObject.clusterId);

    RotaryClubService _rotaryClubService = RotaryClubService();
    RotaryClubObject _rotaryClubObj = await _rotaryClubService.getRotaryClubByClubId(displayPersonCardObject.clubId);

    displayPersonCardHierarchyTitle = PersonCardRoleAndHierarchyObject.getPersonCardHierarchyTitleRichText(
              _rotaryRoleObj.roleName, _rotaryAreaObj.areaName, _rotaryClusterObj.clusterName, _rotaryClubObj.clubName);

    setState(() {
      loading = false;
    });

    return PersonCardRoleAndHierarchyObject(
        rotaryRoleObject: _rotaryRoleObj,
        rotaryAreaObject: _rotaryAreaObj,
        rotaryClusterObject: _rotaryClusterObj,
        rotaryClubObject: _rotaryClubObj,
    );
  }
  //#endregion

  //#region Get Update Permission
  bool getUpdatePermission()  {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;
    bool _allowUpdate = false;

    switch (_connectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _allowUpdate = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        /// Check if the ConnectedUser is the PersonCard Owner Composer
        if ((displayPersonCardObject.personCardId != null) && (displayPersonCardObject.personCardId == _connectedUserObj.personCardId))
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

  //#region Exit And Navigate Back
  Future<void> exitAndNavigateBack() async {
    /// Return multiple data using MAP
    final returnEventDataMap = {
      "PersonCardObject": displayPersonCardObject,
    };
    Navigator.pop(context, returnEventDataMap);
  }
  //#endregion

  //#region Open Person Card Detail Edit Screen
  openPersonCardDetailEditScreen(PersonCardObject aPersonCardObj) async {
    final returnPersonCardDataMap = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailEditPageScreen(
            argPersonCardObject: displayPersonCardObject
        ),
      ),
    );

    if (returnPersonCardDataMap != null) {
      PersonCardObject _personCardObject = returnPersonCardDataMap["PersonCardObject"];
      RichText _personCardHierarchyTitle = returnPersonCardDataMap["PersonCardHierarchyTitle"];

      setState(() {
        displayPersonCardObject = _personCardObject;
        if (_personCardHierarchyTitle != null) displayPersonCardHierarchyTitle = _personCardHierarchyTitle;
      });
    }
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

        body: FutureBuilder<PersonCardRoleAndHierarchyObject>(
          future: personCardRoleAndHierarchyObjectForBuild,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Loading();
            else
            if (snapshot.hasError) {
              return RotaryErrorMessageScreen(
                errTitle: 'שגיאה בשליפת נתונים',
                errMsg: 'אנא פנה למנהל המערכת',
              );
            } else {
              if (snapshot.hasData)
              {
                displayPersonCardRoleAndHierarchyObject = snapshot.data;
                  return buildMainScaffoldBody();
              }
              else
                return Center(child: Text('אין תוצאות'));
            }
          }
        ),
    );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
                // padding: EdgeInsets.symmetric(horizontal: 30.0),
                width: double.infinity,
                child: buildPersonCardDetailDisplay(displayPersonCardObject),
                ),
          ),
        ]
      ),
    );
  }

  /// ====================== Person Card All Fields ==========================
  Widget buildPersonCardDetailDisplay(PersonCardObject aPersonCardObj) {

    return Column(
      children: <Widget>[
        /// ------------------- Image + Card Name -------------------------
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0, bottom: 20.0),
          child: Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[
              PersonCardImageAvatar(
                argPersonCardPictureUrl: displayPersonCardObject.pictureUrl,
                argIcon: Icons.person
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          aPersonCardObj.firstName + " " + aPersonCardObj.lastName,
                          style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        aPersonCardObj.firstNameEng + " " + aPersonCardObj.lastNameEng,
                        style: TextStyle(color: Colors.grey[900], fontSize: 16.0, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              if (allowUpdate)
                buildEditPersonCardButton(openPersonCardDetailEditScreen, aPersonCardObj),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 30.0, bottom: 0.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: <Widget>[
                displayPersonCardHierarchyTitle,
              ]
            ),
          ),
        ),

        /// --------------------- Card Description -------------------------
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.only(left: 30.0, top: 20.0, right: 30.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: BubblesBoxPersonCard(
                      argText: aPersonCardObj.cardDescription,
                      argBubbleBackgroundColor: Colors.white,
                      argBubbleBackgroundColorDark: Colors.blue[100],
                      argBubbleBorderColor: Colors.blue[400],
                      isWithShadow: true,
                      isWithGradient: true,
                      displayPin: false,
                    ),
                  ),

                  /// ---------------- Card Details (Icon Images) --------------------
                  if (aPersonCardObj.email != "") buildDetailImageIcon(Icons.mail_outline, aPersonCardObj.email, Utils.sendEmail),
                  if (aPersonCardObj.phoneNumber != "") buildDetailImageIcon(Icons.phone, aPersonCardObj.phoneNumber, Utils.makePhoneCall),
                  if (aPersonCardObj.phoneNumber != "") buildDetailImageIcon(Icons.sms, aPersonCardObj.phoneNumber, Utils.sendSms),
                  if (aPersonCardObj.address != "") buildDetailImageIcon(Icons.home, aPersonCardObj.address, Utils.launchInMapByAddress),
                  if (aPersonCardObj.address != "") buildDetailImageIcon(Icons.home, aPersonCardObj.address, Utils.launchInMapByCoordinates),
                  if (aPersonCardObj.internetSiteUrl != "") buildDetailImageIcon(Icons.alternate_email, aPersonCardObj.internetSiteUrl, Utils.launchInBrowser),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //#region Build Detail Image Icon
  Row buildDetailImageIcon(IconData aIcon, String aTitle, Function aFunc) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(aTitle);},
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                    color: Colors.blue[500]
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            ),
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
    );
  }
  //#endregion

  //#region Build Edit PersonCard Button
  Widget buildEditPersonCardButton(Function aFunc, PersonCardObject aPersonCardObj) {
    return ActionButtonDecoration(
        argButtonType: ButtonType.Circle,
        argHeight: null,
        argButtonText: '',
        argIcon: Icons.edit,
        argIconSize: 20.0,
        onPressed: () async {
          await aFunc(aPersonCardObj);
        });
  }
  //#endregion
}
