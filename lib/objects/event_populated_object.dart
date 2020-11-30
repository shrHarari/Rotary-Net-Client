import 'dart:convert';

class EventPopulatedObject {
  String eventId;
  final String eventName;
  String eventPictureUrl;
  final String eventDescription;
  DateTime eventStartDateTime;
  DateTime eventEndDateTime;
  String eventLocation;
  final String eventManager;
  final String eventComposerId;
  final String composerFirstName;
  final String composerLastName;
  final String composerEmail;
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

  EventPopulatedObject({
    this.eventId,
    this.eventName,
    this.eventPictureUrl,
    this.eventDescription,
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.eventLocation,
    this.eventManager,
    this.eventComposerId,
    this.composerFirstName,
    this.composerLastName,
    this.composerEmail,
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
  });

  //#region Update Event Object with Sets Calls

  ///#region Set EventId
  Future <void> setEventId(String aEventId) async {
    eventId = aEventId;
  }
  //#endregion

  ///#region Set EventPicture Url
  Future <void> setEventPictureUrl(String aPictureUrl) async {
    eventPictureUrl = aPictureUrl;
  }
  //#endregion

  ///#region Set Event DateTime (Start-End)
  Future <void> setStartDateTime(DateTime aStartDateTime) async {
    eventStartDateTime = aStartDateTime;
  }
  Future <void> setEndDateTime(DateTime aEndDateTime) async {
    eventEndDateTime = aEndDateTime;
  }
  //#endregion

  //#endregion

  EventPopulatedObject.copy(EventPopulatedObject uniqueObject) :
        eventId = uniqueObject.eventId,
        eventName = uniqueObject.eventName,
        eventPictureUrl = uniqueObject.eventPictureUrl,
        eventDescription = uniqueObject.eventDescription,
        eventStartDateTime = uniqueObject.eventStartDateTime,
        eventEndDateTime = uniqueObject.eventEndDateTime,
        eventLocation = uniqueObject.eventLocation,
        eventManager = uniqueObject.eventManager,
        eventComposerId = uniqueObject.eventComposerId,
        composerFirstName = uniqueObject.composerFirstName,
        composerLastName = uniqueObject.composerLastName,
        composerEmail = uniqueObject.composerEmail,
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
        roleName = uniqueObject.roleName;

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
          ' ${this.eventId},'
          ' ${this.eventName},'
          ' ${this.eventPictureUrl},'
          ' ${this.eventDescription},'
          ' ${this.eventStartDateTime},'
          ' ${this.eventEndDateTime},'
          ' ${this.eventLocation},'
          ' ${this.eventManager},'
          ' ${this.eventComposerId},'
          ' ${this.composerFirstName},'
          ' ${this.composerLastName},'
          ' ${this.composerEmail},'
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
          '}';
  }

  //#region From Json All Populated [Event + Populate All Fields]
  factory EventPopulatedObject.fromJsonAllPopulated(dynamic parsedJson){

    // DateTime: Convert [String] to [DateTime]
    DateTime _eventStartDateTime = DateTime.parse(parsedJson['eventStartDateTime']);
    DateTime _eventEndDateTime = DateTime.parse(parsedJson['eventEndDateTime']);

    return EventPopulatedObject(
      eventId: parsedJson['_id'],
      eventName: parsedJson['eventName'],
      eventPictureUrl : parsedJson['eventPictureUrl'],
      eventDescription : parsedJson['eventDescription'],
      eventStartDateTime : _eventStartDateTime,
      eventEndDateTime : _eventEndDateTime,
      eventLocation : parsedJson['eventLocation'],
      eventManager : parsedJson['eventManager'],
      eventComposerId : parsedJson['eventComposerId']['_id'],
      composerFirstName: parsedJson['eventComposerId']['firstName'],
      composerLastName: parsedJson['eventComposerId']['lastName'],
      composerEmail: parsedJson['eventComposerId']['email'],
      areaId: parsedJson['eventComposerId']['areaId']['_id'],
      areaName: parsedJson['eventComposerId']['areaId']['areaName'],
      clusterId: parsedJson['eventComposerId']['clusterId']['_id'],
      clusterName: parsedJson['eventComposerId']['clusterId']['clusterName'],
      clubId: parsedJson['eventComposerId']['clubId']['_id'],
      clubName: parsedJson['eventComposerId']['clubId']['clubName'],
      clubAddress: parsedJson['eventComposerId']['clubId']['clubAddress'],
      clubMail: parsedJson['eventComposerId']['clubId']['clubMail'],
      clubManagerId: parsedJson['eventComposerId']['clubId']['clubManagerId'],
      roleId : parsedJson['eventComposerId']['roleId']['_id'],
      roleEnum : parsedJson['eventComposerId']['roleId']['roleEnum'],
      roleName: parsedJson['eventComposerId']['roleId']['roleName'],
    );
  }
  //#endregion

  /// DataBase: Madel for MessageObject
  ///----------------------------------------------------
  EventPopulatedObject eventObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return EventPopulatedObject.fromMap(jsonData);
  }

  String messageObjectToJson(EventPopulatedObject aEventPopulatedObject) {
    final dyn = aEventPopulatedObject.toMap();
    return json.encode(dyn);
  }

  factory EventPopulatedObject.fromMap(Map<String, dynamic> jsonFromMap) {
    // DateTime: Convert [String] to [DateTime]
    DateTime _eventStartDateTime = DateTime.parse(jsonFromMap['eventStartDateTime']);
    DateTime _eventEndDateTime = DateTime.parse(jsonFromMap['eventEndDateTime']);

    return EventPopulatedObject(
      // eventId: jsonFromMap['_id'],
      eventName: jsonFromMap['eventName'],
      eventPictureUrl : jsonFromMap['eventPictureUrl'],
      eventDescription : jsonFromMap['eventDescription'],
      eventStartDateTime : _eventStartDateTime,
      eventEndDateTime : _eventEndDateTime,
      eventLocation : jsonFromMap['eventLocation'],
      eventManager : jsonFromMap['eventManager'],
      eventComposerId : jsonFromMap['eventComposerId'],
      composerFirstName: jsonFromMap['composerFirstName'],
      composerLastName: jsonFromMap['composerLastName'],
      composerEmail: jsonFromMap['composerEmail'],
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
    );
  }

  Map<String, dynamic> toMap() {
    // DateTime: Convert [DateTime] to [String]
    String _eventStartDateTime = eventStartDateTime.toIso8601String();
    String _eventEndDateTime = eventEndDateTime.toIso8601String();

    return {
      if ((eventId != null) && (eventId != '')) '_id': eventId,
      'eventName': eventName,
      'eventPictureUrl': eventPictureUrl,
      'eventDescription': eventDescription,
      'eventStartDateTime': _eventStartDateTime,
      'eventEndDateTime': _eventEndDateTime,
      'eventLocation': eventLocation,
      'eventManager': eventManager,
      'eventComposerId': eventComposerId,
      'composerFirstName': composerFirstName,
      'composerLastName': composerLastName,
      'composerEmail': composerEmail,
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
    };
  }
}
