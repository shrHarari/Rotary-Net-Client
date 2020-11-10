import 'package:rotary_net/BLoCs/bloc.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/services/event_service.dart';
import 'dart:async';

class EventsListBloc implements BloC {

  EventsListBloc(){
    getEventsListBySearchQuery(_textToSearch);
  }

  final EventService eventService = EventService();
  String _textToSearch;

  // a getter of the Bloc List --> to be called from outside
  var _eventsList = <EventObject>[];
  List<EventObject> get eventsList => _eventsList;

  final _eventsController = StreamController<List<EventObject>>.broadcast();

  // 2. exposes a public getter to the StreamController’s stream.
  Stream<List<EventObject>> get eventsStream => _eventsController.stream;

  // 3. represents the input for the BLoC
  void getEventsListBySearchQuery(String aTextToSearch) async {
    _textToSearch = aTextToSearch;

    if (_textToSearch == null || _textToSearch.length == 0)
      clearEventsList();
    else
      _eventsList = await eventService.getEventsListBySearchQuery(_textToSearch);

    _eventsController.sink.add(_eventsList);
  }

  Future<void> clearEventsList() async {
    _eventsList = <EventObject>[];
  }

  // 4. clean up method, the StreamController is closed when this object is deAllocated
  @override
  void dispose() {
    _eventsController.close();
  }

  //#region CRUD: Event

  Future<void> insertEvent(EventObject aEventObj) async {
    EventObject insertedEventObject = await eventService.insertEvent(aEventObj);

    /// Update EventId of the new added Item in BlocList
    aEventObj.setEventId(insertedEventObject.eventId);

    _eventsList.add(aEventObj);
    _eventsList.sort((b, a) => a.eventStartDateTime.compareTo(b.eventStartDateTime));
    _eventsController.sink.add(_eventsList);
  }

  Future<void> updateEvent(EventObject aOldEventObj, EventObject aNewEventObj) async {
    if (_eventsList.contains(aOldEventObj)) {

      await eventService.updateEventById(aNewEventObj);

      _eventsList.remove(aOldEventObj);
      _eventsList.add(aNewEventObj);
      _eventsList.sort((b, a) => a.eventStartDateTime.compareTo(b.eventStartDateTime));
      _eventsController.sink.add(_eventsList);
    }
  }

  Future<void> deleteEventByEventId(EventObject aEventObj) async {
    if (_eventsList.contains(aEventObj)) {
      await eventService.deleteEventById(aEventObj);

      _eventsList.remove(aEventObj);
      _eventsController.sink.add(_eventsList);
    }
  }
//#endregion

}
