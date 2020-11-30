import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class ConnectedLoginObject {
  final ConnectedUserObject connectedUserObject;
  final Constants.RotaryRolesEnum rotaryRoleEnum;
  final String personCardPictureUrl;

  ConnectedLoginObject({
    this.connectedUserObject,
    this.rotaryRoleEnum,
    this.personCardPictureUrl});
}