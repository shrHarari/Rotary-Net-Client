import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class EventService {

  //#region Create Event As Object
  //=============================================================================
  EventObject createEventAsObject(
      String aEventId,
      String aEventName,
      String aEventPictureUrl,
      String aEventDescription,
      DateTime aEventStartDateTime,
      DateTime aEventEndDateTime,
      String aEventLocation,
      String aEventManager,
      )
  {
    if (aEventId == null)
      return EventObject(
          eventId: '',
          eventName: '',
          eventPictureUrl: '',
          eventDescription: '',
          eventStartDateTime: null,
          eventEndDateTime: null,
          eventLocation: '',
          eventManager: '',
      );
    else
      return EventObject(
        eventId: aEventId,
        eventName: aEventName,
        eventPictureUrl: aEventPictureUrl,
        eventDescription: aEventDescription,
        eventStartDateTime: aEventStartDateTime,
        eventEndDateTime: aEventEndDateTime,
        eventLocation: aEventLocation,
        eventManager: aEventManager,
      );
  }
  //#endregion

  //#region * Get Events List By Search Query [GET]
  // =========================================================
  Future getEventsListBySearchQuery(String aValueToSearch) async {
    try {
      String _getUrl = Constants.rotaryEventUrl + "/query/$aValueToSearch";
      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print("getEventsListBySearchQuery/ jsonResponse: $jsonResponse");
        await LoggerService.log('<EventService> Get Events List By SearchQuery >>> OK\nHeader: $contentType \nEventsListFromJSON: $jsonResponse');

        var eventList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<EventObject> eventObjList = eventList.map((eventJson) => EventObject.fromJson(eventJson)).toList();

        eventObjList.sort((a, b) => a.eventName.toLowerCase().compareTo(b.eventName.toLowerCase()));

        return eventObjList;
      } else {
        await LoggerService.log('<EventService> Get Events List By SearchQuery >>> Failed: ${response.statusCode}');
        print('<EventService> Get Events List By SearchQuery >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<EventService> Get Events List By SearchQuery >>> ERROR: ${e.toString()}');
      developer.log(
        'getEventsListBySearchQuery',
        name: 'EventService',
        error: 'Get Events List By SearchQuery >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Events

  //#region * Insert Event [WriteToDB]
  //=============================================================================
  Future insertEvent(EventObject aEventObj) async {
    try {
      // Convert ConnectedUserObject To Json
      String jsonToPost = aEventObj.eventToJson(aEventObj);

      Response response = await post(Constants.rotaryEventUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        final Map parsedResponse = json.decode(jsonResponse);
        EventObject insertedEventObject = EventObject.fromJson(parsedResponse);

        await LoggerService.log('<EventService> Insert Event >>> OK');
        return insertedEventObject;
      } else {
        await LoggerService.log('<EventService> Insert Event >>> Failed >>> ${response.statusCode}');
        print('<EventService> Insert Event >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<EventService> Insert Event >>> Server ERROR: ${e.toString()}');
      developer.log(
        'insertEvent',
        name: 'EventService',
        error: 'Insert Event >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update Event By EventId To DataBase [WriteToDB]
  //=============================================================================
  Future updateEventById(EventObject aEventObj) async {
    try {
      // Convert EventObject To Json
      String jsonToPost = aEventObj.eventToJson(aEventObj);
      print ('updateEventByEventId / EventObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryEventUrl + "/${aEventObj.eventId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('<EventService> Update Event By Id >>> EventObject / jsonResponse: $jsonResponse');

        await LoggerService.log('<EventService> Update Event By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<EventService> Update Event By Id >>> Failed >>> ${response.statusCode}');
        print('<EventService> Update Event By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<EventService> Update Event By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'updateEventById',
        name: 'EventService',
        error: 'Update Event By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete Event By EventId From DataBase [WriteToDB]
  //=============================================================================
  Future deleteEventById(EventObject aEventObj) async {
    try {
      String _deleteUrl = Constants.rotaryEventUrl + "/${aEventObj.eventId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('deleteEventById / EventObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log(
              '<EventService> Delete Event By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log(
              '<EventService> Delete Event By Id >>> Failed');
          print('<EventService> Delete Event By Id >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<EventService> Delete Event By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteEvent By Id',
        name: 'EventService',
        error: 'Delete Event By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
