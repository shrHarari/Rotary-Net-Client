import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rotary_net/database/init_database_service.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/user_type_label_radio.dart';

class DebugSettingsScreen extends StatefulWidget {
  static const routeName = '/DebugSettingsScreen';

  @override
  _DebugSettingsScreen createState() => _DebugSettingsScreen();
}

class _DebugSettingsScreen extends State<DebugSettingsScreen> {

  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;

  String appBarTitle = 'Rotary Debug';
  String iconBarTitle = 'Exit';
  bool isNoRequestStatus = false;
  bool newIsDebugMode;
  bool isFirst = true;
  Constants.UserTypeEnum userType;
  bool loading = true;

  final ConnectedUserService connectedUserService = ConnectedUserService();
  String newLoginStatus = '';

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

  //#region Update Debug Mode
  void updateDebugMode(bool aIsDebug) {
    GlobalsService.setDebugMode(aIsDebug);
    GlobalsService.writeDebugModeToSP(aIsDebug);
  }
  //#endregion

  //#region Start All Over
  Future startAllOver() async {
    /// LoginStatus='NoRequest' ==>>> Clear all data from SecureStorage
    await connectedUserService.clearConnectedUserObjectDataFromSecureStorage();
    exitFromApp();
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
    /// 1. Secure Storage: Write to SecureStorage
    await connectedUserService.writeConnectedUserObjectDataToSecureStorage(_newConnectedUserObj);

    /// 2. App Global: Update Global Current Connected User
    var userGlobal = ConnectedUserGlobal();
    userGlobal.setConnectedUserObject(_newConnectedUserObj);

    print('LoginScreen / ChangeUserForDebug / NewConnectedUserObj: $_newConnectedUserObj');
  }
  //#endregion

  //#region Exit From App
  void exitFromApp() {
    exit(0);
  }
  //#endregion

  @override
  Widget build(BuildContext context) {

    // Initial Value
    if (isFirst){
      newIsDebugMode = GlobalsService.isDebugMode;
      isFirst = false;
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        elevation: 5.0,
        title: Text(appBarTitle),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                exitFromApp();
              },
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              label: Text(iconBarTitle,
                style: TextStyle(color: Colors.white),
              )
          )
        ],
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
              RaisedButton(
                  elevation: 0.0,
                  disabledElevation: 0.0,
                  color: Colors.green,
                  child: Text(
                    'Start All Over: No Request',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await startAllOver();
                  }
              ),

              SizedBox(height: 10.0),

              ///============ Debug Mode SETTINGS ============
              SizedBox(height: 30.0,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Divider(
                      color: Colors.grey[600],
                      thickness: 2.0,
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text (
                      'Debug Mode',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Divider(
                      color: Colors.grey[600],
                      thickness: 2.0,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Text(
                      'Is Debug Mode ?:',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Switch(
                      value: newIsDebugMode,
                      onChanged: (bool newValue) {
                        updateDebugMode(newValue);
                        setState(() {
                          newIsDebugMode = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
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
              SizedBox(height: 10.0,),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                        elevation: 0.0,
                        disabledElevation: 0.0,
                        color: Colors.blue,
                        child: Text(
                          'Init Rotary DB',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          // await RotaryDataBaseProvider.rotaryDB.createRotaryDB();

                          InitDatabaseService _initDatabaseService = InitDatabaseService();
                          // await _initDatabaseService.insertAllStartedRotaryRoleToDb();
                          // await _initDatabaseService.insertAllStartedRotaryAreaToDb();
                          // await _initDatabaseService.insertAllStartedRotaryClusterToDb();
                          // await _initDatabaseService.insertAllStartedRotaryClubToDb();

                          // await _initDatabaseService.insertAllStartedUsersToDb();
                          // await _initDatabaseService.insertAllStartedPersonCardsToDb();
                          // await _initDatabaseService.insertAllStartedEventsToDb();
                          // await _initDatabaseService.insertAllStartedMessagesToDb();
                          // await _initDatabaseService.insertAllStartedMessageQueueToDb();
                        }
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                        elevation: 0.0,
                        disabledElevation: 0.0,
                        color: Colors.green,
                        child: Text(
                          'Get Users',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          UserService _userService = UserService();
                          await _userService.getAllUsersList();
                        }
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                        elevation: 0.0,
                        disabledElevation: 0.0,
                        color: Colors.green,
                        child: Text(
                          'User By Mail',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          UserService _userService = UserService();
                          await _userService.getUserByEmail("uma_thurman@gmail.com");
                        }
                    ),
                  ),
                  SizedBox(width: 5.0,),

                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                        elevation: 0.0,
                        disabledElevation: 0.0,
                        color: Colors.green,
                        child: Text(
                          'Get Areas',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          RotaryAreaService _areaService = RotaryAreaService();
                          await _areaService.getAllRotaryAreaList();
                        }
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 10.0,),
              buildUserDropDownButton(),
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