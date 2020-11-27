import 'package:rotary_net/BLoCs/bloc.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/objects/event_populated_object.dart';
import 'package:rotary_net/services/event_service.dart';
import 'dart:async';

class EventsListBloc implements BloC {

  EventsListBloc(){
    getEventsListPopulatedBySearchQuery(_textToSearch);
  }

  final EventService eventService = EventService();
  String _textToSearch;

  // a getter of the Bloc List --> to be called from outside
  var _eventsListPopulated = <EventPopulatedObject>[];
  List<EventPopulatedObject> get eventsListPopulated => _eventsListPopulated;

  final _eventsPopulatedController = StreamController<List<EventPopulatedObject>>.broadcast();

  // 2. exposes a public getter to the StreamController’s stream.
  Stream<List<EventPopulatedObject>> get eventsPopulatedStream => _eventsPopulatedController.stream;

  // 3. represents the input for the BLoC
  void getEventsListPopulatedBySearchQuery(String aTextToSearch) async {
    _textToSearch = aTextToSearch;

    if (_textToSearch == null || _textToSearch.length == 0)
      clearEventsList();
    else
      _eventsListPopulated = await eventService.getEventsListPopulatedBySearchQuery(_textToSearch);

    _eventsListPopulated.sort((b, a) => a.eventStartDateTime.compareTo(b.eventStartDateTime));
    _eventsPopulatedController.sink.add(_eventsListPopulated);
  }

  Future<void> clearEventsList() async {
    _eventsListPopulated = <EventPopulatedObject>[];
  }

  // 4. clean up method, the StreamController is closed when this object is deAllocated
  @override
  void dispose() {
    _eventsPopulatedController.close();
  }

  //#region CRUD: Event

  Future<void> insertEvent(EventPopulatedObject aEventPopulatedObj) async {


    EventObject _eventObj = await EventObject.getEventObjectFromEventPopulatedObject(aEventPopulatedObj);
    EventObject insertedEventObject = await eventService.insertEvent(_eventObj);

    /// Update EventId of the new added Item in BlocList
    aEventPopulatedObj.setEventId(insertedEventObject.eventId);

    _eventsListPopulated.add(aEventPopulatedObj);
    _eventsListPopulated.sort((b, a) => a.eventStartDateTime.compareTo(b.eventStartDateTime));
    _eventsPopulatedController.sink.add(_eventsListPopulated);
  }

  Future<void> updateEvent(EventPopulatedObject aOldEventPopulatedObj, EventPopulatedObject aNewEventPopulatedObj) async {
    if (_eventsListPopulated.contains(aOldEventPopulatedObj)) {
      EventObject _eventObj = await EventObject.getEventObjectFromEventPopulatedObject(aNewEventPopulatedObj);
      await eventService.updateEventById(_eventObj);

      _eventsListPopulated.remove(aOldEventPopulatedObj);
      _eventsListPopulated.add(aNewEventPopulatedObj);
      _eventsListPopulated.sort((b, a) => a.eventStartDateTime.compareTo(b.eventStartDateTime));
      _eventsPopulatedController.sink.add(_eventsListPopulated);
    }
  }

  Future<void> deleteEventByEventId(EventPopulatedObject aEventPopulatedObj) async {
    if (_eventsListPopulated.contains(aEventPopulatedObj)) {

      EventObject _eventObj = await EventObject.getEventObjectFromEventPopulatedObject(aEventPopulatedObj);
      await eventService.deleteEventById(_eventObj);

      _eventsListPopulated.remove(aEventPopulatedObj);
      _eventsPopulatedController.sink.add(_eventsListPopulated);
    }
  }
//#endregion

}
//
// class EventsListBloc implements BloC {
//
//   EventsListBloc(){
//     getEventsListBySearchQuery(_textToSearch);
//   }
//
//   final EventService eventService = EventService();
//   String _textToSearch;
//
//   // a getter of the Bloc List --> to be called from outside
//   var _eventsList = <EventObject>[];
//   List<EventObject> get eventsList => _eventsList;
//
//   final _eventsController = StreamController<List<EventObject>>.broadcast();
//
//   // 2. exposes a public getter to the StreamController’s stream.
//   Stream<List<EventObject>> get eventsStream => _eventsController.stream;
//
//   // 3. represents the input for the BLoC
//   void getEventsListBySearchQuery(String aTextToSearch) async {
//     _textToSearch = aTextToSearch;
//
//     if (_textToSearch == null || _textToSearch.length == 0)
//       clearEventsList();
//     else
//       _eventsList = await eventService.getEventsListBySearchQuery(_textToSearch);
//
//     _eventsList.sort((b, a) => a.eventStartDateTime.compareTo(b.eventStartDateTime));
//     _eventsController.sink.add(_eventsList);
//   }
//
//   Future<void> clearEventsList() async {
//     _eventsList = <EventObject>[];
//   }
//
//   // 4. clean up method, the StreamController is closed when this object is deAllocated
//   @override
//   void dispose() {
//     _eventsController.close();
//   }
//
//   //#region CRUD: Event
//
//   Future<void> insertEvent(EventObject aEventObj) async {
//     EventObject insertedEventObject = await eventService.insertEvent(aEventObj);
//
//     /// Update EventId of the new added Item in BlocList
//     aEventObj.setEventId(insertedEventObject.eventId);
//
//     _eventsList.add(aEventObj);
//     _eventsList.sort((b, a) => a.eventStartDateTime.compareTo(b.eventStartDateTime));
//     _eventsController.sink.add(_eventsList);
//   }
//
//   Future<void> updateEvent(EventObject aOldEventObj, EventObject aNewEventObj) async {
//     if (_eventsList.contains(aOldEventObj)) {
//       await eventService.updateEventById(aNewEventObj);
//
//       _eventsList.remove(aOldEventObj);
//       _eventsList.add(aNewEventObj);
//       _eventsList.sort((b, a) => a.eventStartDateTime.compareTo(b.eventStartDateTime));
//       _eventsController.sink.add(_eventsList);
//     }
//   }
//
//   Future<void> deleteEventByEventId(EventObject aEventObj) async {
//     if (_eventsList.contains(aEventObj)) {
//       await eventService.deleteEventById(aEventObj);
//
//       _eventsList.remove(aEventObj);
//       _eventsController.sink.add(_eventsList);
//     }
//   }
//   //#endregion
// }
