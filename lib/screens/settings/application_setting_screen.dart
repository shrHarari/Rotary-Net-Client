import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rotary_net/database/init_database_service.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/loading.dart';

class ApplicationSettingsScreen extends StatefulWidget {
  static const routeName = '/ApplicationSettingsScreen';

  @override
  _ApplicationSettingsScreen createState() => _ApplicationSettingsScreen();
}

class _ApplicationSettingsScreen extends State<ApplicationSettingsScreen> {

  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;

  String appBarTitle = 'Application Settings';
  bool newApplicationMode;
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

  //#region Update Application Mode
  void updateApplicationMode(bool aApplicationMode) {
    GlobalsService.setApplicationMode(aApplicationMode);
    GlobalsService.writeApplicationModeToSP(aApplicationMode);
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
      newApplicationMode = GlobalsService.applicationMode;
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

              SizedBox(height: 10.0),

              ///============ Application Mode SETTINGS ============
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
                      'Application Mode',
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
                      'Application Mode\n(ON for SERVER):',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Switch(
                      value: newApplicationMode,
                      onChanged: (bool newValue) {
                        updateApplicationMode(newValue);
                        setState(() {
                          newApplicationMode = newValue;
                        });
                      },
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
                          InitDatabaseService _initDatabaseService = InitDatabaseService();
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