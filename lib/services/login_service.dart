import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class LoginService {

  //#region * User Login Confirm At SERVER [POST]
  // ===============================================================
  Future<ConnectedUserObject> userLoginConfirmAtServer(ConnectedUserObject aConnectedUserObj) async {
    try {
      ConnectedUserObject connectedUserObj;
      // Convert UserObject To Json
      final jsonToPost = aConnectedUserObj.connectedUserToJson(aConnectedUserObj);

      // Check If User Login Parameters are OK !!!
      String _getUrlConnectedUser = GlobalsService.applicationServer + Constants.rotaryUserLoginUrl;
      Response response = await post(_getUrlConnectedUser, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        if (jsonResponse != "")
        {
          await LoggerService.log('<RegistrationService> User Login Confirm At SERVER >>> OK\nHeader: $jsonResponse');
          // Return full UserObject (with User Name) ===>>> if Login Check OK
          var _connectedUser = jsonDecode(jsonResponse);

          connectedUserObj = ConnectedUserObject.fromJson(_connectedUser);
          return connectedUserObj;
        } else {
          await LoggerService.log('<RegistrationService> User Login Confirm At SERVER >>> Failed');
          print('<RegistrationService> User Login Confirm At SERVER >>> Failed');
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
