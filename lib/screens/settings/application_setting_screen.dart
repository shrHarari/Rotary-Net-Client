import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class ApplicationSettingsScreen extends StatefulWidget {
  static const routeName = '/ApplicationSettingsScreen';

  @override
  _ApplicationSettingsScreen createState() => _ApplicationSettingsScreen();
}

class _ApplicationSettingsScreen extends State<ApplicationSettingsScreen> {

  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;

  String appBarTitle = 'Application Settings';
  bool newApplicationType;
  bool newApplicationRunningMode;
  bool isFirst = true;
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

    setState(() {
      loading = false;
    });

    return DataRequiredForBuild(
      connectedUserObj: _currentConnectedUserObj,
    );
  }
  //#endregion

  //#region Update Application Type
  updateApplicationType(bool aApplicationType) async {
    GlobalsService.setApplicationType(aApplicationType);
    GlobalsService.writeApplicationTypeToSP(aApplicationType);

    /// Change Current User Data --->>> Write the new ID to Storage
    /// =============================================================
    ConnectedUserObject _newConnectedUserObj = await connectedUserService.getConnectedUserByEmail(currentDataRequired.connectedUserObj.email);

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

    print('ApplicationSettingsScreen / updateApplicationType / NewConnectedUserObj: $_newConnectedUserObj');
  }
  //#endregion

  //#region Update Application RunningMode
  void updateApplicationRunningMode(bool aApplicationRunningMode) {
    GlobalsService.setApplicationRunningMode(aApplicationRunningMode);
    GlobalsService.writeApplicationRunningModeToSP(aApplicationRunningMode);
  }
  //#endregion

  //#region Start All Over
  Future startAllOver() async {
    /// LoginStatus='NoRequest' ==>>> Clear all data from SecureStorage
    await connectedUserService.clearConnectedUserObjectDataFromSecureStorage();
    exitFromApp();
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
      newApplicationType = GlobalsService.applicationType;
      newApplicationRunningMode = GlobalsService.applicationRunningMode;
      isFirst = false;
    }

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
              SizedBox(height: 40.0,),

              ///============ Application SETTINGS ============
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Divider(
                      color: Colors.grey[600],
                      thickness: 2.0,
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text (
                      'Application Settings',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Divider(
                      color: Colors.grey[600],
                      thickness: 2.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Application Type:',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Client',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Switch(
                      value: newApplicationType,
                      onChanged: (bool newValue) async  {
                        updateApplicationType(newValue);
                        setState(() {
                          newApplicationType = newValue;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Network',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Application Running Mode:',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Debug',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Switch(
                      value: newApplicationRunningMode,
                      onChanged: (bool newValue) {
                        updateApplicationRunningMode(newValue);
                        setState(() {
                          newApplicationRunningMode = newValue;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Production',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.0,),

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
                      'DATA BASE',
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
                          // InitDatabaseService _initDatabaseService = InitDatabaseService();
                          // await _initDatabaseService.insertAllStartedRotaryRoleToDb();
                          // await _initDatabaseService.insertAllStartedRotaryAreaToDb();
                          // await _initDatabaseService.insertAllStartedRotaryClusterToDb();
                          // await _initDatabaseService.insertAllStartedRotaryClubToDb();

                          // await _initDatabaseService.insertAllStartedUsersToDb();
                          // await _initDatabaseService.insertAllStartedPersonCardsToDb();
                          // await _initDatabaseService.insertAllStartedEventsToDb();
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
            ],
          ),
        ),
      ),
    );
  }
}

class DataRequiredForBuild {
  ConnectedUserObject connectedUserObj;

  DataRequiredForBuild({
    this.connectedUserObj,
  });
}