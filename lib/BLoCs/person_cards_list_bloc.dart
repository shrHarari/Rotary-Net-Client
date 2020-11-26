import 'package:rotary_net/BLoCs/bloc.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'dart:async';

class PersonCardsListBloc implements BloC {

  PersonCardsListBloc(){
    getPersonCardsListBySearchQuery(_textToSearch);
  }

  final PersonCardService personCardService = PersonCardService();
  String _textToSearch;

  // a getter of the Bloc List --> to be called from outside
  var _personCardsList = <PersonCardObject>[];
  List<PersonCardObject> get personCardsList => _personCardsList;

  // 1. private StreamController is declared that will manage the stream and sink for this BLoC.
  // StreamControllers use generics to tell the type system what kind of object will be emitted from the stream

  // In case of multi calling to the stream we use broadcast
  final _personCardsController = StreamController<List<PersonCardObject>>.broadcast();

  // 2. exposes a public getter to the StreamController’s stream.
  Stream<List<PersonCardObject>> get personCardsStream => _personCardsController.stream;

  // 3. represents the input for the BLoC
  void getPersonCardsListBySearchQuery(String aTextToSearch) async {
    _textToSearch = aTextToSearch;

    if (_textToSearch == null || _textToSearch.length == 0)
      clearPersonCardsList();
    else
      _personCardsList = await personCardService.getPersonCardsListBySearchQuery(_textToSearch);

    _personCardsList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
    _personCardsController.sink.add(_personCardsList);
  }

  Future<void> clearPersonCardsList() async {
    _personCardsList = <PersonCardObject>[];
  }

  // 4. clean up method, the StreamController is closed when this object is deAllocated
  @override
  void dispose() {
    _personCardsController.close();
  }

  //#region CRUD: Person Card

  Future<void> insertPersonCard(String aUserId, PersonCardObject aPersonCardObj) async {
    if (_personCardsList.contains(aPersonCardObj)) {
      await personCardService.insertPersonCard(aUserId, aPersonCardObj);

      _personCardsList.add(aPersonCardObj);
      _personCardsList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
      _personCardsController.sink.add(_personCardsList);
    }
  }

  Future<void> updatePersonCardById(PersonCardObject aOldPersonCardObj, PersonCardObject aNewPersonCardObj) async {
    if (_personCardsList.contains(aOldPersonCardObj)) {

      await personCardService.updatePersonCardById(aNewPersonCardObj);

      _personCardsList.remove(aOldPersonCardObj);
      _personCardsList.add(aNewPersonCardObj);
      _personCardsList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
      _personCardsController.sink.add(_personCardsList);
    }
  }

  Future<void> deletePersonCardById(PersonCardObject aUsrObj) async {
    if (_personCardsList.contains(aUsrObj)) {
      await personCardService.deletePersonCardById(aUsrObj);

      _personCardsList.remove(aUsrObj);
      _personCardsController.sink.add(_personCardsList);
    }
  }
  //#endregion
}
