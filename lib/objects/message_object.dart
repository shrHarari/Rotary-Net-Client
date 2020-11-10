import 'dart:convert';
import 'package:rotary_net/objects/message_populated_object.dart';

class MessageObject {
  final String messageId;
  final String composerId;
  final String messageText;
  final DateTime messageCreatedDateTime;
  final List<String> personCards;

  MessageObject({
    this.messageId,
    this.composerId,
    this.messageText,
    this.messageCreatedDateTime,
    this.personCards,});

  // get MessageObject From MessagePopulatedObject
  //=======================================================
  static Future <MessageObject> getMessageObjectFromMessagePopulatedObject(MessagePopulatedObject aMessagePopulatedObject) async {

    return MessageObject(
      messageId: aMessagePopulatedObject.messageId,
      composerId: aMessagePopulatedObject.composerId,
      messageText: aMessagePopulatedObject.messageText,
      messageCreatedDateTime: aMessagePopulatedObject.messageCreatedDateTime,
      personCards: aMessagePopulatedObject.personCards,
    );
  }

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    // DateTime: Convert [DateTime] to [String]
    String _messageCreatedDateTime = this.messageCreatedDateTime.toIso8601String();

    /// Check if Necessary
    // var jsonPersonCardIdsList = jsonEncode(aPersonCardIdsList.map((personCard) => personCard).toList());

    return
      '{'
        ' ${this.messageId},'
        ' ${this.composerId},'
        ' ${this.messageText},'
        ' $_messageCreatedDateTime,'
        ' ${this.personCards},'
      '}';
  }

  factory MessageObject.fromJson(Map<String, dynamic> parsedJson){
    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(parsedJson['messageCreatedDateTime']);

    List<dynamic> dynPersonCardsList = parsedJson['personCards'] as List<dynamic>;
    List<String> personCardsList;
    if (dynPersonCardsList != null) personCardsList = dynPersonCardsList.cast<String>();

    return MessageObject(
      messageId: parsedJson['_id'],
      composerId: parsedJson['composerId'],
      messageText: parsedJson['messageText'],
      messageCreatedDateTime: _messageCreatedDateTime,
      personCards: personCardsList,
    );
  }

  /// DataBase: Madel for MessageObject
  ///----------------------------------------------------
  MessageObject messageObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return MessageObject.fromMap(jsonData);
  }

  String messageObjectToJson(MessageObject aMessageObject) {
    final dyn = aMessageObject.toMap();
    return json.encode(dyn);
  }

  factory MessageObject.fromMap(Map<String, dynamic> jsonFromMap) {
    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(jsonFromMap['messageCreatedDateTime']);

    return MessageObject(
      // messageId: jsonFromMap['_id'],
      composerId: jsonFromMap['composerId'],
      messageText: jsonFromMap['messageText'],
      messageCreatedDateTime: _messageCreatedDateTime,
      personCards: jsonFromMap['personCards'],
    );
  }

  Map<String, dynamic> toMap() {
    // DateTime: Convert [DateTime] to [String]
    String _messageCreatedDateTime = messageCreatedDateTime.toIso8601String();

    return {
      if ((messageId != null) && (messageId != '')) '_id': messageId,
      'composerId': composerId,
      'messageText': messageText,
      'messageCreatedDateTime': _messageCreatedDateTime,
      'personCards': personCards,
    };
  }
}
