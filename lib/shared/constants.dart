
//#region Application Global Parameters
// ==============================================================

const String rotaryApplicationName = 'מועדון רוטרי';
const String rotaryApplicationLogo = 'assets/app_icon/RotaryNetLogo.png';
const String rotaryMainScreenBackground = 'assets/background/main_screen.jpg';
//#endregion

//#region Application Parameters: SharedPreferences [Key Name]
// ==============================================================
const String rotaryApplicationRunningMode = 'Rotary Running Mode';
const String rotaryApplicationType = 'Rotary Application Mode';
//#endregion

//#region Application parameters [Globals Values]
// ==============================================================
const String rotaryLoggerFileName = 'Rotary_Log.txt';
const String rotaryEventImageDefaultFolder = 'assets/images/event_images';
const String rotaryPersonCardImageDefaultFolder = 'assets/images/person_card_images';
const String rotaryPersonCardImagesFolderName = 'PersonCardImages';
const String rotaryEventImagesFolderName = 'EventImages';
//#endregion

//#region Server URL
// ==============================================================
const Map<String, String> rotaryUrlHeader = {"Content-type": "application/json"};

/////// --->>> localhost = 10.100.102.6 [by using ipconfig <command on cmd>]
const String CLIENT_HOST_URL = 'http://10.100.102.6:3030';
const String SERVER_HOST_URL = 'https://rotary-net.herokuapp.com';

const String rotaryRoleUrl = '/api/role';
const String rotaryAreaUrl = '/api/area';
const String rotaryClusterUrl = '/api/cluster';
const String rotaryClubUrl = '/api/club';
const String rotaryUserUrl = '/api/user';
const String rotaryPersonCardUrl = '/api/personcard';
const String rotaryEventUrl = '/api/event';
const String rotaryMessageUrl = '/api/message';

// const String rotaryUserLoginUrl = '/api/user/login';

const String rotaryMenuPagesContentUrl = '/api/menupage';
const String rotaryUtilUrl = '/api/util';
const String rotaryAwsUrl = '/api/aws';

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
const String rotaryPersonCardAvatarImageUrl = 'Rotary PersonCard Avatar Image Url';
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
const String rotaryRoleEnum = 'Rotary Role Enum';
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