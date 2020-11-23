import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_populated_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/rotary_club_service.dart';
import 'package:rotary_net/services/rotary_cluster_service.dart';
import 'package:rotary_net/services/rotary_role_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class PersonCardService {

  //#region Create PersonCard As Object
  //=============================================================================
  PersonCardObject createPersonCardAsObject(
      String aPersonCardId,
      String aEmail,
      String aFirstName,
      String aLastName,
      String aFirstNameEng,
      String aLastNameEng,
      String aPhoneNumber,
      String aPhoneNumberDialCode,
      String aPhoneNumberParse,
      String aPhoneNumberCleanLongFormat,
      String aPictureUrl,
      String aCardDescription,
      String aInternetSiteUrl,
      String aAddress,
      String aAreaId,
      String aClusterId,
      String aClubId,
      String aRoleId,
      List<String> aMessages
      )
    {
      if (aPersonCardId == null)
        return PersonCardObject(
            personCardId: '',
            email: '',
            firstName: '',
            lastName: '',
            firstNameEng: '',
            lastNameEng: '',
            phoneNumber: '',
            phoneNumberDialCode: '',
            phoneNumberParse: '',
            phoneNumberCleanLongFormat: '',
            pictureUrl: '',
            cardDescription: '',
            internetSiteUrl: '',
            address: '',
            areaId: null,
            clusterId: null,
            clubId: null,
            roleId: null,
            messages: []
        );
      else
        return PersonCardObject(
            personCardId: aPersonCardId,
            email: aEmail,
            firstName: aFirstName,
            lastName: aLastName,
            firstNameEng: aFirstNameEng,
            lastNameEng: aLastNameEng,
            phoneNumber: aPhoneNumber,
            phoneNumberDialCode: aPhoneNumberDialCode,
            phoneNumberParse: aPhoneNumberParse,
            phoneNumberCleanLongFormat: aPhoneNumberCleanLongFormat,
            pictureUrl: aPictureUrl,
            cardDescription: aCardDescription,
            internetSiteUrl: aInternetSiteUrl,
            address: aAddress,
            areaId: aAreaId,
            clusterId: aClusterId,
            clubId: aClubId,
            roleId: aRoleId,
            messages: aMessages
        );
    }
  //#endregion

  //#region * Get PersonCards List By Search Query (w/o Populate) [GET]
  // ==================================================================
  Future getPersonCardsListBySearchQuery(String aValueToSearch, {bool withPopulate = false}) async {
    try {
      String _getUrlPersonCard;

      if (withPopulate) _getUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/query/$aValueToSearch/populated";
      else _getUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/query/$aValueToSearch";

      Response response = await get(_getUrlPersonCard);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCardsList By SearchQuery >>> OK\nHeader: $contentType \nPersonCardsListFromJSON: $jsonResponse');

        var personCardList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardObjList = personCardList.map((personCardJson) => PersonCardObject.fromJson(personCardJson)).toList();

        personCardObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

        return personCardObjList;
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCardsList By SearchQuery >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCardsList By SearchQuery >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCardsList By SearchQuery >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardsListBySearchQuery',
        name: 'PersonCardService',
        error: 'Get PersonCardsList By SearchQuery >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get PersonCards List By Role Hierarchy Permission [GET]
  // ==================================================================
  Future getPersonCardListByRoleHierarchyPermission(PersonCardRoleAndHierarchyIdObject aPersonCardRoleAndHierarchyIdObject) async {
    try {
      /// RoleEnum: Convert [int] to [EnumValue]
      Constants.RotaryRolesEnum _roleEnum;
      Constants.RotaryRolesEnum _roleEnumValue = _roleEnum.convertToEnum(aPersonCardRoleAndHierarchyIdObject.roleEnum);

      String _getUrl = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl;
      String _getUrlPersonCard;

      switch (_roleEnumValue) {
        case Constants.RotaryRolesEnum.RotaryManager:
          _getUrlPersonCard = _getUrl + "/roleHierarchyByAll";
          break;
        case Constants.RotaryRolesEnum.AreaManager:
          _getUrlPersonCard = _getUrl + "/roleHierarchyByAreaId/${aPersonCardRoleAndHierarchyIdObject.areaId}";
          break;
        case Constants.RotaryRolesEnum.ClusterManager:
          _getUrlPersonCard = _getUrl + "/roleHierarchyByClusterId/${aPersonCardRoleAndHierarchyIdObject.clusterId}";
          break;
        case Constants.RotaryRolesEnum.ClubManager:
          _getUrlPersonCard = _getUrl + "/roleHierarchyByClubId/${aPersonCardRoleAndHierarchyIdObject.clubId}";
          break;

        case Constants.RotaryRolesEnum.Gizbar:
        case Constants.RotaryRolesEnum.Member:
        default:
          return [];
      }
      Response response = await get(_getUrlPersonCard);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCardsList By Role Hierarchy Permission >>> OK\nHeader: $contentType \nPersonCardsListFromJSON: $jsonResponse');

        // var personCardsIdList = jsonDecode(jsonResponse) as List;
        List<dynamic> personCardsIdList = jsonDecode(jsonResponse) as List;

        return personCardsIdList;
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCardsList By Role Hierarchy Permission >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCardsList By Role Hierarchy Permission >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCardsList By Role Hierarchy Permission >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardListByRoleHierarchyPermission',
        name: 'PersonCardService',
        error: 'Get PersonCardsList By Role Hierarchy Permission >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get Person Card By PersonId [GET]
  // =========================================================
  Future getPersonCardByPersonId(String aPersonCardId, {bool withPopulate = false}) async {
    try {
      /// In case of User (Guest) without PersonCardObject ===>>> return Empty PersonCardObject
      if (aPersonCardId == null) return null;

      String _getUrlPersonCard;
      if (withPopulate) _getUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/populated";
      else _getUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId";

      Response response = await get(_getUrlPersonCard);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;

        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By PersonId >>> OK >>> PersonCardFromJSON: $jsonResponse');

          var _personCard = jsonDecode(jsonResponse);
          PersonCardObject _personObj = PersonCardObject.fromJson(_personCard);

          return _personObj;
        } else {
          await LoggerService.log('<PersonCardService>  Get PersonCard By PersonId >>> Failed');
          print('<PersonCardService>  Get PersonCard By PersonId >>> Failed');
          // Return Empty PersonCardObject
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By PersonId >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By PersonId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By PersonId >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByPersonId',
        name: 'PersonCardService',
        error: 'Get PersonCard By PersonId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get PersonCard By Id Populated [GET]
  // ========================================================================

  //#region Get PersonCard By Id Populated [PersonCard + Populate All Fields without Messages]
  Future getPersonCardByIdPopulated(String aPersonCardId) async {
    try {
      String _getUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/populated";
      Response response = await get(_getUrlPersonCard);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By Id Populated >>> OK >>> PersonCardPopulatedFromJSON: $jsonResponse');

          var _personCardPopulated = jsonDecode(jsonResponse);
          PersonCardPopulatedObject _personCardPopulatedObj = PersonCardPopulatedObject.fromJson(_personCardPopulated);

          return _personCardPopulatedObj;
        } else {
          await LoggerService.log('<PersonCardService>  Get PersonCard By Id Populated >>> Failed');
          print('<PersonCardService>  Get PersonCard By Id Populated >>> Failed');

          return null;  // Return Empty PersonCardObject
        }
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By Id Populated >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By Id Populated >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By Id Populated >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByIdPopulated',
        name: 'PersonCardService',
        error: 'Get PersonCard By Id Populated >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get PersonCard By Id Message Populated [PersonCard + Populate Only Messages List]
  Future getPersonCardByIdMessagePopulated(String aPersonCardId) async {
    try {
      if ((aPersonCardId == null) || (aPersonCardId == ''))  return null;

      String _getUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/message_populated";
      Response response = await get(_getUrlPersonCard);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By Id Message Populated >>> OK >>> JSON: $jsonResponse');

          var _personCardPopulated = jsonDecode(jsonResponse);
          var messagesObjectList;
          if (_personCardPopulated['messages'] != null) {
            messagesObjectList = _personCardPopulated['messages'] as List;
          } else {
            messagesObjectList = [];
          }

          return messagesObjectList;
        } else {
          await LoggerService.log('<PersonCardService>  Get PersonCard By Id Message Populated >>> Failed');
          print('<PersonCardService>  Get PersonCard By Id Message Populated >>> Failed');
          // Return Empty PersonCardObject
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By Id Message Populated >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By Id Message Populated >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By Id Message Populated >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByIdMessagePopulated',
        name: 'PersonCardService',
        error: 'Get PersonCard By Id Populated >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get PersonCard By Id All Populated [PersonCard + Populate All Fields]
  Future getPersonCardByIdAllPopulated(String aPersonCardId) async {
    try {
      String _getUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/all_populated";
      Response response = await get(_getUrlPersonCard);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By Id ALL Populated >>> OK >>> PersonCardPopulatedFromJSON: $jsonResponse');

          var _personCardPopulated = jsonDecode(jsonResponse);
          PersonCardPopulatedObject _personCardPopulatedObj = PersonCardPopulatedObject.fromJsonAllPopulated(_personCardPopulated);

          return _personCardPopulatedObj;
        } else {
          await LoggerService.log('<PersonCardService>  Get PersonCard By Id ALL Populated >>> Failed');
          print('<PersonCardService>  Get PersonCard By Id ALL Populated >>> Failed');
          // Return Empty PersonCardObject
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By Id ALL Populated >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By Id Populated >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By Id ALL Populated >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByIdAllPopulated',
        name: 'PersonCardService',
        error: 'Get PersonCard By Id ALL Populated >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

  //#region * Get Person Card By Id RoleEnum [GET]
  // =========================================================
  Future getPersonCardByIdRoleEnum(String aPersonCardId) async {
    try {
      /// In case of User (Guest) without PersonCardObject ===>>> return Empty PersonCardObject
      if (aPersonCardId == null) return null;

      String _getUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/roleEnum";
      Response response = await get(_getUrlPersonCard);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;

        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By Id RoleEnum >>> OK >>> PersonCardFromJSON: $jsonResponse');

          var _personCard = jsonDecode(jsonResponse);

          /// RoleEnum: fetch from json --->>> based on query type (?withPopulate)
          int _roleEnumValue;
          Constants.RotaryRolesEnum _roleEnumDisplay;
          _roleEnumValue = _personCard['roleId']["roleEnum"];
          /// RoleId: Convert [int] to [Enum]
          Constants.RotaryRolesEnum roleEnum;
          _roleEnumDisplay = roleEnum.convertToEnum(_roleEnumValue);

          return _roleEnumDisplay;
        } else {
          await LoggerService.log('<PersonCardService> Get PersonCard By Id RoleEnum >>> Failed');
          print('<PersonCardService>  Get PersonCard By Id RoleEnum >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By Id RoleEnum >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By Id RoleEnum >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By Id RoleEnum >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByIdRoleEnum',
        name: 'PersonCardService',
        error: 'Get PersonCard By Id RoleEnum >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Person Card

  //#region * Insert PersonCard [WriteToDB]
  //=============================================================================
  Future insertPersonCard(String aUserId, PersonCardObject aPersonCardObj) async {
    try {
      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);

      String _insertUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/userId/$aUserId";
      Response response = await post(_insertUrlPersonCard, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<PersonCardService> Insert PersonCard By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<PersonCardService> Insert PersonCard By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Insert PersonCard By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Insert PersonCard >>> ERROR: ${e.toString()}');
      developer.log(
        'insertPersonCard',
        name: 'PersonCardService',
        error: 'Insert PersonCard >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Insert PersonCard On InitializeDataBase [On Create DataBase]
  //=============================================================================
  Future insertPersonCardOnInitializeDataBase(PersonCardObject aPersonCardObj) async {
    try {
      /// Convert PersonCardObj.personCardId[InitValue] ===>>> User._id
      UserService userService = UserService();
      UserObject userObj;
      userObj = await userService.getUserByEmail(aPersonCardObj.email);

      /// Convert PersonCardObj.roleId[InitValue] ===>>> Role._id
      RotaryRoleService roleService = RotaryRoleService();
      RotaryRoleObject roleObj;
      roleObj = await roleService.getRotaryRoleByRoleEnum(int.parse(aPersonCardObj.roleId));
      aPersonCardObj.setRoleId(roleObj.roleId);

      /// Convert PersonCardObj.areaId[InitValue] ===>>> Area._id
      RotaryAreaService areaService = RotaryAreaService();
      RotaryAreaObject areaObj;
      areaObj = await areaService.getRotaryAreaByAreaName(aPersonCardObj.areaId);
      aPersonCardObj.setAreaId(areaObj.areaId);

      /// Convert PersonCardObj.clusterId[InitValue] ===>>> Cluster._id
      RotaryClusterService clusterService = RotaryClusterService();
      RotaryClusterObject clusterObj;
      clusterObj = await clusterService.getRotaryClusterByClusterName(aPersonCardObj.clusterId);
      aPersonCardObj.setClusterId(clusterObj.clusterId);

      /// Convert PersonCardObj.clubId[InitValue] ===>>> Club._id
      RotaryClubService clubService = RotaryClubService();
      RotaryClubObject clubObj;
      clubObj = await clubService.getRotaryClubByClubName(aPersonCardObj.clubId);
      aPersonCardObj.setClubId(clubObj.clubId);

      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);

      String _insertUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/userId/${userObj.userId}";
      Response response = await post(_insertUrlPersonCard, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<PersonCardService> Insert PersonCard OnInitialize DataBase >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<PersonCardService> Insert PersonCard By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Insert PersonCard By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Insert PersonCard >>> ERROR: ${e.toString()}');
      developer.log(
        'insertPersonCardOnInitializeDataBase',
        name: 'PersonCardService',
        error: 'Insert PersonCard >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update PersonCard By Id [WriteToDB]
  //=============================================================================
  Future updatePersonCardById(PersonCardObject aPersonCardObj) async {
    try {
      // Convert PersonCardObject To Json
      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);

      String _updateUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/${aPersonCardObj.personCardId}";

      Response response = await put(_updateUrlPersonCard, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<PersonCardService> Update PersonCard By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<PersonCardService> Update PersonCard By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Update PersonCard By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Update PersonCard By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'updatePersonCardById',
        name: 'PersonCardService',
        error: 'Update PersonCard By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update PersonCard Image Url By Id [WriteToDB]
  //=============================================================================
  Future updatePersonCardImageUrlById(String aPersonCardId, String aPersonCardImageUrl) async {
    try {
      Map bodyParams = {
        "personCardImageUrl": aPersonCardImageUrl
      };

      String _updateUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/$aPersonCardId/updateImage";

      Response response = await put(_updateUrlPersonCard, body: bodyParams);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<PersonCardService> Update PersonCard Image Url By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<PersonCardService> Update PersonCard Image Url By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Update PersonCard Image Url By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Update PersonCard Image Url By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'updatePersonCardImageUrlById',
        name: 'PersonCardService',
        error: 'Update PersonCard Image Url By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete PersonCard By Id [WriteToDB]
  //=============================================================================
  Future deletePersonCardById(PersonCardObject aPersonCardObj) async {
    try {
      String _deleteUrlPersonCard = GlobalsService.applicationServer + Constants.rotaryPersonCardUrl + "/${aPersonCardObj.personCardId}";

      Response response = await delete(_deleteUrlPersonCard, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<PersonCardService> Delete PersonCard By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<PersonCardService> Delete PersonCard By Id >>> Failed');
          print('<PersonCardService> Delete PersonCard By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Delete PersonCard By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Delete PersonCard By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Delete PersonCard By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'deletePersonCardById',
        name: 'PersonCardService',
        error: 'Delete PersonCard By Id From DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
