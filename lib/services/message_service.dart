import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class MessageService {

  //#region Create Message As Object
  //=============================================================================
  MessageObject createMessageAsObject(
      String aMessageId,
      String aComposerId,
      String aMessageText,
      DateTime aMessageCreatedDateTime,
      )
  {
    if (aMessageId == null)
      return MessageObject(
        messageId: '',
        composerId: '',
        messageText: '',
        messageCreatedDateTime: null,
      );
    else
      return MessageObject(
        messageId: aMessageId,
        composerId: aComposerId,
        messageText: aMessageText,
        messageCreatedDateTime: aMessageCreatedDateTime,
      );
  }
  //#endregion

  //#region Create Message Populated As Object
  //=============================================================================
  MessagePopulatedObject createMessagePopulatedAsObject(
      String aMessageId,
      String aComposerId,
      String aComposerFirstName,
      String aComposerLastName,
      String aComposerEmail,
      String aMessageText,
      DateTime aMessageCreatedDateTime,
      String aAreaId,
      String aAreaName,
      String aClusterId,
      String aClusterName,
      String aClubId,
      String aClubName,
      String aClubAddress,
      String aClubMail,
      String aClubManagerId,
      String aRoleId,
      int aRoleEnum,
      String aRoleName,
      List<String> aPersonCards,
      )
  {
    if (aMessageId == null)
      return MessagePopulatedObject(
        messageId: '',
        composerId: '',
        composerFirstName: '',
        composerLastName: '',
        composerEmail: '',
        messageText: '',
        messageCreatedDateTime: null,
        areaId: null,
        areaName: '',
        clusterId: null,
        clusterName: '',
        clubId: null,
        clubName: '',
        clubAddress: '',
        clubMail: '',
        clubManagerId: '',
        roleId: '',
        roleEnum: null,
        roleName: '',
        personCards: []
      );
    else
      return MessagePopulatedObject(
        messageId: aMessageId,
        composerId: aComposerId,
        composerFirstName: aComposerFirstName,
        composerLastName: aComposerLastName,
        composerEmail: aComposerEmail,
        messageText: aMessageText,
        messageCreatedDateTime: aMessageCreatedDateTime,
        areaId: aAreaId,
        areaName: aAreaName,
        clusterId: aClusterId,
        clusterName: aClusterName,
        clubId: aClubId,
        clubName: aClubName,
        clubAddress: aClubAddress,
        clubMail: aClubMail,
        clubManagerId: aClubManagerId,
        roleId: aRoleId,
        roleEnum: aRoleEnum,
        roleName: aRoleName,
        personCards: aPersonCards,
      );
  }
  //#endregion

  //#region * Get Messages List [GET]
  // =========================================================
  Future getMessagesList() async {
    try {
      String _getUrlMessage = GlobalsService.applicationServer + Constants.rotaryMessageUrl;
      Response response = await get(_getUrlMessage);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<MessageService> Get Messages List >>> OK\nHeader: $contentType \nMessagesListFromJSON: $jsonResponse');

        var messagesList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<MessageObject> messagesObjList = messagesList.map((messageJson) => MessageObject.fromJson(messageJson)).toList();

        return messagesObjList;
      } else {
        await LoggerService.log('<MessageService> Get Messages List >>> Failed: ${response.statusCode}');
        print('<MessageService> Get Messages List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesList',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get Messages List By Composer Id [GET]
  // =========================================================
  Future getMessagesListByComposerId(String aComposerId) async {
    try {
      String _getUrlMessage = GlobalsService.applicationServer + Constants.rotaryMessageUrl + "/composerId/$aComposerId";
      Response response = await get(_getUrlMessage);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<MessageService> Get Messages List By Composer Id >>> OK\nHeader: $contentType \nMessagesListFromJSON: $jsonResponse');

        var messagesList = jsonDecode(jsonResponse) as List;
        List<MessageObject> messagesObjList = messagesList.map((messageJson) => MessageObject.fromJson(messageJson)).toList();

        return messagesObjList;
      } else {
        await LoggerService.log('<MessageService> Get Messages List By Composer Id >>> Failed: ${response.statusCode}');
        print('<MessageService> Get Messages List By Composer Id >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List By Composer Id >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesListByComposerId',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get Messages List Populated By PersonCardId [GET]
  // =========================================================
  Future getMessagesListPopulatedByPersonCardId(String aPersonCardId) async {
    try {
      List<MessagePopulatedObject> messagesObjectList = [];

      /// In case of User (Guest) without PersonCardObject ===>>> return EmptyMessageList
      if (aPersonCardId == null) return messagesObjectList;

      PersonCardService personCardService = PersonCardService();
      List<dynamic> _messagesList = await personCardService.getPersonCardByIdMessagePopulated(aPersonCardId);

      if ((_messagesList != null) && (_messagesList.length > 0))
          messagesObjectList = _messagesList.map((parsedJson) =>
                MessagePopulatedObject.fromJsonAllPopulated(parsedJson)).toList();

      return messagesObjectList;
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List Populated By PersonCardId >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesListPopulatedByPersonCardId',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Messages

  //#region * Insert Message [WriteToDB]
  //=============================================================================
  Future insertMessage(MessageObject aMessageObj) async {
    try {
      String jsonToPost = aMessageObj.messageObjectToJson(aMessageObj);

      String _insertUrlMessage = GlobalsService.applicationServer + Constants.rotaryMessageUrl;
      Response response = await post(_insertUrlMessage, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        final Map parsedResponse = json.decode(jsonResponse);
        MessageObject insertedMessageObject = MessageObject.fromJson(parsedResponse);

        await LoggerService.log('<MessageService> Insert Message >>> OK');
        return insertedMessageObject;
      } else {
        await LoggerService.log('<MessageService> Insert Message >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Insert Message >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Insert Message >>> ERROR: ${e.toString()}');
      developer.log(
        'insertMessage',
        name: 'MessageService',
        error: 'Insert Message >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update Message By Id [WriteToDB]
  //=============================================================================
  Future updateMessageById(MessageObject aMessageObj) async {
    try {
      String jsonToPost = aMessageObj.messageObjectToJson(aMessageObj);

      String _updateUrlMessage = GlobalsService.applicationServer + Constants.rotaryMessageUrl + "/${aMessageObj.messageId}";
      Response response = await put(_updateUrlMessage, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<MessageService> Update Message By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<MessageService> Update Message By Id >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Update Message By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Update Message By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'updateMessageById',
        name: 'MessageService',
        error: 'Update Message By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete Message By Id [WriteToDB]
  //=============================================================================
  Future deleteMessageById(MessageObject aMessageObj) async {
    try {
      String _deleteUrlMessage = GlobalsService.applicationServer + Constants.rotaryMessageUrl + "/${aMessageObj.messageId}";
      Response response = await delete(_deleteUrlMessage, headers: Constants.rotaryUrlHeader);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<MessageService> Delete Message By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<MessageService> Delete Message By Id >>> Failed');
          print('<MessageService> Delete Message By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<MessageService> Delete Message By Id >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Delete Message By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Delete Message By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteMessageById',
        name: 'MessageService',
        error: 'Delete Message By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Remove Message From PersonCard MessageQueue [WriteToDB]
  //=============================================================================
  Future removeMessageFromPersonCardMessageQueue(MessageObject aMessageObj, String aPersonCardId) async {
    try {
      String _deleteUrlMessage = GlobalsService.applicationServer + Constants.rotaryMessageUrl + "/removeMessageQueue/${aMessageObj.messageId}/personCard/$aPersonCardId";
      Response response = await put(_deleteUrlMessage, headers: Constants.rotaryUrlHeader);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<MessageService> Delete Message From PersonCard MessageQueue >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<MessageService> Delete Message From PersonCard MessageQueue >>> Failed');
          print('<MessageService> Delete Message By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<MessageService> Delete Message From PersonCard MessageQueue >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Delete Message From PersonCard MessageQueue >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Delete Message From PersonCard MessageQueue >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteMessageFromPersonCardMessageQueue',
        name: 'MessageService',
        error: 'Delete Message From PersonCard MessageQueue >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion

  //#region * Add Message Back To PersonCard MessageQueue [GET]
  //=============================================================================
  Future addMessageBackToPersonCardMessageQueue(MessageObject aMessageObj, String aPersonCardId) async {
    try {
      String _addUrlMessage = GlobalsService.applicationServer + Constants.rotaryMessageUrl + "/addMessageQueue/${aMessageObj.messageId}/personCard/$aPersonCardId";
      Response response = await put(_addUrlMessage, headers: Constants.rotaryUrlHeader);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<MessageService> Insert Message Back To MessageQueue >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<MessageService> Insert Message Back To MessageQueue >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Insert Message Back To MessageQueue >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Insert Message Back To MessageQueue >>> ERROR: ${e.toString()}');
      developer.log(
        'insertMessageBackToMessageQueue',
        name: 'MessageService',
        error: 'Insert Message Back To MessageQueue >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion

//#endregion
}
