import 'dart:convert';
import 'package:rotary_net/objects/message_object.dart';

class PersonCardPopulatedObject {
  final String personCardId;
  final String email;
  final String firstName;
  final String lastName;
  final String firstNameEng;
  final String lastNameEng;
  final String phoneNumber;
  final String phoneNumberDialCode;
  final String phoneNumberParse;
  final String phoneNumberCleanLongFormat;
  final String pictureUrl;
  final String cardDescription;
  final String internetSiteUrl;
  final String address;
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
  List<MessageObject> messagesList;

  PersonCardPopulatedObject({
    this.personCardId,
    this.email,
    this.firstName,
    this.lastName,
    this.firstNameEng,
    this.lastNameEng,
    this.phoneNumber,
    this.phoneNumberDialCode,
    this.phoneNumberParse,
    this.phoneNumberCleanLongFormat,
    this.pictureUrl,
    this.cardDescription,
    this.internetSiteUrl,
    this.address,
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
    this.messagesList,
  });

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
          ' ${this.personCardId},'
          ' ${this.email},'
          ' ${this.firstName},'
          ' ${this.lastName},'
          ' ${this.firstNameEng},'
          ' ${this.lastNameEng},'
          ' ${this.phoneNumber},'
          ' ${this.phoneNumberDialCode},'
          ' ${this.phoneNumberParse},'
          ' ${this.phoneNumberCleanLongFormat},'
          ' ${this.pictureUrl},'
          ' ${this.cardDescription},'
          ' ${this.internetSiteUrl},'
          ' ${this.address},'
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
          ' ${this.messagesList},'
      '}';
  }

  //#region From Json Populated [PersonCard + Populate All Fields without Messages]
  factory PersonCardPopulatedObject.fromJson(dynamic parsedJson){

    List<MessageObject> messagesObjectList = [];
    //
    // if (parsedJson['messages'] != null) {
    //   var messagesJson = parsedJson['messages'] as List;
    //   messagesObjectList = messagesJson.map((messageJson) => MessageObject.fromJson(messageJson)).toList().cast<String>();
    // } else {
    //   messagesObjectList = [];
    // }

    return PersonCardPopulatedObject(
      personCardId: parsedJson['_id'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
      firstNameEng: parsedJson['firstNameEng'],
      lastNameEng: parsedJson['lastNameEng'],
      phoneNumber: parsedJson['phoneNumber'],
      phoneNumberDialCode: parsedJson['phoneNumberDialCode'],
      phoneNumberParse: parsedJson['phoneNumberParse'],
      phoneNumberCleanLongFormat: parsedJson['phoneNumberCleanLongFormat'],
      pictureUrl: parsedJson['pictureUrl'],
      cardDescription: parsedJson['cardDescription'],
      internetSiteUrl: parsedJson['internetSiteUrl'],
      address: parsedJson['address'],
      areaId: parsedJson['areaId']['_id'],
      areaName: parsedJson['areaId']['areaName'],
      clusterId: parsedJson['clusterId']['_id'],
      clusterName: parsedJson['clusterId']['clusterName'],
      clubId: parsedJson['clubId']['_id'],
      clubName: parsedJson['clubId']['clubName'],
      clubAddress: parsedJson['clubId']['clubAddress'],
      clubMail: parsedJson['clubId']['clubMail'],
      clubManagerId: parsedJson['clubId']['clubManagerId'],
      roleId : parsedJson['roleId']['_id'],
      roleEnum : parsedJson['roleId']['roleEnum'],
      roleName: parsedJson['roleId']['roleName'],
      messagesList: messagesObjectList,
    );
  }
  //#endregion

  //#region From Json Message Populated [PersonCard + Populate Only Messages List]
  factory PersonCardPopulatedObject.fromJsonMessagePopulated(dynamic parsedJson){

    List<MessageObject> messagesObjectList;

    if (parsedJson['messages'] != null) {
      var messagesJson = parsedJson['messages'] as List;
      messagesObjectList = messagesJson.map((messageJson) => MessageObject.fromJson(messageJson)).toList();
    } else {
      messagesObjectList = [];
    }

    return PersonCardPopulatedObject(
      personCardId: parsedJson['_id'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
      firstNameEng: parsedJson['firstNameEng'],
      lastNameEng: parsedJson['lastNameEng'],
      phoneNumber: parsedJson['phoneNumber'],
      phoneNumberDialCode: parsedJson['phoneNumberDialCode'],
      phoneNumberParse: parsedJson['phoneNumberParse'],
      phoneNumberCleanLongFormat: parsedJson['phoneNumberCleanLongFormat'],
      pictureUrl: parsedJson['pictureUrl'],
      cardDescription: parsedJson['cardDescription'],
      internetSiteUrl: parsedJson['internetSiteUrl'],
      address: parsedJson['address'],
      areaId: parsedJson['areaId']['_id'],
      areaName: parsedJson['areaId']['areaName'],
      clusterId: parsedJson['clusterId']['_id'],
      clusterName: parsedJson['clusterId']['clusterName'],
      clubId: parsedJson['clubId']['_id'],
      clubName: parsedJson['clubId']['clubName'],
      clubAddress: parsedJson['clubId']['clubAddress'],
      clubMail: parsedJson['clubId']['clubMail'],
      clubManagerId: parsedJson['clubId']['clubManagerId'],
      roleId : parsedJson['roleId']['_id'],
      roleEnum : parsedJson['roleId']['roleEnum'],
      roleName: parsedJson['roleId']['roleName'],
      messagesList: messagesObjectList,
    );
  }
  //#endregion

  //#region From Json All Populated [PersonCard + Populate All Fields]
  factory PersonCardPopulatedObject.fromJsonAllPopulated(dynamic parsedJson){

    List<MessageObject> messagesObjectList;

    if (parsedJson['messages'] != null) {
      var messagesJson = parsedJson['messages'] as List;
      messagesObjectList = messagesJson.map((messageJson) => MessageObject.fromJson(messageJson)).toList();
    } else {
      messagesObjectList = [];
    }

    return PersonCardPopulatedObject(
      personCardId: parsedJson['_id'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
      firstNameEng: parsedJson['firstNameEng'],
      lastNameEng: parsedJson['lastNameEng'],
      phoneNumber: parsedJson['phoneNumber'],
      phoneNumberDialCode: parsedJson['phoneNumberDialCode'],
      phoneNumberParse: parsedJson['phoneNumberParse'],
      phoneNumberCleanLongFormat: parsedJson['phoneNumberCleanLongFormat'],
      pictureUrl: parsedJson['pictureUrl'],
      cardDescription: parsedJson['cardDescription'],
      internetSiteUrl: parsedJson['internetSiteUrl'],
      address: parsedJson['address'],
      areaId: parsedJson['areaId']['_id'],
      areaName: parsedJson['areaId']['areaName'],
      clusterId: parsedJson['clusterId']['_id'],
      clusterName: parsedJson['clusterId']['clusterName'],
      clubId: parsedJson['clubId']['_id'],
      clubName: parsedJson['clubId']['clubName'],
      clubAddress: parsedJson['clubId']['clubAddress'],
      clubMail: parsedJson['clubId']['clubMail'],
      clubManagerId: parsedJson['clubId']['clubManagerId'],
      roleId : parsedJson['roleId']['_id'],
      roleEnum : parsedJson['roleId']['roleEnum'],
      roleName: parsedJson['roleId']['roleName'],
      messagesList: messagesObjectList,
    );
  }
  //#endregion

  /// DataBase: Madel for PersonCardPopulatedObject
  ///----------------------------------------------------
  static PersonCardPopulatedObject personCardObjectFromJson(dynamic jsonSource) {
    if (jsonSource['messages'] != null) {
      var messagesJson = jsonSource['messages'] as List;
      List<MessageObject> messagesObjectList = messagesJson.map((messageJson) => MessageObject.fromJson(messageJson)).toList();

      return PersonCardPopulatedObject.fromMap(jsonSource, messagesObjectList);
    } else {
      return PersonCardPopulatedObject.fromMap(jsonSource, []);
    }
  }

  String personCardPopulatedObjectToJson(PersonCardPopulatedObject aPersonCardPopulatedObject) {
    final dyn = aPersonCardPopulatedObject.toMap();
    return json.encode(dyn);
  }

  factory PersonCardPopulatedObject.fromMap(Map<String, dynamic> jsonFromMap, List<MessageObject> aMessageList) {

    return PersonCardPopulatedObject(
      // personCardId: jsonFromMap['_id'],
      email: jsonFromMap['email'],
      firstName: jsonFromMap['firstName'],
      lastName: jsonFromMap['lastName'],
      firstNameEng: jsonFromMap['firstNameEng'],
      lastNameEng: jsonFromMap['lastNameEng'],
      phoneNumber: jsonFromMap['phoneNumber'],
      phoneNumberDialCode: jsonFromMap['phoneNumberDialCode'],
      phoneNumberParse: jsonFromMap['phoneNumberParse'],
      phoneNumberCleanLongFormat: jsonFromMap['phoneNumberCleanLongFormat'],
      pictureUrl: jsonFromMap['pictureUrl'],
      cardDescription: jsonFromMap['cardDescription'],
      internetSiteUrl: jsonFromMap['internetSiteUrl'],
      address: jsonFromMap['address'],
      areaId: jsonFromMap['areaId']['_id'],
      areaName: jsonFromMap['areaId']['areaName'],
      clusterId: jsonFromMap['clusterId']['_id'],
      clusterName: jsonFromMap['clusterId']['clusterName'],
      clubId: jsonFromMap['clubId']['_id'],
      clubName: jsonFromMap['clubId']['clubName'],
      clubAddress: jsonFromMap['clubId']['clubAddress'],
      clubMail: jsonFromMap['clubId']['clubMail'],
      clubManagerId: jsonFromMap['clubId']['clubManagerId'],
      roleId : jsonFromMap['roleId']['_id'],
      roleEnum : jsonFromMap['roleId']['roleEnum'],
      roleName: jsonFromMap['roleId']['roleName'],
      messagesList: aMessageList,
    );
  }

  Map<String, dynamic> toMap() {

    // // RoleEnum: Convert [Enum] to [int]
    // Constants.RotaryRolesEnum _roleEnum = roleId;
    // int _roleEnumValue = _roleEnum.value;

    return {
      if ((personCardId != null) && (personCardId != '')) '_id': personCardId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'firstNameEng': firstNameEng,
      'lastNameEng': lastNameEng,
      'phoneNumber': phoneNumber,
      'phoneNumberDialCode': phoneNumberDialCode,
      'phoneNumberParse': phoneNumberParse,
      'phoneNumberCleanLongFormat': phoneNumberCleanLongFormat,
      'pictureUrl': pictureUrl,
      'cardDescription': cardDescription,
      'internetSiteUrl': internetSiteUrl,
      'address': address,
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
      'messages': messagesList,
    };
  }
}
