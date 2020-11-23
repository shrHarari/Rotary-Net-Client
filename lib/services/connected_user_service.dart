import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

class ConnectedUserService {
  static ConnectedUserObject connectedUserObject;

  static Future setConnectedUser(ConnectedUserObject aConnectedUserObject) async {
    connectedUserObject = aConnectedUserObject;
  }

  //#region Create User As Object
  //=============================================================================
  ConnectedUserObject createConnectedUserAsObject(
      String aUserId,
      String aPersonCardId,
      String aEmail,
      String aFirstName,
      String aLastName,
      String aPassword,
      Constants.UserTypeEnum aUserType,
      bool aStayConnected) {

    if (aEmail == null)
      return ConnectedUserObject(
          userId: '',
          personCardId: '',
          email: '',
          firstName: '',
          lastName: '',
          password: '',
          userType: Constants.UserTypeEnum.Guest,
          stayConnected: false);
    else
      return ConnectedUserObject(
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

  //#region Get ConnectedUserObject By Email
  // ===============================================================
  Future<ConnectedUserObject> getConnectedUserByEmail(String aEmail) async {
    try {
      UserObject userObj;
      ConnectedUserObject connectedUserObj;
      UserService userService = UserService();
      userObj = await userService.getUserByEmail(aEmail);
      if (userObj != null) {
        /// Create Connected User Object
        connectedUserObj = await ConnectedUserObject.getConnectedUserObjectFromUserObject(userObj);
      }
      return connectedUserObj;
    }
    catch (e) {
      await LoggerService.log('<ConnectedUserService> Get Connected User By Email >>> Server ERROR: ${e.toString()}');
      developer.log(
        'getConnectedUserByEmail',
        name: 'ConnectedUserService',
        error: 'Get Connected User By Email >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Connected User Object ==>> Secure Storage

  //#region Read Connected User Object Data From Secure Storage [ReadFromSS]
  //=============================================================================
  Future<ConnectedUserObject> readConnectedUserObjectDataFromSecureStorage() async {
    String _userId;
    String _personCardId;
    String _email;
    String _firstName;
    String _lastName;
    String _password;
    Constants.UserTypeEnum _userType;
    bool _stayConnected = false;

    try{
      final secureStorage = new FlutterSecureStorage();

      _userId = await secureStorage.read(key: Constants.rotaryUserId);
      _personCardId = await secureStorage.read(key: Constants.rotaryUserPersonCardId);
      _email = await secureStorage.read(key: Constants.rotaryUserEmail);
      _firstName = await secureStorage.read(key: Constants.rotaryUserFirstName);
      _lastName = await secureStorage.read(key: Constants.rotaryUserLastName);
      _password = await secureStorage.read(key: Constants.rotaryUserPassword);
      _userType = EnumToString.fromString(Constants.UserTypeEnum.values, await secureStorage.read(key: Constants.rotaryUserType));

      (await secureStorage.read(key: Constants.rotaryUserStayConnected) == "1")
          ? _stayConnected = true
          : _stayConnected = false;

      return createConnectedUserAsObject(
          _userId,
          _personCardId,
          _email,
          _firstName,
          _lastName,
          _password,
          _userType,
          _stayConnected);
    }
    catch  (e) {
      await LoggerService.log('<ConnectedUserService> Read Connected User Object Data From SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'readConnectedUserObjectDataFromSecureStorage',
        name: 'ConnectedUserService',
        error: 'Read Connected User Object Data From SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Connected User Object Data To Secure Storage [WriteToSS]
  //=============================================================================
  Future writeConnectedUserObjectDataToSecureStorage(ConnectedUserObject aConnectedUserObj) async {
    try{
      String _stayConnected;
      aConnectedUserObj.stayConnected ? _stayConnected = "1" : _stayConnected = "0";

      final secureStorage = new FlutterSecureStorage();

      if (aConnectedUserObj.userId != null) {
        await secureStorage.write(key: Constants.rotaryUserId, value: aConnectedUserObj.userId);
      }
      if (aConnectedUserObj.personCardId != null) {
        await secureStorage.write(key: Constants.rotaryUserPersonCardId, value: aConnectedUserObj.personCardId);
      }
      await secureStorage.write(key: Constants.rotaryUserEmail, value: aConnectedUserObj.email);
      await secureStorage.write(key: Constants.rotaryUserFirstName, value: aConnectedUserObj.firstName);
      await secureStorage.write(key: Constants.rotaryUserLastName, value: aConnectedUserObj.lastName);
      await secureStorage.write(key: Constants.rotaryUserPassword, value: aConnectedUserObj.password);
      await secureStorage.write(key: Constants.rotaryUserType, value: EnumToString.parse(aConnectedUserObj.userType));
      await secureStorage.write(key: Constants.rotaryUserStayConnected, value: _stayConnected);
    }
    catch  (e) {
      await LoggerService.log('<ConnectedUserService> Write Connected User Object Data To SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'writeConnectedUserObjectDataToSecureStorage',
        name: 'ConnectedUserService',
        error: 'Write Connected User Object Data To SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Connected User PersonCardId To Secure Storage [WriteToSS]
  //=============================================================================
  Future writeConnectedUserPersonCardIdToSecureStorage(String aPersonCardId) async {
    try{
      final secureStorage = new FlutterSecureStorage();
      await secureStorage.write(key: Constants.rotaryUserPersonCardId, value: aPersonCardId);
    }
    catch  (e) {
      await LoggerService.log('<ConnectedUserService> Write Connected User PersonCardId To SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'writeConnectedUserPersonCardIdToSecureStorage',
        name: 'ConnectedUserService',
        error: 'Write Connected User PersonCardId To SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Connected User Type To Secure Storage [WriteToSS]
  //=============================================================================
  Future writeConnectedUserTypeToSecureStorage(Constants.UserTypeEnum aUserType) async {
    try{
      final secureStorage = new FlutterSecureStorage();

      await secureStorage.write(key: Constants.rotaryUserType, value: EnumToString.parse(aUserType));
    }
    catch  (e) {
      await LoggerService.log('<ConnectedUserService> Write Connected User Type To SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'writeConnectedUserTypeToSecureStorage',
        name: 'ConnectedUserService',
        error: 'Write Connected User Type To SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

  //#region Rotary Role Enum Data ==>> Secure Storage

  //#region Read Rotary Role Enum Data From Secure Storage [ReadFromSS]
  //=============================================================================
  Future<Constants.RotaryRolesEnum> readRotaryRoleEnumDataFromSecureStorage() async {
    Constants.RotaryRolesEnum _rotaryRoleEnum;
    try{
      final secureStorage = new FlutterSecureStorage();
      _rotaryRoleEnum = EnumToString.fromString(Constants.RotaryRolesEnum.values, await secureStorage.read(key: Constants.rotaryRoleEnum));
      return _rotaryRoleEnum;
    }
    catch  (e) {
      await LoggerService.log('<ConnectedUserService> Read Rotary Role Enum Data From SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'readRotaryRoleEnumDataFromSecureStorage',
        name: 'ConnectedUserService',
        error: 'Read Rotary Role Enum Data From SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Rotary Role Enum Data To Secure Storage [WriteToSS]
  //=============================================================================
  Future writeRotaryRoleEnumDataToSecureStorage(Constants.RotaryRolesEnum aRotaryRolesEnum) async {
    try {
      final secureStorage = new FlutterSecureStorage();
      await secureStorage.write(key: Constants.rotaryRoleEnum, value: EnumToString.parse(aRotaryRolesEnum));
    }
    catch  (e) {
      await LoggerService.log('<ConnectedUserService> Write Rotary Role Enum Data To SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'writeRotaryRoleEnumDataToSecureStorage',
        name: 'ConnectedUserService',
        error: 'Write Rotary Role Enum Data To SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

  //#region Clear Data from Secure Storage

  //#region Clear Connected User Object Data From SecureStorage
  //=============================================================================
  Future clearConnectedUserObjectDataFromSecureStorage() async {
    try {
      final secureStorage = new FlutterSecureStorage();

      await secureStorage.delete(key: Constants.rotaryUserId);
      await secureStorage.delete(key: Constants.rotaryUserPersonCardId);
      await secureStorage.delete(key: Constants.rotaryUserEmail);
      await secureStorage.delete(key: Constants.rotaryUserFirstName);
      await secureStorage.delete(key: Constants.rotaryUserLastName);
      await secureStorage.delete(key: Constants.rotaryUserPassword);
      await secureStorage.delete(key: Constants.rotaryUserType);
      await secureStorage.delete(key: Constants.rotaryUserStayConnected);
      await secureStorage.delete(key: Constants.rotaryRoleEnum);
    }
    catch (e){
      await LoggerService.log('<ConnectedUserService> Clear Connected User Object Data From SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'clearConnectedUserObjectDataFromSecureStorage',
        name: 'ConnectedUserService',
        error: 'Clear Connected User Object Data From SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Exit From Application Update Secure Storage
  //=============================================================================
  Future exitFromApplicationUpdateSecureStorage() async {
    try {
      final secureStorage = new FlutterSecureStorage();
      await secureStorage.delete(key: Constants.rotaryUserStayConnected);
      await secureStorage.delete(key: Constants.rotaryRoleEnum);
    }
    catch (e){
      await LoggerService.log('<ConnectedUserService> Exit From Application Update SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'exitFromApplicationUpdateSecureStorage',
        name: 'ConnectedUserService',
        error: 'Exit From Application Update SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion
}
