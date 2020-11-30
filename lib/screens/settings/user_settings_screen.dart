import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/user_type_label_radio.dart';

class UserSettingsScreen extends StatefulWidget {
  static const routeName = '/UserSettingsScreen';

  @override
  _UserSettingsScreen createState() => _UserSettingsScreen();
}

class _UserSettingsScreen extends State<UserSettingsScreen> {

  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;

  String appBarTitle = 'Current User Settings';
  Constants.UserTypeEnum userType;
  bool loading = true;

  final ConnectedUserService connectedUserService = ConnectedUserService();

  @override
  void initState() {
    dataRequiredForBuild = getAllRequiredDataForBuild();
    super.initState();
  }

  //#region Get All Required Data For Build
  Future<DataRequiredForBuild> getAllRequiredDataForBuild() async {
    setState(() {
      loading = true;
    });
    ConnectedUserObject _currentConnectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;

    UserService _userService = UserService();
    List<UserObject> _userObjList = await _userService.getAllUsersList();
    setUserDropdownMenuItems(_userObjList, _currentConnectedUserObj);

    setCurrentUserType(_currentConnectedUserObj);

    setState(() {
      loading = false;
    });

    return DataRequiredForBuild(
      connectedUserObj: _currentConnectedUserObj,
      userObjectList: _userObjList,
    );
  }
  //#endregion

  //#region Set Current UserType
  void setCurrentUserType(ConnectedUserObject aConnectedUserObj) async {
    if (aConnectedUserObj.userType == null)
      userType = Constants.UserTypeEnum.SystemAdmin;
    else
      userType = aConnectedUserObj.userType;
  }
  //#endregion

  //#region Update UserType
  Future updateUserType(Constants.UserTypeEnum aUserType) async {
    currentDataRequired.connectedUserObj.setUserType(aUserType);
    await connectedUserService.writeConnectedUserTypeToSecureStorage(aUserType);

    /// DataBase: Update the User Data with new UserType
    UserObject _userObject = await UserObject.getUserObjectFromConnectedUserObject(currentDataRequired.connectedUserObj);
    _userObject.setUserType(aUserType);
    UserService _userService = UserService();
    _userService.updateUserById(_userObject);
  }
  //#endregion

  //#region User DropDown
  List<DropdownMenuItem<UserObject>> dropdownUserItems;
  UserObject selectedUserObj;

  void setUserDropdownMenuItems(List<UserObject> aUserObjectsList, ConnectedUserObject aConnectedUserObj) {
    List<DropdownMenuItem<UserObject>> _userDropDownItems = List();
    for (UserObject _userObj in aUserObjectsList) {
      _userDropDownItems.add(
        DropdownMenuItem(
          child: Text(
            _userObj.firstName + " " + _userObj.lastName,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          value: _userObj,
        ),
      );
    }
    dropdownUserItems = _userDropDownItems;

    // Find the UserObject Element in a UsersList By Id ===>>> Set DropDown Initial Value
    int _initialListIndex;
    if (aConnectedUserObj.userId != null) {
      _initialListIndex = aUserObjectsList.indexWhere((listElement) => listElement.userId == aConnectedUserObj.userId);
      selectedUserObj = dropdownUserItems[_initialListIndex].value;
    } else {
      _initialListIndex = null;
      selectedUserObj = null;
    }
  }

  onChangeDropdownUserItem(UserObject aSelectedUserObject) async {
    FocusScope.of(context).requestFocus(FocusNode());

    final ConnectedUserService connectedUserService = ConnectedUserService();
    ConnectedUserObject _newConnectedUserObj = await ConnectedUserObject.getConnectedUserObjectFromUserObject(aSelectedUserObject);

    setState(() {
      selectedUserObj = aSelectedUserObject;
      currentDataRequired.connectedUserObj = _newConnectedUserObj;
      userType = aSelectedUserObject.userType;
    });

    /// SAVE New ConnectedUser:
    /// 1. Fetch Connected PersonCard Data
    PersonCardService personCardService = PersonCardService();
    Map<String, dynamic> connectedReturnData = await personCardService.getPersonCardByIdForConnectedData(_newConnectedUserObj.personCardId);

    /// 2. Secure Storage: Write to SecureStorage
    await connectedUserService.writeConnectedUserObjectDataToSecureStorage(_newConnectedUserObj);

    /// 3. Secure Storage: Write RotaryRoleEnum to SecureStorage
    Constants.RotaryRolesEnum _roleEnum = connectedReturnData['roleEnumDisplay'];
    await connectedUserService.writeRotaryRoleEnumDataToSecureStorage(_roleEnum);

    /// 4. Secure Storage: Write PersonCardAvatarImageUrl to SecureStorage
    String _personCardPictureUrl = connectedReturnData['personCardPictureUrl'];
    await connectedUserService.writePersonCardAvatarImageUrlToSecureStorage(_personCardPictureUrl);

    var userGlobal = ConnectedUserGlobal();
    /// 5. App Global: Update Global Current Connected User
    await userGlobal.setConnectedUserObject(_newConnectedUserObj);

    /// 6. App Global: Update RotaryRoleEnum
    await userGlobal.setRotaryRoleEnum(_roleEnum);

    /// 7. App Global: Update PersonCardAvatarImageUrl
    await userGlobal.setPersonCardAvatarImageUrl(_personCardPictureUrl);

    print('UserSettingsScreen / ChangeUserForDebug / NewConnectedUserObj: $_newConnectedUserObj');
  }
  //#endregion

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        elevation: 5.0,
        title: Text(appBarTitle),
      ),

      body: FutureBuilder<DataRequiredForBuild>(
          future: dataRequiredForBuild,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Loading();
            else {
              currentDataRequired = snapshot.data;
              return buildMainScaffoldBody();
            }
          }
      ),
    );
  }

  Widget buildMainScaffoldBody() {
    return Center(
      child: Container(
        child:
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0, bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              ///============ Application Mode SETTINGS ============
              SizedBox(height: 30.0,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Divider(
                      color: Colors.grey[600],
                      thickness: 2.0,
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text (
                      'Current User Picker',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Divider(
                      color: Colors.grey[600],
                      thickness: 2.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0,),

              buildUserDropDownButton(),
              SizedBox(height: 30.0,),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'User Type:',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                    ),
                  ),

                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <UserTypeLabelRadio>[
                        UserTypeLabelRadio(
                          label: 'System Admin',
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          value: Constants.UserTypeEnum.SystemAdmin,
                          groupValue: userType,
                          onChanged: (Constants.UserTypeEnum newValue) {
                            setState(() {
                              userType = newValue;
                            });
                            updateUserType(userType);
                          },
                        ),
                        UserTypeLabelRadio(
                          label: 'Rotary Member',
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          value: Constants.UserTypeEnum.RotaryMember,
                          groupValue: userType,
                          onChanged: (Constants.UserTypeEnum newValue) {
                            setState(() {
                              userType = newValue;
                            });
                            updateUserType(userType);
                          },
                        ),
                        UserTypeLabelRadio(
                          label: 'Guest',
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          value: Constants.UserTypeEnum.Guest,
                          groupValue: userType,
                          onChanged: (Constants.UserTypeEnum newValue) {
                            setState(() {
                              userType = newValue;
                            });
                            updateUserType(userType);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //#region Build User DropDown Button
  Widget buildUserDropDownButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 45.0,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: DropdownButtonFormField(
          value: selectedUserObj,
          items: dropdownUserItems,
          onChanged: onChangeDropdownUserItem,
          decoration: InputDecoration.collapsed(hintText: ''),
          hint: Text('בחר משתמש'),
          validator: (value) => value == null ? 'בחר משתמש' : null,
        ),
      ),
    );
  }
//#endregion
}

class DataRequiredForBuild {
  ConnectedUserObject connectedUserObj;
  List<UserObject> userObjectList;

  DataRequiredForBuild({
    this.connectedUserObj,
    this.userObjectList,
  });
}