import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class RotaryClubService {

  //#region Create RotaryClub As Object
  //=============================================================================
  RotaryClubObject createRotaryClubAsObject(
      String aClubId,
      String aClubName,
      String aClubAddress,
      String aClubMail,
      String aClubManagerId
      )
  {
      return RotaryClubObject(
        clubId: aClubId,
        clubName: aClubName,
        clubAddress: aClubAddress,
        clubMail:  aClubMail,
        clubManagerId:  aClubManagerId
      );
  }
  //#endregion

  //#region * Get All RotaryClub List [GET]
  // =========================================================
  Future getAllRotaryClubList() async {
    try {
      Response response = await get(Constants.rotaryClubUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClubService> Get All Rotary Club List >>> OK\nHeader: $contentType \nRotaryClubListFromJSON: $jsonResponse');

        var clubsList = jsonDecode(jsonResponse) as List;
        List<RotaryClubObject> clubsObjList = clubsList.map((clubJson) => RotaryClubObject.fromJson(clubJson)).toList();

        return clubsObjList;
      } else {
        await LoggerService.log('<RotaryClubService> Get All RotaryClub List >>> Failed: ${response.statusCode}');
        print('<RotaryClubService> Get All RotaryClub List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Get All RotaryClub List >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryClubList',
        name: 'RotaryClubService',
        error: 'Get All RotaryClub List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryClub By ClubId [GET]
  // =========================================================
  Future getRotaryClubByClubId(String aClubId) async {
    try {
      String _getUrl = Constants.rotaryClubUrl + "/$aClubId";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClubService> Get All RotaryClub By ClubId >>> OK >>> RotaryClubFromJSON: $jsonResponse');

        var _club = jsonDecode(jsonResponse);
        RotaryClubObject _clubObj = RotaryClubObject.fromJson(_club);

        return _clubObj;
      } else {
        await LoggerService.log('<RotaryClubService> Get All RotaryClub By ClubId >>> Failed: ${response.statusCode}');
        print('<RotaryClubService> Get All RotaryClub By ClubId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Get All RotaryClub By ClubId >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryClubByClubId',
        name: 'RotaryClubService',
        error: 'Get All RotaryClub By ClubId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryClub By ClubName [GET]
  // =========================================================
  Future getRotaryClubByClubName(String aClubName) async {
    try {
      String _getUrl = Constants.rotaryClubUrl + "/clubName/$aClubName";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClubService> Get RotaryClub By ClubName >>> OK >>> RotaryClubFromJSON: $jsonResponse');

        var _club = jsonDecode(jsonResponse);
        RotaryClubObject _clubObj = RotaryClubObject.fromJson(_club);

        return _clubObj;
      } else {
        await LoggerService.log('<RotaryClubService> Get RotaryClub By ClubName >>> Failed: ${response.statusCode}');
        print('<RotaryClubService> Get RotaryClub By ClubName >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Get RotaryClub By ClubName >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryClubByClubName',
        name: 'RotaryClubService',
        error: 'Get RotaryClub By ClubName >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Club

  //#region * Insert RotaryClub [WriteToDB]
  //=============================================================================
  Future insertRotaryClub(RotaryClubObject aRotaryClubObj) async {
    try{
      String jsonToPost = aRotaryClubObj.rotaryClubObjectToJson(aRotaryClubObj);

      Response response = await post(Constants.rotaryClubUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClubObject> Insert RotaryClub >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClubService> Insert RotaryClub >>> Failed');
          print('<RotaryClubService> Insert RotaryClub >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryClubService> Insert RotaryClub >>> Failed >>> ${response.statusCode}');
        print('<RotaryClubService> Insert RotaryClub >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Insert RotaryClub >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryClub',
        name: 'RotaryClubService',
        error: 'Insert RotaryClub >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Insert RotaryClub With Cluster [WriteToDB]
  //=============================================================================
  Future insertRotaryClubWithCluster(String aClusterId, RotaryClubObject aRotaryClubObj) async {
    try{
      String _getUrl = Constants.rotaryClubUrl + "/clusterId/$aClusterId";

      String jsonToPost = aRotaryClubObj.rotaryClubObjectToJson(aRotaryClubObj);

      Response response = await post(_getUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClubObject> Insert RotaryClub WithCluster >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClubService> Insert RotaryClub WithCluster >>> Failed');
          print('<RotaryClubService> Insert RotaryClub WithCluster >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryClubService> Insert RotaryClub WithCluster >>> Failed >>> ${response.statusCode}');
        print('<RotaryClubService> Insert RotaryClub WithCluster >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Insert RotaryClub WithCluster >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryClubWithCluster',
        name: 'RotaryClubService',
        error: 'Insert RotaryClub WithCluster >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update RotaryClub By ClubId [WriteToDB]
  //=============================================================================
  Future updateRotaryClubByClubId(RotaryClubObject aRotaryClubObj) async {
    try {
      String jsonToPost = aRotaryClubObj.rotaryClubObjectToJson(aRotaryClubObj);

      String _updateUrl = Constants.rotaryClubUrl + "/${aRotaryClubObj.clubId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClubService> Update RotaryClub By ClubId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClubService> Update RotaryClub By ClubId >>> Failed');
          print('<RotaryClubService> Update RotaryClub By ClubId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Update RotaryClub By ClubId >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryClubByClubId',
        name: 'RotaryClubService',
        error: 'Update RotaryClub By ClubId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete RotaryClub By ClubId [WriteToDB]
  //=============================================================================
  Future deleteRotaryClubByClubId(RotaryClubObject aRotaryClubObj) async {
    try {
      String _deleteUrl = Constants.rotaryClubUrl + "/${aRotaryClubObj.clubId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClubService> Delete Rotary Club By ClubId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClubService> Delete Rotary Club By ClubId >>> Failed');
          print('<RotaryClubService> Delete Rotary Club By ClubId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Delete Rotary Club By ClubId >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryClubByClubId',
        name: 'RotaryClubService',
        error: 'Delete Rotary Club By ClubId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
