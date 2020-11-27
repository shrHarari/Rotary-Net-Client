import 'dart:convert';
import 'package:rotary_net/objects/event_populated_object.dart';

class EventObject {
  String eventId;
  final String eventName;
  String eventPictureUrl;
  final String eventDescription;
  DateTime eventStartDateTime;
  DateTime eventEndDateTime;
  String eventLocation;
  final String eventManager;
  final String eventComposerId;

  EventObject({
    this.eventId,
    this.eventName,
    this.eventPictureUrl,
    this.eventDescription,
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.eventLocation,
    this.eventManager,
    this.eventComposerId,
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

  // Get EventObject From EventPopulatedObject
  //=======================================================
  static Future <EventObject> getEventObjectFromEventPopulatedObject(EventPopulatedObject aEventPopulatedObject) async {
    return EventObject(
      eventId: aEventPopulatedObject.eventId,
      eventName: aEventPopulatedObject.eventName,
      eventPictureUrl: aEventPopulatedObject.eventPictureUrl,
      eventDescription: aEventPopulatedObject.eventDescription,
      eventStartDateTime: aEventPopulatedObject.eventStartDateTime,
      eventEndDateTime: aEventPopulatedObject.eventEndDateTime,
      eventLocation: aEventPopulatedObject.eventLocation,
      eventManager: aEventPopulatedObject.eventManager,
      eventComposerId: aEventPopulatedObject.eventComposerId,
    );
  }

  @override
  String toString() {
    return '{'
        ' ${this.eventId},'
        ' ${this.eventName},'
        ' ${this.eventPictureUrl},'
        ' ${this.eventDescription},'
        ' ${this.eventStartDateTime},'
        ' ${this.eventEndDateTime},'
        ' ${this.eventLocation},'
        ' ${this.eventManager},'
        ' ${this.eventComposerId},'
        ' }';
  }

  factory EventObject.fromJson(Map<String, dynamic> parsedJson){

    if (parsedJson['_id'] == null) {
      return EventObject(
          eventId: '',
          eventName: parsedJson['eventName'],
          eventPictureUrl : parsedJson['eventPictureUrl'],
          eventDescription : parsedJson['eventDescription'],
          eventStartDateTime : DateTime.parse(parsedJson['eventStartDateTime']),
          eventEndDateTime : DateTime.parse(parsedJson['eventEndDateTime']),
          eventLocation : parsedJson['eventLocation'],
          eventManager : parsedJson['eventManager'],
          eventComposerId : parsedJson['eventComposerId']
      );
    } else {
      return EventObject(
          eventId: parsedJson['_id'],
          eventName: parsedJson['eventName'],
          eventPictureUrl : parsedJson['eventPictureUrl'],
          eventDescription : parsedJson['eventDescription'],
          eventStartDateTime : DateTime.parse(parsedJson['eventStartDateTime']),
          eventEndDateTime : DateTime.parse(parsedJson['eventEndDateTime']),
          eventLocation : parsedJson['eventLocation'],
          eventManager : parsedJson['eventManager'],
          eventComposerId : parsedJson['eventComposerId']
      );
    }
  }

  /// DataBase: Madel for Event
  ///----------------------------------------------------
  EventObject eventFromJson(String str) {
    final jsonData = json.decode(str);
    return EventObject.fromMap(jsonData);
  }

  String eventToJson(EventObject aEvent) {
    final dyn = aEvent.toMap();
    return json.encode(dyn);
  }

  factory EventObject.fromMap(Map<String, dynamic> jsonFromMap)
  {
    // DateTime: Convert [String] to [DateTime]
    DateTime _eventStartDateTime = DateTime.parse(jsonFromMap['eventStartDateTime']);
    DateTime _eventEndDateTime = DateTime.parse(jsonFromMap['eventEndDateTime']);

    return EventObject(
          // eventId: jsonFromMap['_id'],
          eventName: jsonFromMap['eventName'],
          eventPictureUrl : jsonFromMap['eventPictureUrl'],
          eventDescription : jsonFromMap['eventDescription'],
          eventStartDateTime : _eventStartDateTime,
          eventEndDateTime : _eventEndDateTime,
          eventLocation : jsonFromMap['eventLocation'],
          eventManager : jsonFromMap['eventManager'],
          eventComposerId : jsonFromMap['eventComposerId']
      );
  }

  Map<String, dynamic> toMap()
  {
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
    };
  }
}
