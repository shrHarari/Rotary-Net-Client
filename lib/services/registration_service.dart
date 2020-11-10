import 'dart:async';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'dart:developer' as developer;

class RegistrationService {

  //#region * User Registration Add New User [POST]
  // ===============================================================
  Future<Map<String,dynamic>> userRegistrationAddNewUser(ConnectedUserObject aConnectedUserObj) async {
    try {
      Map<String,dynamic> mapResult;

      // Check if a User with a given EMAIl is Already EXIST
      UserObject userObj;
      UserService userService = UserService();
      userObj = await userService.getUserByEmail(aConnectedUserObj.email);
      if (userObj != null) {
        /// Return full UserObject ===>>> User Exist
        mapResult = {"returnCode": '100', "errorMessage": 'קיים משתמש עם דוא"ל זהה, נסה שוב...'};
      } else {
        /// Add New User - Create User
        UserObject userToAddObj = await UserObject.getUserObjectFromConnectedUserObject(aConnectedUserObj);
        dynamic _newUserJSON = await userService.insertUser(userToAddObj);
        if (_newUserJSON == null) {
          mapResult = {"returnCode": '200', "errorMessage": 'שגיאה ברישום, נסה שוב...'};
        } else {
          mapResult = {"returnCode": '0', "newUserObj": _newUserJSON};
        }
      }
      return mapResult;
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> User Registration Add New User >>> Server ERROR: ${e.toString()}');
      developer.log(
        'userRegistrationAddNewUser',
        name: 'RegistrationService',
        error: 'Add User >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

}
