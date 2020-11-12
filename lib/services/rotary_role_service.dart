import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class RotaryRoleService {

  //#region Create RotaryRole As Object
  //=============================================================================
  RotaryRoleObject createRotaryRoleAsObject(
      String aRoleId,
      int aRoleEnum,
      String aRoleName,
      )
  {
    if (aRoleId == null)
      return RotaryRoleObject(
        roleId: '0',
        roleEnum: 0,
        roleName: '',
      );
    else
      return RotaryRoleObject(
        roleId: aRoleId,
        roleEnum: aRoleEnum,
        roleName: aRoleName,
      );
  }
  //#endregion

  //#region * Get All RotaryRoles List [GET]
  // =========================================================
  Future getAllRotaryRolesList() async {
    try {
      String _getUrlRole = GlobalsService.applicationServer + Constants.rotaryRoleUrl;
      Response response = await get(_getUrlRole);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryRoleService> Get All Rotary Roles List >>> OK\nHeader: $contentType \nRotaryRoleListFromJSON: $jsonResponse');

        var rolesList = jsonDecode(jsonResponse) as List;
        List<RotaryRoleObject> rolesObjList = rolesList.map((roleJson) => RotaryRoleObject.fromJson(roleJson)).toList();

        return rolesObjList;
      } else {
        await LoggerService.log('<RotaryRoleService> Get All RotaryRoles List >>> Failed: ${response.statusCode}');
        print('<RotaryRoleService> Get All RotaryRoles List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Get All RotaryRoles List >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryRolesList',
        name: 'RotaryRoleService',
        error: 'Get All RotaryRoles List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryRole By RoleId [GET]
  // =========================================================
  Future getRotaryRoleByRoleId(String aRoleId) async {
    try {
      String _getUrlRole = GlobalsService.applicationServer + Constants.rotaryRoleUrl + "/$aRoleId";

      Response response = await get(_getUrlRole);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleId >>> OK >>> RotaryRoleFromJSON: $jsonResponse');

        var _role = jsonDecode(jsonResponse);
        RotaryRoleObject _roleObj = RotaryRoleObject.fromJson(_role);

        return _roleObj;
      } else {
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleId >>> Failed: ${response.statusCode}');
        print('<RotaryRoleService> Get RotaryRole By RoleId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Get Get RotaryRole By RoleId >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryRoleByRoleId',
        name: 'RotaryRoleService',
        error: 'Get RotaryRole By RoleId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryRole By RoleEnum [GET]
  // =========================================================

  Future getRotaryRoleByRoleEnum(int aRoleEnum) async {
    try {
      String _getUrlRole = GlobalsService.applicationServer + Constants.rotaryRoleUrl + "/roleEnum/$aRoleEnum";
      Response response = await get(_getUrlRole);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleEnum >>> OK >>> RotaryRoleFromJSON: $jsonResponse');

        var _role = jsonDecode(jsonResponse);
        RotaryRoleObject _roleObj = RotaryRoleObject.fromJson(_role);

        return _roleObj;
      } else {
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleEnum >>> Failed: ${response.statusCode}');
        print('<RotaryRoleService> Get RotaryRole By RoleEnum >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Get Get RotaryRole By RoleEnum >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryRoleByRoleEnum',
        name: 'RotaryRoleService',
        error: 'Get RotaryRole By RoleEnum >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: RotaryRole

  //#region * Insert RotaryRole [WriteToDB]
  //=============================================================================
  Future insertRotaryRole(RotaryRoleObject aRotaryRoleObj) async {
    try {
      String _getUrlRole = GlobalsService.applicationServer + Constants.rotaryRoleUrl;

      String jsonToPost = aRotaryRoleObj.rotaryRoleObjectToJson(aRotaryRoleObj);

      Response response = await post(_getUrlRole, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryRoleService> Insert RotaryRole >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryRoleService> Insert RotaryRole >>> Failed');
          print('<RotaryRoleService> Insert RotaryRole >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryRoleService> Insert RotaryRole >>> Failed >>> ${response.statusCode}');
        print('<RotaryRoleService> Insert RotaryRole >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Insert RotaryRole >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryRole',
        name: 'RotaryRoleService',
        error: 'Insert RotaryRole >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update RotaryRole By RoleId [WriteToDB]
  //=============================================================================
  Future updateRotaryRoleByRoleId(RotaryRoleObject aRotaryRoleObj) async {
    try {
      String jsonToPost = aRotaryRoleObj.rotaryRoleObjectToJson(aRotaryRoleObj);

      String _updateUrlRole = GlobalsService.applicationServer + Constants.rotaryRoleUrl + "/${aRotaryRoleObj.roleId}";

      Response response = await put(_updateUrlRole, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryRoleService> Update RotaryRole By RoleId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log(
              '<RotaryRoleService> Update RotaryRole By RoleId >>> Failed');
          print('<RotaryRoleService> Update RotaryRole By RoleId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Update RotaryRole By RoleId >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryRoleByRoleId',
        name: 'RotaryRoleService',
        error: 'Update RotaryRole By RoleId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete RotaryRole By RoleId [WriteToDB]
  //=============================================================================
  Future deleteRotaryRoleByRoleId(RotaryRoleObject aRotaryRoleObj) async {
    try {
      String _deleteUrlRole = GlobalsService.applicationServer + Constants.rotaryRoleUrl + "/${aRotaryRoleObj.roleId}";

      Response response = await delete(_deleteUrlRole, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryRoleService> Delete RotaryRole By RoleId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryRoleService> Delete RotaryRole By RoleId >>> Failed');
          print('<RotaryRoleService> Delete RotaryRole By RoleId >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<UserService> Delete RotaryRole By RoleId >>> Failed >>> ${response.statusCode}');
        print('<UserService> Delete RotaryRole By RoleId >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Delete Rotary Role By RoleId >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryRoleByRoleId',
        name: 'RotaryRoleService',
        error: 'Delete Rotary Role By RoleId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
