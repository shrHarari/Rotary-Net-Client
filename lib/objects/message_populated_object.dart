import 'dart:convert';

class MessagePopulatedObject {
  String messageId;
  final String composerId;
  final String composerFirstName;
  final String composerLastName;
  final String composerEmail;
  final String messageText;
  final DateTime messageCreatedDateTime;
  final String areaId;
  final String areaName;
  final String clusterId;
  final String clusterName;
  final String clubId;
  final String clubName;
  final String clubAddress;
  final String clubMail;
  final String clubManagerId;
  final String roleId;
  final int roleEnum;
  final String roleName;
  final List<String> personCards;

  MessagePopulatedObject({
    this.messageId,
    this.composerId,
    this.composerFirstName,
    this.composerLastName,
    this.composerEmail,
    this.messageText,
    this.messageCreatedDateTime,
    this.areaId,
    this.areaName,
    this.clusterId,
    this.clusterName,
    this.clubId,
    this.clubName,
    this.clubAddress,
    this.clubMail,
    this.clubManagerId,
    this.roleId,
    this.roleEnum,
    this.roleName,
    this.personCards,
  });

  ///#region Set MessageId
  ///========================================
  Future <void> setMessageId(String aMessageId) async {
    messageId = aMessageId;
  }
  //#endregion

  MessagePopulatedObject.copy(MessagePopulatedObject uniqueObject) :
        messageId = uniqueObject.messageId,
        composerId = uniqueObject.composerId,
        composerFirstName = uniqueObject.composerFirstName,
        composerLastName = uniqueObject.composerLastName,
        composerEmail = uniqueObject.composerEmail,
        messageText = uniqueObject.messageText,
        messageCreatedDateTime = uniqueObject.messageCreatedDateTime,
        areaId = uniqueObject.areaId,
        areaName = uniqueObject.areaName,
        clusterId = uniqueObject.clusterId,
        clusterName = uniqueObject.clusterName,
        clubId = uniqueObject.clubId,
        clubName = uniqueObject.clubName,
        clubAddress = uniqueObject.clubAddress,
        clubMail = uniqueObject.clubMail,
        clubManagerId = uniqueObject.clubManagerId,
        roleId = uniqueObject.roleId,
        roleEnum = uniqueObject.roleEnum,
        roleName = uniqueObject.roleName,
        personCards = uniqueObject.personCards;

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
          ' ${this.messageId},'
          ' ${this.composerId},'
          ' ${this.composerFirstName},'
          ' ${this.composerLastName},'
          ' ${this.composerEmail},'
          ' ${this.messageText},'
          ' ${this.messageCreatedDateTime},'
          ' ${this.areaId},'
          ' ${this.areaName},'
          ' ${this.clusterId},'
          ' ${this.clusterName},'
          ' ${this.clubId},'
          ' ${this.clubName},'
          ' ${this.clubAddress},'
          ' ${this.clubMail},'
          ' ${this.clubManagerId},'
          ' ${this.roleId},'
          ' ${this.roleEnum},'
          ' ${this.roleName},'
          ' ${this.personCards},'
          '}';
  }

  //#region From Json All Populated [Message + Populate All Fields]
  factory MessagePopulatedObject.fromJsonAllPopulated(dynamic parsedJson){

    List<String> personCardsList;

    if (parsedJson['personCards'] != null) {
      var personCardsJson = parsedJson['personCards'] as List;
      personCardsList = personCardsJson.map((personCardJson) => personCardJson).toList().cast<String>();
    } else {
      personCardsList = [];
    }

    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(parsedJson['messageCreatedDateTime']);

    return MessagePopulatedObject(
      messageId: parsedJson['_id'],
      composerId: parsedJson['composerId']['_id'],
      composerFirstName: parsedJson['composerId']['firstName'],
      composerLastName: parsedJson['composerId']['lastName'],
      composerEmail: parsedJson['composerId']['email'],
      messageText: parsedJson['messageText'],
      messageCreatedDateTime: _messageCreatedDateTime,
      areaId: parsedJson['composerId']['areaId']['_id'],
      areaName: parsedJson['composerId']['areaId']['areaName'],
      clusterId: parsedJson['composerId']['clusterId']['_id'],
      clusterName: parsedJson['composerId']['clusterId']['clusterName'],
      clubId: parsedJson['composerId']['clubId']['_id'],
      clubName: parsedJson['composerId']['clubId']['clubName'],
      clubAddress: parsedJson['composerId']['clubId']['clubAddress'],
      clubMail: parsedJson['composerId']['clubId']['clubMail'],
      clubManagerId: parsedJson['composerId']['clubId']['clubManagerId'],
      roleId : parsedJson['composerId']['roleId']['_id'],
      roleEnum : parsedJson['composerId']['roleId']['roleEnum'],
      roleName: parsedJson['composerId']['roleId']['roleName'],
      personCards: personCardsList,
    );
  }
  //#endregion

  /// DataBase: Madel for MessageObject
  ///----------------------------------------------------
  MessagePopulatedObject messageObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return MessagePopulatedObject.fromMap(jsonData);
  }

  String messageObjectToJson(MessagePopulatedObject aMessagePopulatedObject) {
    final dyn = aMessagePopulatedObject.toMap();
    return json.encode(dyn);
  }

  factory MessagePopulatedObject.fromMap(Map<String, dynamic> jsonFromMap) {
    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(jsonFromMap['messageCreatedDateTime']);

    return MessagePopulatedObject(
      // messageId: jsonFromMap['_id'],
      composerId: jsonFromMap['composerId'],
      composerFirstName: jsonFromMap['composerFirstName'],
      composerLastName: jsonFromMap['composerLastName'],
      composerEmail: jsonFromMap['composerEmail'],
      messageText: jsonFromMap['messageText'],
      messageCreatedDateTime: _messageCreatedDateTime,
      areaId: jsonFromMap['areaId'],
      areaName: jsonFromMap['areaName'],
      clusterId: jsonFromMap['clusterId'],
      clusterName: jsonFromMap['clusterName'],
      clubId: jsonFromMap['clubId'],
      clubName: jsonFromMap['clubName'],
      clubAddress: jsonFromMap['clubAddress'],
      clubMail: jsonFromMap['clubMail'],
      clubManagerId: jsonFromMap['clubManagerId'],
      roleId: jsonFromMap['roleId'],
      roleEnum: jsonFromMap['roleEnum'],
      roleName: jsonFromMap['roleName'],
      personCards: jsonFromMap['personCards'],
    );
  }

  Map<String, dynamic> toMap() {
    // DateTime: Convert [DateTime] to [String]
    String _messageCreatedDateTime = messageCreatedDateTime.toIso8601String();

    return {
      if ((messageId != null) && (messageId != '')) '_id': messageId,
      'composerId': composerId,
      'composerFirstName': composerFirstName,
      'composerLastName': composerLastName,
      'composerEmail': composerEmail,
      'messageText': messageText,
      'messageCreatedDateTime': _messageCreatedDateTime,
      'areaId': areaId,
      'areaName': areaName,
      'clusterId': clusterId,
      'clusterName': clusterName,
      'clubId': clubId,
      'clubName': clubName,
      'clubAddress': clubAddress,
      'clubMail': clubMail,
      'clubManagerId': clubManagerId,
      'roleId': roleId,
      'roleEnum': roleEnum,
      'roleName': roleName,
      'personCards': personCards,
    };
  }
}
