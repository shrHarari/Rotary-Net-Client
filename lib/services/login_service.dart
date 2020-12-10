import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/connected_login_object.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class LoginService {

  //#region * User Login Confirm At SERVER [POST]
  // ===============================================================
  Future<ConnectedLoginObject> userLoginConfirmAtServer(ConnectedUserObject aConnectedUserObj, {bool withPopulate = false}) async {
    try {
      ConnectedUserObject connectedUserObj;
      // Convert UserObject To Json
      final jsonToPost = aConnectedUserObj.connectedUserToJson(aConnectedUserObj);

      // Check If User Login Parameters are OK !!!
      String _getUrlConnectedUser;
      if (withPopulate) _getUrlConnectedUser = GlobalsService.applicationServer + Constants.rotaryUserUrl + "/loginPopulated";
      else _getUrlConnectedUser = GlobalsService.applicationServer + Constants.rotaryUserUrl + "/login";

      Response response = await post(_getUrlConnectedUser, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        if ((jsonResponse != '') && (jsonResponse != null))
        {
          await LoggerService.log('<LoginService> User Login Confirm At SERVER >>> OK\nHeader: $jsonResponse');
          // Return full UserObject (with User Name) ===>>> if Login Check OK
          var _connectedUser = jsonDecode(jsonResponse);

          connectedUserObj = ConnectedUserObject.fromJson(_connectedUser, withPopulate: withPopulate);

          int _roleEnumValue;
          Constants.RotaryRolesEnum _roleEnumDisplay;
          String _personCardPictureUrl = '';
          /// If a User does NOT have a PersonCard --->>> No personCardId will be in <connectedUserObj>
          if ((connectedUserObj.personCardId != null) && (connectedUserObj.personCardId != ''))
          {
            /// RoleEnum: fetch from json --->>> based on query type (?withPopulate)
            if (withPopulate) {
              _roleEnumValue = _connectedUser['personCardId']['roleId']['roleEnum'];
              /// RoleId: Convert [int] to [Enum]
              Constants.RotaryRolesEnum roleEnum;
              _roleEnumDisplay = roleEnum.convertToEnum(_roleEnumValue);
              _personCardPictureUrl = _connectedUser['personCardId']['pictureUrl'];
            }
          }

          return ConnectedLoginObject(
                connectedUserObject: connectedUserObj,
                rotaryRoleEnum: _roleEnumDisplay,
                personCardPictureUrl: _personCardPictureUrl
          );
        } else {
          await LoggerService.log('<LoginService> User Login Confirm At SERVER >>> Failed');
          print('<LoginService> User Login Confirm At SERVER >>> Failed');
          // Return Empty UserObject (without User Name)
          return null;  // ===>>> if Login Check Failed
        }
      } else {
        await LoggerService.log('<LoginService> User Login Confirm At SERVER >>> Failed: Could not Login >>> ${response.statusCode}');
        print('<LoginService> User Login Confirm At SERVER Failed >>> Could not Login >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<LoginService> User Login Confirm At SERVER >>> Server ERROR: ${e.toString()}');
      developer.log(
        'userLoginConfirmAtServer',
        name: 'LoginService',
        error: 'User Request >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion
}
