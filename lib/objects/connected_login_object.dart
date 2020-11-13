import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class ConnectedLoginObject {
  final ConnectedUserObject connectedUserObject;
  final Constants.RotaryRolesEnum rotaryRoleEnum;

  ConnectedLoginObject({
    this.connectedUserObject,
    this.rotaryRoleEnum});
}