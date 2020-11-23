import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/person_cards_list_bloc.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/services/aws_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/rotary_club_service.dart';
import 'package:rotary_net/services/rotary_cluster_service.dart';
import 'package:rotary_net/services/rotary_role_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/person_card_image_avatar.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:path/path.dart' as Path;

class PersonCardDetailEditPageScreen extends StatefulWidget {
  static const routeName = '/PersonCardDetailEditPageScreen';
  final PersonCardObject argPersonCardObject;

  PersonCardDetailEditPageScreen({Key key, @required this.argPersonCardObject}) : super(key: key);

  @override
  _PersonCardDetailEditPageScreenState createState() => _PersonCardDetailEditPageScreenState();
}

class _PersonCardDetailEditPageScreenState extends State<PersonCardDetailEditPageScreen> {

  final formKey = GlobalKey<FormState>();
  final PersonCardService personCardService = PersonCardService();

  //#region Declare Variables
  String currentPersonCardImage;
  Future<PersonCardRoleAndHierarchyListObject> personCardRoleAndHierarchyListObjectForBuild;
  PersonCardRoleAndHierarchyListObject displayPersonCardRoleAndHierarchyListObject;

  TextEditingController eMailController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController firstNameEngController;
  TextEditingController lastNameEngController;
  TextEditingController phoneNumberController;
  TextEditingController phoneNumberDialCodeController;
  TextEditingController phoneNumberParseController;
  TextEditingController phoneNumberCleanLongFormatController;
  TextEditingController cardDescriptionController;
  TextEditingController internetSiteUrlController;
  TextEditingController addressController;

  String error = '';
  bool loading = false;
  //#endregion

  @override
  void initState() {
    setPersonCardVariables(widget.argPersonCardObject);

    personCardRoleAndHierarchyListObjectForBuild = getPersonCardRoleAndHierarchyListForBuild();

    super.initState();
  }

  //#region Set PersonCard Variables
  Future<void> setPersonCardVariables(PersonCardObject aPersonCard) async {
    currentPersonCardImage = aPersonCard.pictureUrl;

    eMailController = TextEditingController(text: aPersonCard.email);
    firstNameController = TextEditingController(text: aPersonCard.firstName);
    lastNameController = TextEditingController(text: aPersonCard.lastName);
    firstNameEngController = TextEditingController(text: aPersonCard.firstNameEng);
    lastNameEngController = TextEditingController(text: aPersonCard.lastNameEng);
    phoneNumberController = TextEditingController(text: aPersonCard.phoneNumber);
    phoneNumberDialCodeController = TextEditingController(text: aPersonCard.phoneNumberDialCode);
    phoneNumberParseController = TextEditingController(text: aPersonCard.phoneNumberParse);
    phoneNumberCleanLongFormatController = TextEditingController(text: aPersonCard.phoneNumberCleanLongFormat);
    cardDescriptionController = TextEditingController(text: aPersonCard.cardDescription);
    internetSiteUrlController = TextEditingController(text: aPersonCard.internetSiteUrl);
    addressController = TextEditingController(text: aPersonCard.address);
  }
  //#endregion

  //#region Get PersonCard Role And Hierarchy List For Build
  Future<PersonCardRoleAndHierarchyListObject> getPersonCardRoleAndHierarchyListForBuild() async {
    setState(() {
      loading = true;
    });

    RotaryRoleService _rotaryRoleService = RotaryRoleService();
    List<RotaryRoleObject> _rotaryRoleObjList = await _rotaryRoleService.getAllRotaryRolesList();
    setRotaryRoleDropdownMenuItems(_rotaryRoleObjList);

    //////////////////////////////// Rotary Area
    RotaryAreaService _rotaryAreaService = RotaryAreaService();
    List<RotaryAreaObject> _rotaryAreaObjList = await _rotaryAreaService.getAllRotaryAreaList();
    setRotaryAreaDropdownMenuItems(_rotaryAreaObjList);

    /// Find the AreaObject Element in a AreaList By areaId ===>>> Get Clusters List
    /// Get ClustersList from current Area [widget.argPersonCardObject.areaId]
    int _initialAreaListIndex;
    List<String> clustersOfArea;
    if ((widget.argPersonCardObject != null) && (widget.argPersonCardObject.areaId != null)) {
      _initialAreaListIndex = _rotaryAreaObjList.indexWhere((listElement) =>
      (listElement.areaId == widget.argPersonCardObject.areaId));
      clustersOfArea = _rotaryAreaObjList[_initialAreaListIndex].clusters;
    }

    //////////////////////////////// Rotary Cluster
    RotaryClusterService _rotaryClusterService = RotaryClusterService();
    List<RotaryClusterObject> _rotaryClusterObjList = await _rotaryClusterService.getAllRotaryClusterList();
    setRotaryClusterDropdownMenuItems(clustersOfArea, _rotaryClusterObjList);

    /// Find the ClusterObject Element in a ClusterList By clusterId ===>>> Get Clubs List
    /// Get ClubsList from current Cluster [widget.argPersonCardObject.clusterId]
    int _initialClustersListIndex;
    List<String> clubsOfCluster;
    if ((widget.argPersonCardObject != null) && (widget.argPersonCardObject.clusterId != null)) {
      _initialClustersListIndex = _rotaryClusterObjList.indexWhere((listElement) =>
      (listElement.clusterId == widget.argPersonCardObject.clusterId));

      clubsOfCluster = _rotaryClusterObjList[_initialClustersListIndex].clubs;
    }

    //////////////////////////////// Rotary Club
    RotaryClubService _rotaryClubService = RotaryClubService();
    List<RotaryClubObject> _rotaryClubObjList = await _rotaryClubService.getAllRotaryClubList();
    setRotaryClubDropdownMenuItems(clubsOfCluster, _rotaryClubObjList);

    setState(() {
      loading = false;
    });

    return PersonCardRoleAndHierarchyListObject(
      rotaryRoleObjectList: _rotaryRoleObjList,
      rotaryAreaObjectList: _rotaryAreaObjList,
      rotaryClusterObjectList: _rotaryClusterObjList,
      rotaryClubObjectList: _rotaryClubObjList,
    );
  }
  //#endregion

  //#region All DropDown UI Objects

  //#region RotaryRole DropDown
  List<DropdownMenuItem<RotaryRoleObject>> dropdownRotaryRoleItems;
  RotaryRoleObject selectedRotaryRoleObj;

  void setRotaryRoleDropdownMenuItems(List<RotaryRoleObject> aRotaryRoleObjectsList) {
    List<DropdownMenuItem<RotaryRoleObject>> _rotaryRoleDropDownItems = List();
    for (RotaryRoleObject _rotaryRoleObj in aRotaryRoleObjectsList) {
      _rotaryRoleDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryRoleObj.roleName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryRoleObj,
        ),
      );
    }
    dropdownRotaryRoleItems = _rotaryRoleDropDownItems;

    // Find the RoleObject Element in a RoleList By roleId ===>>> Set DropDown Initial Value
    int _initialListIndex;
    if ((widget.argPersonCardObject != null) && (widget.argPersonCardObject.roleId != null)) {
      _initialListIndex = aRotaryRoleObjectsList.indexWhere((listElement) =>  listElement.roleId == widget.argPersonCardObject.roleId);
      selectedRotaryRoleObj = dropdownRotaryRoleItems[_initialListIndex].value;
    } else {
      _initialListIndex = null;
      selectedRotaryRoleObj = null;
    }
  }

  onChangeDropdownRotaryRoleItem(RotaryRoleObject aSelectedRotaryRoleObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryRoleObj = aSelectedRotaryRoleObject;
    });
  }
  //#endregion

  //#region RotaryArea DropDown
  List<DropdownMenuItem<RotaryAreaObject>> dropdownRotaryAreaItems;
  RotaryAreaObject selectedRotaryAreaObj;

  void setRotaryAreaDropdownMenuItems(List<RotaryAreaObject> aRotaryAreaObjectsList) {
    List<DropdownMenuItem<RotaryAreaObject>> _rotaryAreaDropDownItems = List();
    for (RotaryAreaObject _rotaryAreaObj in aRotaryAreaObjectsList) {
      _rotaryAreaDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryAreaObj.areaName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryAreaObj,
        ),
      );
    }
    dropdownRotaryAreaItems = _rotaryAreaDropDownItems;

    if ((widget.argPersonCardObject != null) && (widget.argPersonCardObject.areaId != null))
      filterRotaryAreaDropdownMenuItems(widget.argPersonCardObject.areaId);
    else
      filterRotaryAreaDropdownMenuItems(null);
    }

    void filterRotaryAreaDropdownMenuItems(String aAreaId) {
      // Filter list & Find the ClusterObject Element in a ClusterList By clusterId ===>>> Set DropDown Initial Value
      int _initialListIndex;

      // Find the AreaObject Element in a RoleList By areaId ===>>> Set DropDown Initial Value
      if ((widget.argPersonCardObject != null) && (aAreaId != null)) {
        _initialListIndex = dropdownRotaryAreaItems.indexWhere((listElement) =>
              (listElement.value.areaId == aAreaId));

        selectedRotaryAreaObj = dropdownRotaryAreaItems[_initialListIndex].value;
      } else {
        _initialListIndex = null;
        selectedRotaryAreaObj = null;
      }
  }

  onChangeDropdownRotaryAreaItem(RotaryAreaObject aSelectedRotaryAreaObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryAreaObj = aSelectedRotaryAreaObject;
      filterRotaryClusterDropdownMenuItems(aSelectedRotaryAreaObject.clusters, null);
      filterRotaryClubDropdownMenuItems(null, null);
    });
  }
  //#endregion

  //#region RotaryCluster DropDown
  List<DropdownMenuItem<RotaryClusterObject>> dropdownRotaryClusterItems;
  List<DropdownMenuItem<RotaryClusterObject>> dropdownRotaryClusterFilteredItems;
  RotaryClusterObject selectedRotaryClusterObj;

  void setRotaryClusterDropdownMenuItems(List<String> aClustersOfArea, List<RotaryClusterObject> aRotaryClusterObjectsList) {
    List<DropdownMenuItem<RotaryClusterObject>> _rotaryClusterDropDownItems = List();
    for (RotaryClusterObject _rotaryClusterObj in aRotaryClusterObjectsList) {
      _rotaryClusterDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryClusterObj.clusterName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryClusterObj,
        ),
      );
    }
    dropdownRotaryClusterItems = _rotaryClusterDropDownItems;

    if ((widget.argPersonCardObject != null) && (widget.argPersonCardObject.clusterId != null))
      filterRotaryClusterDropdownMenuItems(aClustersOfArea, widget.argPersonCardObject.clusterId);
    else
      filterRotaryClusterDropdownMenuItems(aClustersOfArea, null);
  }

  void filterRotaryClusterDropdownMenuItems(List<String> aClustersOfArea, String aClusterId) {
    // Filter list & Find the ClusterObject Element in a ClusterList By clusterId ===>>> Set DropDown Initial Value
    int _initialListIndex;

    if (aClustersOfArea != null)
      dropdownRotaryClusterFilteredItems = dropdownRotaryClusterItems.where((item) =>
          aClustersOfArea.contains(item.value.clusterId)).toList();

    if (aClusterId != null) {
      _initialListIndex = dropdownRotaryClusterFilteredItems.indexWhere((listElement) =>
          (listElement.value.clusterId == aClusterId));
      selectedRotaryClusterObj = dropdownRotaryClusterFilteredItems[_initialListIndex].value;
    } else {
      _initialListIndex = null;
      selectedRotaryClusterObj = null;
    }
  }

  onChangeDropdownRotaryClusterItem(RotaryClusterObject aSelectedRotaryClusterObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryClusterObj = aSelectedRotaryClusterObject;
      filterRotaryClubDropdownMenuItems(aSelectedRotaryClusterObject.clubs, null);
    });
  }
  //#endregion

  //#region RotaryClub DropDown
  List<DropdownMenuItem<RotaryClubObject>> dropdownRotaryClubItems;
  List<DropdownMenuItem<RotaryClubObject>> dropdownRotaryClubFilteredItems;
  RotaryClubObject selectedRotaryClubObj;

  void setRotaryClubDropdownMenuItems(List<String> aClubsOfCluster, List<RotaryClubObject> aRotaryClubObjectsList) {
    List<DropdownMenuItem<RotaryClubObject>> _rotaryClubDropDownItems = List();
    for (RotaryClubObject _rotaryClubObj in aRotaryClubObjectsList) {
      _rotaryClubDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryClubObj.clubName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryClubObj,
        ),
      );
    }
    dropdownRotaryClubItems = _rotaryClubDropDownItems;

    if ((widget.argPersonCardObject != null) && (widget.argPersonCardObject.clubId != null))
      filterRotaryClubDropdownMenuItems(aClubsOfCluster, widget.argPersonCardObject.clubId);
    else
      filterRotaryClubDropdownMenuItems(aClubsOfCluster, null);
  }

  void filterRotaryClubDropdownMenuItems(List<String> aClubsOfCluster, String aClubId) {
    // Filter list & Find the ClubObject Element in a ClubList By clubId ===>>> Set DropDown Initial Value
    int _initialListIndex;

    if (aClubsOfCluster != null) {
      dropdownRotaryClubFilteredItems = dropdownRotaryClubItems.where((item) =>
          aClubsOfCluster.contains(item.value.clubId)).toList();

      if ((widget.argPersonCardObject != null) && (aClubId != null)) {
        _initialListIndex = dropdownRotaryClubFilteredItems.indexWhere((listElement) =>
            (listElement.value.clubId == aClubId));
        selectedRotaryClubObj = dropdownRotaryClubFilteredItems[_initialListIndex].value;
      } else {
        _initialListIndex = null;
        selectedRotaryClubObj = null;
      }
    } else {
      _initialListIndex = null;
      dropdownRotaryClubFilteredItems = [];
      selectedRotaryClubObj = null;
    }
  }

  onChangeDropdownRotaryClubItem(RotaryClubObject aSelectedRotaryClubObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryClubObj = aSelectedRotaryClubObject;
    });
  }
  //#endregion

  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = false;

    if (formKey.currentState.validate()){
      validationVal = true;
    }
    return validationVal;
  }
  //#endregion

  //#region Update PersonCard
  Future updatePersonCard(PersonCardsListBloc aPersonCardBloc) async {

    setState(() {
      loading = true;
    });

    bool validationVal = await checkValidation();

    if (validationVal){

      String _email = (eMailController.text != null) ? (eMailController.text) : '';
      String _firstName = (firstNameController.text != null) ? (firstNameController.text) : '';
      String _lastName = (lastNameController.text != null) ? (lastNameController.text) : '';
      String _firstNameEng = (firstNameEngController.text != null) ? (firstNameEngController.text) : '';
      String _lastNameEng = (lastNameEngController.text != null) ? (lastNameEngController.text) : '';
      String _phoneNumber = (phoneNumberController.text != null) ? (phoneNumberController.text) : '';
      String _phoneNumberDialCode = (phoneNumberDialCodeController.text != null) ? (phoneNumberDialCodeController.text) : '';
      String _phoneNumberParse = (phoneNumberParseController.text != null) ? (phoneNumberParseController.text) : '';
      String _phoneNumberCleanLongFormat = (phoneNumberCleanLongFormatController.text != null) ? (phoneNumberCleanLongFormatController.text) : '';
      String _cardDescription = (cardDescriptionController.text != null) ? (cardDescriptionController.text) : '';
      String _internetSiteUrl = (internetSiteUrlController.text != null) ? (internetSiteUrlController.text) : '';
      String _address = (addressController.text != null) ? (addressController.text) : '';

      String _pictureUrl = '';
      if (currentPersonCardImage != null) _pictureUrl = currentPersonCardImage;

      /// No Insert (Exist) ! Only Update(has PersonCardId)
      PersonCardObject _newPersonCardObj = personCardService.createPersonCardAsObject(
          widget.argPersonCardObject.personCardId,
          _email, _firstName, _lastName, _firstNameEng, _lastNameEng,
          _phoneNumber, _phoneNumberDialCode, _phoneNumberParse, _phoneNumberCleanLongFormat,
          _pictureUrl, _cardDescription, _internetSiteUrl, _address,
          selectedRotaryAreaObj.areaId, selectedRotaryClusterObj.clusterId, selectedRotaryClubObj.clubId,
          selectedRotaryRoleObj.roleId,
          widget.argPersonCardObject.messages);

      RichText _personCardHierarchyTitle = PersonCardRoleAndHierarchyObject.getPersonCardHierarchyTitleRichText(
          selectedRotaryRoleObj.roleName, selectedRotaryAreaObj.areaName,
          selectedRotaryClusterObj.clusterName, selectedRotaryClubObj.clubName);

      await aPersonCardBloc.updatePersonCardById(widget.argPersonCardObject, _newPersonCardObj);

      /// Return multiple data using MAP
      Map<String, dynamic> returnPersonCardDataMap = {
        "PersonCardObject": _newPersonCardObj,
        "PersonCardHierarchyTitle": _personCardHierarchyTitle
      };
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context, returnPersonCardDataMap);
    }
    setState(() {
      loading = false;
    });
  }
  //#endregion

  //#region Return To PersonCard Page
  Future returnToPersonCardPage() async {
    String _pictureUrl = '';
    if (currentPersonCardImage != null) _pictureUrl = currentPersonCardImage;

    PersonCardObject _newPersonCardObj = widget.argPersonCardObject;
    _newPersonCardObj.setPictureUrl(_pictureUrl);

    /// Return multiple data using MAP
    final returnPersonCardDataMap = {
      "PersonCardObject": _newPersonCardObj,
      "PersonCardHierarchyTitle": null
    };
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context, returnPersonCardDataMap);
  }
  //#endregion

  //#region Pick Image File
  Future <void> pickImageFile() async {

    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedPickedFile = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 800
    );

    setState(() {
      loading = true;
    });

    String originalImageFileName;

    if (compressedPickedFile != null)
    {
      /// If currentPersonCardImage Exists on Client --->>> Delete Original file
      String personCardImagesDirectory = await Utils.createDirectoryInAppDocDir(Constants.rotaryPersonCardImagesFolderName);
      if ((currentPersonCardImage != null) && (currentPersonCardImage != ''))
      {
        File originalImageFile = File(currentPersonCardImage);
        originalImageFileName = Path.basename(originalImageFile.path);

        String localFilePath = '$personCardImagesDirectory/$originalImageFileName';
        File localImageFile = File(localFilePath);
        localImageFile.delete();
      }

      // copy the New CompressedPickedFile to a new path --->>> On Client
      File pickedPictureFile = File(compressedPickedFile.path);
      String copyImageFileName = '${widget.argPersonCardObject.personCardId}_${DateTime.now()}.jpg';
      String copyFilePath = '$personCardImagesDirectory/$copyImageFileName';

      await pickedPictureFile.copy(copyFilePath).then((File newImageFile) async {
        if (newImageFile != null) {

          /// START Uploading
          Map<String, dynamic> uploadReturnVal;

          String fileType = Path.extension(compressedPickedFile.path);      /// <<<---- [.JPG]

          uploadReturnVal = await AwsService.awsUploadImageToServer(
              widget.argPersonCardObject.personCardId,
              compressedPickedFile, copyImageFileName, fileType,
              originalImageFileName, aBucketFolderName: Constants.rotaryPersonCardImagesFolderName);

          if ((uploadReturnVal != null) && (uploadReturnVal["returnCode"] == 200)) {
            setState(() {
              currentPersonCardImage = uploadReturnVal["imageUrl"];
            });
          }
        }
      });
    }

    setState(() {
      loading = false;
    });
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      backgroundColor: Colors.blue[50],

      drawer: Container(
        width: 250,
        child: Drawer(
          child: ApplicationMenuDrawer(),
        ),
      ),

      body: FutureBuilder<PersonCardRoleAndHierarchyListObject>(
          future: personCardRoleAndHierarchyListObjectForBuild,
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
                displayPersonCardRoleAndHierarchyListObject = snapshot.data;
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
      // width: double.infinity,
      child: Column(
          children: <Widget>[
            /// --------------- Title Area ---------------------
            Container(
              height: 180,
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
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              returnToPersonCardPage();
                            },
                          ),
                        ),
                      ],
                    ),

                    // Positioned(
                    //   left: 20.0,
                    //   bottom: -25.0,
                    //   child: buildUpdateCircleButton(updatePersonCard),
                    // ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: buildPersonCardDetailDisplay(),
            ),
          ]
      ),
    );
  }

  /// ====================== Event All Fields ==========================
  Widget buildPersonCardDetailDisplay() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    /// ------------------- Input Text Fields ----------------------
                    PersonCardImageAvatar(
                      argPersonCardPictureUrl: currentPersonCardImage,
                      argIcon: Icons.person_add,
                      argOnTapFunction: pickImageFile,
                    ),

                    buildEnabledDoubleTextInputWithImageIcon(
                        firstNameController, 'שם פרטי',
                        lastNameController, 'שם משפחה',
                        Icons.person, aValidation: true),
                    buildEnabledDoubleTextInputWithImageIcon(
                        firstNameEngController, 'שם פרטי באנגלית',
                        lastNameEngController, 'שם משפחה באנגלית',
                        Icons.person_outline, aValidation: true),
                    buildEnabledTextInputWithImageIcon(eMailController, 'דוא"ל', Icons.mail_outline, aValidation: true),
                    buildEnabledTextInputWithImageIcon(addressController, 'כתובת', Icons.home),
                    buildEnabledTextInputWithImageIcon(phoneNumberController, 'מספר טלפון', Icons.phone, aValidation: true),
                    buildEnabledTextInputWithImageIcon(cardDescriptionController, 'תיאור כרטיס ביקור', Icons.description, aMultiLine: true),
                    buildEnabledTextInputWithImageIcon(internetSiteUrlController, 'כתובת אתר אינטרנט', Icons.alternate_email),

                    buildDropDownRoleAndHierarchy(),
                  ],
                ),
              ),
            ),
          ),
        ),

        buildUpdateButtonRectangleWithIcon("עדכן", updatePersonCard, Icons.update),

        /// ---------------------- Display Error -----------------------
        Text(
          error,
          style: TextStyle(
              color: Colors.red,
              fontSize: 14.0),
        ),
      ],
    );
  }

  //#region INPUT FIELDS

  //#region buildEnabledTextInputWithImageIcon
  Widget buildEnabledTextInputWithImageIcon(
            TextEditingController aController, String textInputName,
            IconData aIcon, {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: buildImageIconForTextField(aIcon),
            ),

            Expanded(
              flex: 12,
              child:
              Container(
                child: buildTextFormField(aController, textInputName,
                            aMultiLine: aMultiLine, aEnabled: aEnabled, aValidation: aValidation),
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region buildEnabledDoubleTextInputWithImageIcon
  Widget buildEnabledDoubleTextInputWithImageIcon(
      TextEditingController aController1, String textInputName1,
      TextEditingController aController2, String textInputName2,
      IconData aIcon, {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: buildImageIconForTextField(aIcon),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: buildTextFormField(aController1, textInputName1,
                              aMultiLine: aMultiLine, aEnabled: aEnabled, aValidation: aValidation),
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: buildTextFormField(aController2, textInputName2,
                              aMultiLine: aMultiLine, aEnabled: aEnabled, aValidation: aValidation),
                ),
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region buildImageIconForTextField
  MaterialButton buildImageIconForTextField(IconData aIcon) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () {},
      color: Colors.blue[10],
      textColor: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(
          side: BorderSide(color: Colors.blue)
      ),
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
    );
  }
  //#endregion

  //region buildTextFormField
  TextFormField buildTextFormField(
      TextEditingController aController,
      String textInputName,
      {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return TextFormField(
      keyboardType: aMultiLine ? TextInputType.multiline : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: aEnabled
          ? TextInputDecoration.copyWith(
                hintText: textInputName,
                hintStyle: TextStyle(fontSize: 14.0)
            )
          : DisabledTextInputDecoration.copyWith(
                hintText: textInputName,
                hintStyle: TextStyle(fontSize: 14.0)
            ), // Disabled Field
      validator: aValidation
        ? ((val) => val.isEmpty ? 'הקלד $textInputName' : null)
        : null
    );
  }
  //#endregion

  //#endregion

  //#region DROP DOWN Section

  //#region buildDropDownRoleAndHierarchy
  Widget buildDropDownRoleAndHierarchy() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(width: 0.0, height: 0.0),
                ),
                Expanded(
                  flex: 6,
                  child: buildRotaryRoleDropDownButton(),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  flex: 6,
                  child: buildRotaryAreaDropDownButton(),
                ),
              ],
            ),
          ),

          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                flex: 3,
                child: Container(width: 0.0, height: 0.0),
              ),
              Expanded(
                flex: 6,
                child: buildRotaryClusterDropDownButton(),
              ),
              SizedBox(width: 10.0,),
              Expanded(
                flex: 6,
                child: buildRotaryClubDropDownButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Build Rotary Role DropDown Button
  Widget buildRotaryRoleDropDownButton() {
    return  Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryRoleObj,
        items: dropdownRotaryRoleItems,
        onChanged: onChangeDropdownRotaryRoleItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר תפקיד'),
        validator: (value) => value == null ? 'בחר תפקיד' : null,
        // underline: SizedBox(),
      ),
    );
  }
  //#endregion

  //#region Build Rotary Area DropDown Button
  Widget buildRotaryAreaDropDownButton() {
    return  Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryAreaObj,
        items: dropdownRotaryAreaItems,
        onChanged: onChangeDropdownRotaryAreaItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר אזור'),
        validator: (value) => value == null ? 'בחר אזור' : null,
        // underline: SizedBox(),
        // iconSize: 30,
      ),
    );
  }
  //#endregion

  //#region Build Rotary Cluster DropDown Button
  Widget buildRotaryClusterDropDownButton() {
    return Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryClusterObj,
        items: dropdownRotaryClusterFilteredItems,
        onChanged: onChangeDropdownRotaryClusterItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר אשכול'),
        validator: (value) => value == null ? 'בחר אשכול' : null,
        // underline: SizedBox(),
      ),
    );
  }
  //#endregion

  //#region Build Rotary Club DropDown Button
  Widget buildRotaryClubDropDownButton() {
    return Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryClubObj,
        items: dropdownRotaryClubFilteredItems,
        onChanged: onChangeDropdownRotaryClubItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר מועדון'),
        validator: (value) => value == null ? 'בחר מועדון' : null,
        // underline: SizedBox(),
      ),
    );
  }
  //#endregion

  //#endregion

  //#region UPDATE Button
  Widget buildUpdateCircleButton(Function aFunc) {

    final personCardsBloc = BlocProvider.of<PersonCardsListBloc>(context);

    return StreamBuilder<List<PersonCardObject>>(
        stream: personCardsBloc.personCardsStream,
        initialData: personCardsBloc.personCardsList,
        builder: (context, snapshot) {
          List<PersonCardObject> currentPersonCardsList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? personCardsBloc.personCardsList
              : snapshot.data;

          return MaterialButton(
            elevation: 0.0,
            onPressed: () async {
              aFunc(personCardsBloc);
            },
            color: Colors.white,
            padding: EdgeInsets.all(10),
            shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            child: IconTheme(
              data: IconThemeData(
                color: Colors.black,
              ),
              child: Icon(
                Icons.save,
                size: 20,
              ),
            ),
          );
        }
    );
  }

  Widget buildUpdateButtonRectangleWithIcon(String buttonText, Function aFunc, IconData aIcon) {

    final personCardsBloc = BlocProvider.of<PersonCardsListBloc>(context);

    return StreamBuilder<List<PersonCardObject>>(
        stream: personCardsBloc.personCardsStream,
        initialData: personCardsBloc.personCardsList,
        builder: (context, snapshot) {
          List<PersonCardObject> currentPersonCardsList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? personCardsBloc.personCardsList
              : snapshot.data;

          return RaisedButton.icon(
            onPressed: () {
              aFunc(personCardsBloc);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            label: Text(
              buttonText,
              style: TextStyle(
                  color: Colors.white,fontSize: 16.0
              ),
            ),
            icon: Icon(
              aIcon,
              color:Colors.white,
            ),
            textColor: Colors.white,
            color: Colors.blue[400],
          );
        }
    );
  }
  //#endregion
}