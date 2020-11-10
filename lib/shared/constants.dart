
//#region Application Global Parameters
// ==============================================================
const String rotaryApplicationName = 'מועדון רוטרי';
//#endregion

//#region Application Parameters: SharedPreferences [Key Name]
// ==============================================================
const String rotaryDebugMode = 'Rotary Debug Mode';
//#endregion

//#region Application parameters [Globals Values]
// ==============================================================
const String rotaryLoggerFileName = 'Rotary_Log.txt';
const String rotaryFolderPersonCardImages = 'assets/images/person_card_images';
const String rotaryFolderEventImages = 'assets/images/event_images';
//#endregion

//#region Server URL
// ==============================================================
const Map<String, String> rotaryUrlHeader = {"Content-type": "application/json"};

/////// const String rotaryUserUrl = 'http://localhost:3030/api/user/';
/////// ----------------------- localhost = 10.100.102.6 [using ipconfig <command on cmd>]

const String rotaryLocalHost = 'http://10.100.102.6:3030';
// const String rotaryLocalHost = 'file:///C:/FLUTTER_OCTIA/rotary_net_server/server';
// const String rotaryLocalHost = 'C:/FLUTTER_OCTIA/rotary_net_server/server';
// const String rotaryLocalHost = 'http://localhost:3030';
// const String rotaryLocalHost = 'http://localhost';
const String rotaryRoleUrl = 'http://10.100.102.6:3030/api/role';
const String rotaryAreaUrl = 'http://10.100.102.6:3030/api/area';
const String rotaryClusterUrl = 'http://10.100.102.6:3030/api/cluster';
const String rotaryClubUrl = 'http://10.100.102.6:3030/api/club';
const String rotaryUserUrl = 'http://10.100.102.6:3030/api/user';
const String rotaryPersonCardUrl = 'http://10.100.102.6:3030/api/personcard';
const String rotaryEventUrl = 'http://10.100.102.6:3030/api/event';
const String rotaryMessageUrl = 'http://10.100.102.6:3030/api/message';

const String rotaryUserLoginUrl = 'http://10.100.102.6:3030/api/user/login';

const String rotaryMenuPagesContentUrl = 'http://10.100.102.6:3030/api/menupage';
const String rotaryUtilContentUrl = 'http://10.100.102.6:3030/api/util';

//#endregion

//#region User Data: Secure Storage [Key Name]
// ==============================================================
const String rotaryUserId = 'Rotary User Guid ID';
const String rotaryUserPersonCardId = 'Rotary User Person Card ID';
const String rotaryUserEmail = 'Rotary User Email';
const String rotaryUserFirstName = 'Rotary User First Name';
const String rotaryUserLastName = 'Rotary User Family Name';
const String rotaryUserPassword = 'Rotary User Password';
const String rotaryUserStayConnected = 'Rotary User StayConnected';
//#endregion

//#region UserType [Key Name]+[Enum]
// ==============================================================
const String rotaryUserType = 'Rotary User Type';
enum UserTypeEnum{SystemAdmin, RotaryMember, Guest}
//#endregion

//#region SearchType [Enum]
// ==============================================================
enum SearchTypeEnum{PersonCard, Event}
//#endregion

//#region RotaryRoles [Key Name]+[Enum]
// ==============================================================
enum RotaryRolesEnum{RotaryManager, Gizbar, AreaManager, ClusterManager, ClubManager, Member}

extension RotaryRolesEnumExtension on RotaryRolesEnum {
  int get value {
    switch (this) {
      case RotaryRolesEnum.RotaryManager:
        return 1;
      case RotaryRolesEnum.Gizbar:
        return 2;
      case RotaryRolesEnum.AreaManager:
        return 3;
      case RotaryRolesEnum.ClusterManager:
        return 4;
      case RotaryRolesEnum.ClubManager:
        return 5;
      case RotaryRolesEnum.Member:
        return 6;
      default:
        return null;
    }
  }

  String get description {
    switch (this) {
      case RotaryRolesEnum.RotaryManager:
        return "יושב ראש";
      case RotaryRolesEnum.Gizbar:
        return "גזבר";
      case RotaryRolesEnum.AreaManager:
        return "מזכיר אזור";
      case RotaryRolesEnum.ClusterManager:
        return "מזכיר אשכול";
      case RotaryRolesEnum.ClubManager:
        return "מזכיר מועדון";
      case RotaryRolesEnum.Member:
        return "חבר";
      default:
        return null;
    }
  }

  RotaryRolesEnum convertToEnum(int aValue) {
    switch (aValue) {
      case 1:
        return RotaryRolesEnum.RotaryManager;
      case 2:
        return RotaryRolesEnum.Gizbar;
      case 3:
        return RotaryRolesEnum.AreaManager;
      case 4:
        return  RotaryRolesEnum.ClusterManager;
      case 5:
        return   RotaryRolesEnum.ClubManager;
      case 6:
        return  RotaryRolesEnum.Member;
      default:
        return null;
    }
  }

  /////////////// How to Use: /////////////////////
  // RotaryRolesEnum rotaryRolesEnum = RotaryRolesEnum.RotaryManager;
  // String roleDescription = rotaryRolesEnum.description;
  // rotaryRolesEnum.display();
}
//#endregion