import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class ConnectedUserGlobal {

  static ConnectedUserObject currentConnectedUserObject;

  static final ConnectedUserGlobal _connectedUser = ConnectedUserGlobal._internal();

  ConnectedUserGlobal._internal();

  factory ConnectedUserGlobal() => _connectedUser;

  ConnectedUserObject getConnectedUserObject(){
    return currentConnectedUserObject;
  }

  setConnectedUserObject(ConnectedUserObject aConnectedUserObject){
    currentConnectedUserObject = aConnectedUserObject;
  }

  setConnectedUserType(Constants.UserTypeEnum aUserType){
    currentConnectedUserObject.userType = aUserType;
  }
}