import 'dart:async';
import 'dart:convert';
import 'package:rotary_net/database/init_database_data.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/rotary_club_service.dart';
import 'package:rotary_net/services/rotary_cluster_service.dart';
import 'package:rotary_net/services/rotary_role_service.dart';
import 'dart:developer' as developer;

import 'package:rotary_net/services/user_service.dart';

class InitDatabaseService {

  //#region Initialize Users Table Data [INIT USERS BY JSON DATA]
  // =========================================================
  Future initializeUsersTableData() async {
    try {
      String initializeUsersJsonForDebug = InitDataBaseData.createJsonRowsForUsers();

      var initializeUsersListForDebug = jsonDecode(initializeUsersJsonForDebug) as List;
      List<UserObject> userObjListForDebug = initializeUsersListForDebug.map((userJsonDebug) => UserObject.fromJson(userJsonDebug)).toList();

      userObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
      return userObjListForDebug;
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Initialize Users Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeUsersTableData',
        name: 'InitDatabaseService',
        error: 'Users List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started Users To DB
  Future insertAllStartedUsersToDb() async {
    List<UserObject> starterUsersList;
    starterUsersList = await initializeUsersTableData();

    UserService userService = UserService();
    starterUsersList.forEach((UserObject userObj) async => await userService.insertUser(userObj));
  }
  //#endregion

  //#region Initialize PersonCards Table Data [INIT PersonCard BY JSON DATA]
  // ========================================================================
  Future<List<PersonCardObject>> initializePersonCardsTableData() async {
    try {
        String initializePersonCardsJsonForDebug = InitDataBaseData.createJsonRowsForPersonCards();

        var initializePersonCardsListForDebug = jsonDecode(initializePersonCardsJsonForDebug) as List;

        List<PersonCardObject> personCardObjListForDebug = initializePersonCardsListForDebug.map((personJsonDebug) =>
            PersonCardObject.fromJson(personJsonDebug)).toList();

        personCardObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        return personCardObjListForDebug;
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Get PersonCards List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializePersonCardsTableData',
        name: 'InitDatabaseService',
        error: 'PersonCards List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started PersonCards To DB
  Future insertAllStartedPersonCardsToDb() async {
    List<PersonCardObject> starterPersonCardsList;
    starterPersonCardsList = await initializePersonCardsTableData();

    PersonCardService personCardService = PersonCardService();
    starterPersonCardsList.forEach((PersonCardObject personCardObj) async =>
            await personCardService.insertPersonCardOnInitializeDataBase(personCardObj));
  }
  //#endregion

  //#region Initialize Events Table Data [INIT Events BY JSON DATA]
  // ========================================================================
  Future initializeEventsTableData() async {
    try {
      String initializeEventsJsonForDebug = InitDataBaseData.createJsonRowsForEvents();

      var initializeEventsListForDebug = jsonDecode(initializeEventsJsonForDebug) as List;    // List of Users to display;
      List<EventObject> eventObjListForDebug = initializeEventsListForDebug.map((eventJsonDebug) => EventObject.fromJson(eventJsonDebug)).toList();

      eventObjListForDebug.sort((a, b) => a.eventName.toLowerCase().compareTo(b.eventName.toLowerCase()));
      return eventObjListForDebug;
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Get Events List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeEventsTableData',
        name: 'InitDatabaseService',
        error: 'Events List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started Events To DB
  Future insertAllStartedEventsToDb() async {
    List<EventObject> starterEventsList;
    starterEventsList = await initializeEventsTableData();

    EventService eventService = EventService();
    starterEventsList.forEach((EventObject eventObj) async => await eventService.insertEvent(eventObj));
  }
  //#endregion

  //#region Initialize Messages Table Data [INIT Messages BY JSON DATA]
  // ========================================================================
  Future initializeMessagesTableData() async {
    try {
      String initializeMessagesJsonForDebug = InitDataBaseData.createJsonRowsForMessages();

      var initializeMessagesListForDebug = jsonDecode(initializeMessagesJsonForDebug) as List;    // List of Users to display;
      List<MessageObject> messageObjListForDebug = initializeMessagesListForDebug.map((messageJsonDebug) =>
          MessageObject.fromJson(messageJsonDebug)).toList();
      // print('eventObjListForDebug.length: ${eventObjListForDebug.length}');

      messageObjListForDebug.sort((a, b) => a.messageCreatedDateTime.compareTo(b.messageCreatedDateTime));
      return messageObjListForDebug;
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Get Messages List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeMessagesTableData',
        name: 'InitDatabaseService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Initialize Rotary Role Table Data [INIT Role BY JSON DATA]
  // ========================================================================
  Future initializeRotaryRoleTableData() async {
    try {
      String initializeRotaryRoleJsonForDebug = InitDataBaseData.createJsonRowsForRotaryRole();

      var initializeRotaryRoleListForDebug = jsonDecode(initializeRotaryRoleJsonForDebug) as List;
      List<RotaryRoleObject> rotaryRoleObjListForDebug = initializeRotaryRoleListForDebug.map((roleJsonDebug) =>
          RotaryRoleObject.fromJson(roleJsonDebug)).toList();

      rotaryRoleObjListForDebug.sort((a, b) => a.roleName.toLowerCase().compareTo(b.roleName.toLowerCase()));
      return rotaryRoleObjListForDebug;
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Initialize RotaryRole Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryRoleTableData',
        name: 'InitDatabaseService',
        error: 'Initialize RotaryRole Table Data >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started RotaryRole To DB
  Future insertAllStartedRotaryRoleToDb() async {
    List<RotaryRoleObject> starterRotaryRoleList;
    starterRotaryRoleList = await initializeRotaryRoleTableData();

    RotaryRoleService roleService = RotaryRoleService();
    starterRotaryRoleList.forEach((RotaryRoleObject rotaryRoleObj) async => await roleService.insertRotaryRole(rotaryRoleObj));
  }
  //#endregion

  //#region Initialize Rotary Area Table Data [INIT Area BY JSON DATA]
  // ========================================================================
  Future initializeRotaryAreaTableData() async {
    try {
      String initializeRotaryAreaJsonForDebug = InitDataBaseData.createJsonRowsForRotaryArea();

      var initializeRotaryAreaListForDebug = jsonDecode(initializeRotaryAreaJsonForDebug) as List;
      List<RotaryAreaObject> rotaryAreaObjListForDebug = initializeRotaryAreaListForDebug.map((areaJsonDebug) =>
          RotaryAreaObject.fromJson(areaJsonDebug)).toList();

      rotaryAreaObjListForDebug.sort((a, b) => a.areaName.toLowerCase().compareTo(b.areaName.toLowerCase()));
      return rotaryAreaObjListForDebug;
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Initialize RotaryArea Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryAreaTableData',
        name: 'InitDatabaseService',
        error: 'Initialize RotaryArea Table Data >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started RotaryArea To DB
  Future insertAllStartedRotaryAreaToDb() async {
    List<RotaryAreaObject> starterRotaryAreaList;
    starterRotaryAreaList = await initializeRotaryAreaTableData();

    RotaryAreaService areaService = RotaryAreaService();
    starterRotaryAreaList.forEach((RotaryAreaObject rotaryAreaObj) async => await areaService.insertRotaryArea(rotaryAreaObj));
  }
//#endregion

  //#region Initialize Rotary Cluster Table Data [INIT Cluster BY JSON DATA]
  // ========================================================================
  Future initializeRotaryClusterTableData(String aAreaName) async {
    try {
      String initializeRotaryClusterJsonForDebug = InitDataBaseData.createJsonRowsForRotaryCluster(aAreaName);

      var initializeRotaryClusterListForDebug = jsonDecode(initializeRotaryClusterJsonForDebug) as List;
      List<RotaryClusterObject> rotaryClusterObjListForDebug = initializeRotaryClusterListForDebug.map((clusterJsonDebug) =>
          RotaryClusterObject.fromJson(clusterJsonDebug)).toList();

      rotaryClusterObjListForDebug.sort((a, b) => a.clusterName.toLowerCase().compareTo(b.clusterName.toLowerCase()));
      return rotaryClusterObjListForDebug;
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Initialize RotaryCluster Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryClusterTableData',
        name: 'InitDatabaseService',
        error: 'Initialize RotaryCluster Table Data >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started RotaryCluster To DB
  Future insertAllStartedRotaryClusterToDb() async {
    RotaryAreaService areaService = RotaryAreaService();
    List<RotaryAreaObject> _areaList = await areaService.getAllRotaryAreaList();

    List<RotaryClusterObject> starterRotaryClusterList;
    RotaryClusterService clusterService = RotaryClusterService();

    _areaList.forEach((RotaryAreaObject rotaryAreaObj) async
    {
        starterRotaryClusterList = await initializeRotaryClusterTableData(rotaryAreaObj.areaName);

        starterRotaryClusterList.forEach((RotaryClusterObject rotaryClusterObj) async =>
            await clusterService.insertRotaryClusterWithArea(rotaryAreaObj.areaId, rotaryClusterObj));
    });
  }
  //#endregion

  //#region Initialize Rotary Club Table Data [INIT Club BY JSON DATA]
  // ========================================================================
  Future initializeRotaryClubTableData(String aClusterName) async {
    try {
      String initializeRotaryClubJsonForDebug = InitDataBaseData.createJsonRowsForRotaryClub(aClusterName);

      List<RotaryClubObject> rotaryClubObjListForDebug;
      if (initializeRotaryClubJsonForDebug != null)
      {
        var initializeRotaryClubListForDebug = jsonDecode(initializeRotaryClubJsonForDebug) as List;    // List of Cluster to display;
        rotaryClubObjListForDebug = initializeRotaryClubListForDebug.map((clubJsonDebug) =>
            RotaryClubObject.fromJson(clubJsonDebug)).toList();

        rotaryClubObjListForDebug.sort((a, b) => a.clubName.toLowerCase().compareTo(b.clubName.toLowerCase()));
      }

      return rotaryClubObjListForDebug;
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Initialize RotaryClub Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryClubTableData',
        name: 'InitDatabaseService',
        error: 'Initialize RotaryClub Table Data >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started RotaryClub To DB
  Future insertAllStartedRotaryClubToDb() async {
    RotaryClusterService clusterService = RotaryClusterService();
    List<RotaryClusterObject> _clusterList = await clusterService.getAllRotaryClusterList();

    List<RotaryClubObject> starterRotaryClubList;
    RotaryClubService clubService = RotaryClubService();

    _clusterList.forEach((RotaryClusterObject rotaryClusterObj) async
    {
      starterRotaryClubList = await initializeRotaryClubTableData(rotaryClusterObj.clusterName);
      if (starterRotaryClubList != null) {

        starterRotaryClubList.forEach((RotaryClubObject rotaryClubObj) async =>
            await clubService.insertRotaryClubWithCluster(rotaryClusterObj.clusterId, rotaryClubObj));
      }
    });
  }
  //#endregion
}
