import 'dart:convert';

class PersonCardObject {
  final String personCardId;
  String email;
  final String firstName;
  final String lastName;
  final String firstNameEng;
  final String lastNameEng;
  final String phoneNumber;
  final String phoneNumberDialCode;
  final String phoneNumberParse;
  final String phoneNumberCleanLongFormat;
  String pictureUrl;
  String cardDescription;
  String internetSiteUrl;
  String address;
  String areaId;
  String clusterId;
  String clubId;
  String roleId;
  final List<String> messages;

  PersonCardObject({
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
    this.clusterId,
    this.clubId,
    this.roleId,
    this.messages,
  });

  //#region Update PersonCard Object with Sets Calls

  //#region Set PersonCard Email
  Future <void> setEmail(String aEmail) async {
    email = aEmail;
  }
  //#endregion

  //#region Set PersonCard PictureUrl
  Future <void> setPictureUrl(String aPictureUrl) async {
    pictureUrl = aPictureUrl;
  }
  //#endregion

  //#region Set PersonCard RoleId
  Future <void> setRoleId(String aRoleId) async {
    roleId = aRoleId;
  }
  //#endregion

  //#region Set PersonCard AreaId
  Future <void> setAreaId(String aAreaId) async {
    areaId = aAreaId;
  }
  //#endregion

  //#region Set PersonCard ClusterId
  Future <void> setClusterId(String aClusterId) async {
    clusterId = aClusterId;
  }
  //#endregion

  //#region Set PersonCard ClubId
  Future <void> setClubId(String aClubId) async {
    clubId = aClubId;
  }
  //#endregion

  //#endregion

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
          ' ${this.clusterId},'
          ' ${this.clubId},'
          ' ${this.roleId},'
          ' ${this.messages},'
      '}';
  }

  factory PersonCardObject.fromJson(Map<String, dynamic> parsedJson){

    List<dynamic> dynMessagesList = parsedJson['messages'] as List<dynamic>;
    List<String> messagesList;
    if (dynMessagesList != null) messagesList = dynMessagesList.cast<String>();

    return PersonCardObject(
      personCardId: parsedJson['_id'],
      email: parsedJson['email'],
      firstName : parsedJson['firstName'],
      lastName : parsedJson['lastName'],
      firstNameEng : parsedJson['firstNameEng'],
      lastNameEng : parsedJson['lastNameEng'],
      phoneNumber : parsedJson['phoneNumber'],
      phoneNumberDialCode : parsedJson['phoneNumberDialCode'],
      phoneNumberParse : parsedJson['phoneNumberParse'],
      phoneNumberCleanLongFormat : parsedJson['phoneNumberCleanLongFormat'],
      pictureUrl : parsedJson['pictureUrl'],
      cardDescription : parsedJson['cardDescription'],
      internetSiteUrl : parsedJson['internetSiteUrl'],
      address : parsedJson['address'],
      areaId : parsedJson['areaId'],
      clusterId : parsedJson['clusterId'],
      clubId : parsedJson['clubId'],
      roleId : parsedJson['roleId'],
      messages : messagesList,
    );
  }

  /// DataBase: Madel for Person Card
  ///----------------------------------------------------
  PersonCardObject personCardFromJson(String str) {
    final jsonData = json.decode(str);
    return PersonCardObject.fromMap(jsonData);
  }

  String personCardToJson(PersonCardObject aPersonCard) {
    final dyn = aPersonCard.toMap();
    return json.encode(dyn);
  }

  factory PersonCardObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return PersonCardObject(
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
      areaId: jsonFromMap['areaId'],
      clusterId: jsonFromMap['clusterId'],
      clubId: jsonFromMap['clubId'],
      roleId: jsonFromMap['roleId'],
      messages: jsonFromMap['messages'],
    );
  }

  Map<String, dynamic> toMap() {
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
      'clusterId': clusterId,
      'clubId': clubId,
      'roleId': roleId,
      'messages': messages,
    };
  }
}
