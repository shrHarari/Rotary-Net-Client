import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class ConnectedUserGlobal {

  static ConnectedUserObject currentConnectedUserObject;
  static Constants.RotaryRolesEnum currentRotaryRoleEnum;
  static String currentPersonCardAvatarImageUrl;

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

  setConnectedPersonCardId(String aPersonCardId){
    currentConnectedUserObject.personCardId = aPersonCardId;
  }

  Constants.RotaryRolesEnum getRotaryRoleEnum(){
    return currentRotaryRoleEnum;
  }

  setRotaryRoleEnum(Constants.RotaryRolesEnum aRotaryRolesEnum){
    currentRotaryRoleEnum = aRotaryRolesEnum;
  }

  String getPersonCardAvatarImageUrl(){
    return currentPersonCardAvatarImageUrl;
  }

  setPersonCardAvatarImageUrl(String aPersonCardAvatarImageUrl){
    currentPersonCardAvatarImageUrl = aPersonCardAvatarImageUrl;
  }
}