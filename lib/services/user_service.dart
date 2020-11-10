import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class UserService {

  //#region Create User As Object
  //=============================================================================
  UserObject createUserAsObject(
      String aUserId,
      String aPersonCardId,
      String aEmail,
      String aFirstName,
      String aLastName,
      String aPassword,
      Constants.UserTypeEnum aUserType,
      bool aStayConnected) {

    if (aEmail == null)
      return UserObject(
          userId: '',
          personCardId: '',
          email: '',
          firstName: '',
          lastName: '',
          password: '',
          userType: Constants.UserTypeEnum.Guest,
          stayConnected: false);
    else
      return UserObject(
          userId: aUserId,
          personCardId: aPersonCardId,
          email: aEmail,
          firstName: aFirstName,
          lastName: aLastName,
          password: aPassword,
          userType: aUserType,
          stayConnected: aStayConnected);
  }
  //#endregion

  //#region * Get All Users List [GET]
  // =========================================================
  Future getAllUsersList() async {
    try {
      Response response = await get(Constants.rotaryUserUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<UserService> Get All Users List >>> OK\nHeader: $contentType \nUserListFromJSON: $jsonResponse');

        var userList = jsonDecode(jsonResponse) as List;
        List<UserObject> userObjList = userList.map((userJson) => UserObject.fromJson(userJson)).toList();

        userObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

        return userObjList;
      } else {
        await LoggerService.log('<UserService> Get Users Lis >>> Failed: ${response.statusCode}');
        print('<UserService> Get Users Lis >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Get Users List >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllUsersList',
        name: 'UserService',
        error: 'Users List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get User By SearchQuery
  Future getUsersListBySearchQuery(String aValueToSearch) async {

    try {
      String _getUrl = Constants.rotaryUserUrl + "/query/$aValueToSearch";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<UserService> Get User By SearchQuery >>> OK\nHeader: $contentType \nUserListFromJSON: $jsonResponse');

        var userList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<UserObject> userObjList = userList.map((userJson) => UserObject.fromJson(userJson)).toList();

        userObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

        return userObjList;
      } else {
        await LoggerService.log('<UserService> Get User By SearchQuery >>> Failed: ${response.statusCode}');
        print('<UserService> Get User By SearchQuery >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Get User By SearchQuery >>> ERROR: ${e.toString()}');
      developer.log(
        'getUsersListBySearchQuery',
        name: 'UserService',
        error: 'User Object >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get User By Email
  Future<UserObject> getUserByEmail(String aEmail) async {

    try {
      String _getUrl = Constants.rotaryUserUrl + "/email/$aEmail";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;

        if (jsonResponse != "")
        {
          // Return full UserObject ===>>> Check User by email >>> Success
          await LoggerService.log('<UserService> Get User By Email >>> OK >>> UserListFromJSON: $jsonResponse');

          var _user = jsonDecode(jsonResponse);
          UserObject _userObj = UserObject.fromJson(_user);

          return _userObj;
        } else {
          // Return Empty UserObject
          return null;  // ===>>> Check User by email >>> No User
        }
      } else {
        await LoggerService.log('<UserService> Get User By Email >>> Failed: ${response.statusCode}');
        print('<UserService> Get User By Email >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Get User By Email >>> ERROR: ${e.toString()}');
      developer.log(
        'get User By Email',
        name: 'UserService',
        error: 'User Object >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Users

  //#region * Insert User [WriteToDB]
  //=============================================================================
  Future insertUser(UserObject aUserObj) async {
    try {
      String jsonToPost = aUserObj.userToJson(aUserObj);

      Response response = await post(Constants.rotaryUserUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<UserService> Insert User >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<UserService> Insert User >>> Failed >>> ${response.statusCode}');
        print('<UserService> Insert User >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Insert User >>> Server ERROR: ${e.toString()}');
      developer.log(
        'insertUser',
        name: 'UserService',
        error: 'Insert User >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update User By Id [WriteToDB]
  //=============================================================================
  Future updateUserById(UserObject aUserObj) async {
    try {
      // Convert ConnectedUserObject To Json
      String jsonToPost = aUserObj.userToJson(aUserObj);

      String _updateUrl = Constants.rotaryUserUrl + "/${aUserObj.userId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<UserService> Update User By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<UserService> Update User By Id >>> Failed >>> ${response.statusCode}');
        print('<UserService> Update User By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Update User By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'updateUserById',
        name: 'UserService',
        error: 'Update User By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete User By Id [WriteToDB]
  //=============================================================================
  Future deleteUserById(UserObject aUserObj) async {
    try {
      String _deleteUrl = Constants.rotaryUserUrl + "/${aUserObj.userId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<UserService> Delete User By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<UserService> Delete User By Id >>> Failed');
          print('<UserService> Delete User By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<UserService> Delete User By Id >>> Failed >>> ${response.statusCode}');
        print('<UserService> Delete User By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Delete User By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteUserById',
        name: 'UserService',
        error: 'Delete User By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion
}
