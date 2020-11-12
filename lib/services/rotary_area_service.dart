import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class RotaryAreaService {

  //#region Create RotaryArea As Object
  //=============================================================================
  RotaryAreaObject createRotaryAreaAsObject(
      String aAreaId,
      String aAreaName,
      )
  {
    if (aAreaId == null)
      return RotaryAreaObject(
        areaId: '0',
        areaName: '',
      );
    else
      return RotaryAreaObject(
        areaId: aAreaId,
        areaName: aAreaName,
      );
  }
  //#endregion

  //#region * Get All RotaryArea List (w/o Clusters) [GET]
  // =========================================================
  Future getAllRotaryAreaList({bool withPopulate = false}) async {
    try {
      String _getUrlArea;

      if (withPopulate) _getUrlArea = GlobalsService.applicationServer + Constants.rotaryAreaUrl + "/withClusters";
      else _getUrlArea = GlobalsService.applicationServer + Constants.rotaryAreaUrl;

      Response response = await get(_getUrlArea);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryAreaService> Get All Rotary Area List >>> OK\nHeader: $contentType \nRotaryAreaListFromJSON: $jsonResponse');

        var areasList = jsonDecode(jsonResponse) as List;
        List<RotaryAreaObject> areasObjList = areasList.map((areaJson) => RotaryAreaObject.fromJson(areaJson)).toList();

        return areasObjList;
      } else {
        await LoggerService.log('<RotaryAreaService> Get All RotaryArea List >>> Failed: ${response.statusCode}');
        print('<RotaryAreaService> Get All RotaryArea List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryArea List >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryAreaList',
        name: 'RotaryAreaService',
        error: 'Get All RotaryArea List From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryArea By AreaId (w/o Clusters) [GET]
  // =========================================================
  Future getRotaryAreaByAreaId(String aAreaId, {bool withPopulate = false}) async {
    try {
      String _getUrlArea;

      if (withPopulate) _getUrlArea = GlobalsService.applicationServer + Constants.rotaryAreaUrl + "/withClusters/$aAreaId";
      else _getUrlArea = GlobalsService.applicationServer + Constants.rotaryAreaUrl + "/$aAreaId";

      Response response = await get(_getUrlArea);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaId >>> OK >>> RotaryAreaFromJSON: $jsonResponse');

        var _area = jsonDecode(jsonResponse);
        RotaryAreaObject _areaObj = RotaryAreaObject.fromJson(_area);

        return _areaObj;
      } else {
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaId >>> Failed: ${response.statusCode}');
        print('<RotaryAreaService> Get RotaryArea By RoleId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryArea By AreaId >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryAreaByAreaId',
        name: 'RotaryAreaService',
        error: 'Get All RotaryArea By AreaId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryArea By AreaName [GET]
  // =========================================================
  Future getRotaryAreaByAreaName(String aAreaName) async {
    try {
      String _getUrlArea = GlobalsService.applicationServer + Constants.rotaryAreaUrl + "/areaName/$aAreaName";

      Response response = await get(_getUrlArea);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaName >>> OK >>> RotaryAreaFromJSON: $jsonResponse');

        var _area = jsonDecode(jsonResponse);
        RotaryAreaObject _areaObj = RotaryAreaObject.fromJson(_area);

        return _areaObj;
      } else {
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaName >>> Failed: ${response.statusCode}');
        print('<RotaryAreaService> Get RotaryArea By AreaName >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryArea By AreaName >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryAreaByAreaName',
        name: 'RotaryAreaService',
        error: 'Get All RotaryArea By AreaName >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Area

  //#region * Insert RotaryArea [WriteToDB]
  //=============================================================================
  Future insertRotaryArea(RotaryAreaObject aRotaryAreaObj) async {
    try {
      String _getUrlArea = GlobalsService.applicationServer + Constants.rotaryAreaUrl;

      String jsonToPost = aRotaryAreaObj.rotaryAreaObjectToJson(aRotaryAreaObj);

      Response response = await post(_getUrlArea, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryAreaService> Insert RotaryArea >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryAreaService> Insert RotaryArea >>> Failed');
          print('<RotaryAreaService> Insert RotaryArea >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryAreaService> Insert RotaryArea >>> Failed >>> ${response.statusCode}');
        print('<RotaryAreaService> Insert RotaryArea >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Insert RotaryArea >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryArea',
        name: 'RotaryAreaService',
        error: 'Insert RotaryArea >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update RotaryArea By AreaId [WriteToDB]
  //=============================================================================
  Future updateRotaryAreaByAreaId(RotaryAreaObject aRotaryAreaObj) async {
    try {
      String jsonToPost = aRotaryAreaObj.rotaryAreaObjectToJson(aRotaryAreaObj);

      String _updateUrlArea = GlobalsService.applicationServer + Constants.rotaryAreaUrl + "/${aRotaryAreaObj.areaId}";

      Response response = await put(_updateUrlArea, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryAreaService> Update RotaryArea By AreaId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log(
              '<RotaryAreaService> Update RotaryArea By AreaId >>> Failed');
          print('<RotaryAreaService> Update RotaryArea By AreaId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Update RotaryArea By AreaId >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryAreaByAreaId',
        name: 'RotaryAreaService',
        error: 'Update RotaryArea By AreaId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete RotaryArea By AreaId From DataBase [WriteToDB]
  //=============================================================================
  Future deleteRotaryAreaByAreaId(RotaryAreaObject aRotaryAreaObj) async {
    try {
      String _deleteUrlArea = GlobalsService.applicationServer + Constants.rotaryAreaUrl + "/${aRotaryAreaObj.areaId}";

      Response response = await delete(_deleteUrlArea, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryAreaService> Delete Rotary Area By AreaId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryAreaService> Delete Rotary Area By AreaId >>> Failed');
          print('<RotaryAreaService> Delete Rotary Area By AreaId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Delete Rotary Area By AreaId >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryAreaByAreaId',
        name: 'RotaryAreaService',
        error: 'Delete Rotary Area By AreaId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
