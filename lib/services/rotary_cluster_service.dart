import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class RotaryClusterService {

  //#region Create RotaryCluster As Object
  //=============================================================================
  RotaryClusterObject createRotaryClusterAsObject(
      String aClusterId, String aClusterName,)
  {
      return RotaryClusterObject(
        clusterId: aClusterId,
        clusterName: aClusterName,
      );
  }
  //#endregion

  //#region * Get All RotaryCluster List (w/o Clubs) [GET]
  // =========================================================
  Future getAllRotaryClusterList({bool withPopulate = false}) async {
    try {
      String _getUrlCluster;

      if (withPopulate) _getUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl + "/withClubs";
      else _getUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl;

      Response response = await get(_getUrlCluster);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClusterService> Get All Rotary Cluster List >>> OK\nHeader: $contentType \nRotaryClusterListFromJSON: $jsonResponse');

        var clustersList = jsonDecode(jsonResponse) as List;
        List<RotaryClusterObject> clustersObjList = clustersList.map((clusterJson) => RotaryClusterObject.fromJson(clusterJson)).toList();

        return clustersObjList;
      } else {
        await LoggerService.log('<RotaryClusterService> Get All RotaryCluster List >>> Failed: ${response.statusCode}');
        print('<RotaryClusterService> Get All RotaryCluster List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Get All RotaryCluster List >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryClusterList',
        name: 'RotaryClusterService',
        error: 'Get All RotaryCluster List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryCluster By ClusterId (w/o Clubs) [GET]
  // =========================================================
  Future getRotaryClusterByClusterId(String aClusterId, {bool withPopulate = false}) async {
    try {
      String _getUrlCluster;

      if (withPopulate) _getUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl + "/withClubs/$aClusterId";
      else _getUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl + "/$aClusterId";

      Response response = await get(_getUrlCluster);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterId >>> OK >>> RotaryClusterFromJSON: $jsonResponse');

        var _cluster = jsonDecode(jsonResponse);
        RotaryClusterObject _clusterObj = RotaryClusterObject.fromJson(_cluster);

        return _clusterObj;
      } else {
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterId >>> Failed: ${response.statusCode}');
        print('<RotaryClusterService> Get ClusterId By RoleId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Get All RotaryCluster By ClusterId >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryClusterByClusterId',
        name: 'RotaryClusterService',
        error: 'Get All RotaryCluster By ClusterId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryCluster By ClusterName [GET]
  // =========================================================
  Future getRotaryClusterByClusterName(String aClusterName) async {
    try {
      String _getUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl + "/clusterName/$aClusterName";

      Response response = await get(_getUrlCluster);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterName >>> OK >>> RotaryClusterFromJSON: $jsonResponse');

        var _cluster = jsonDecode(jsonResponse);
        RotaryClusterObject _clusterObj = RotaryClusterObject.fromJson(_cluster);

        return _clusterObj;
      } else {
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterName >>> Failed: ${response.statusCode}');
        print('<RotaryClusterService> Get RotaryCluster By ClusterName >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterName >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryClusterByClusterName',
        name: 'RotaryClusterService',
        error: 'Get RotaryCluster By ClusterName >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Cluster

  //#region * Insert RotaryCluster [WriteToDB]
  //=============================================================================
  Future insertRotaryCluster(RotaryClusterObject aRotaryClusterObj) async {
    try{
      String jsonToPost = aRotaryClusterObj.rotaryClusterObjectToJson(aRotaryClusterObj);

      String _insertUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl;
      Response response = await post(_insertUrlCluster, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClusterService> Insert RotaryCluster >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClusterService> Insert RotaryCluster >>> Failed');
          print('<RotaryClusterService> Insert RotaryCluster >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryClusterService> Insert RotaryCluster >>> Failed >>> ${response.statusCode}');
        print('<RotaryClusterService> Insert RotaryCluster >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Insert RotaryCluster >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryCluster',
        name: 'RotaryClusterService',
        error: 'Insert RotaryCluster >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Insert RotaryCluster With Area [WriteToDB]
  //=============================================================================
  Future insertRotaryClusterWithArea(String aAreaId, RotaryClusterObject aRotaryClusterObj) async {
    try{
      String jsonToPost = aRotaryClusterObj.rotaryClusterObjectToJson(aRotaryClusterObj);

      String _insertUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl + "/areaId/$aAreaId";
      Response response = await post(_insertUrlCluster, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClusterService> Insert RotaryCluster WithArea >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClusterService> Insert RotaryCluster WithArea >>> Failed');
          print('<RotaryClusterService> Insert RotaryCluster WithArea >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryClusterService> Insert RotaryCluster WithArea >>> Failed >>> ${response.statusCode}');
        print('<RotaryClusterService> Insert RotaryCluster WithArea >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Insert RotaryCluster WithArea >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryClusterWithArea',
        name: 'RotaryClusterService',
        error: 'Insert RotaryCluster WithArea >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update RotaryCluster By ClusterId [WriteToDB]
  //=============================================================================
  Future updateRotaryClusterByClusterId(RotaryClusterObject aRotaryClusterObj) async {
    try {
      String jsonToPost = aRotaryClusterObj.rotaryClusterObjectToJson(aRotaryClusterObj);

      String _updateUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl + "/${aRotaryClusterObj.clusterId}";

      Response response = await put(_updateUrlCluster, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClusterService> Update RotaryCluster By ClusterId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClusterService> Update RotaryCluster By ClusterId >>> Failed');
          print('<RotaryClusterService> Update RotaryCluster By ClusterId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Update RotaryCluster By ClusterId >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryClusterByClusterId',
        name: 'RotaryClusterService',
        error: 'Update RotaryCluster By ClusterId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete RotaryCluster By ClusterId [WriteToDB]
  //=============================================================================
  Future deleteRotaryClusterByClusterId(RotaryClusterObject aRotaryClusterObj) async {
    try {
      String _deleteUrlCluster = GlobalsService.applicationServer + Constants.rotaryClusterUrl + "/${aRotaryClusterObj.clusterId}";

      Response response = await delete(_deleteUrlCluster, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClusterService> Delete Rotary Cluster By ClusterId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClusterService> Delete Rotary Cluster By ClusterId >>> Failed');
          print('<RotaryClusterService> Delete Rotary Cluster By ClusterId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Delete Rotary Cluster By ClusterId >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryClusterByClusterId',
        name: 'RotaryClusterService',
        error: 'Delete Rotary Cluster By ClusterId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion

  //#endregion

}
