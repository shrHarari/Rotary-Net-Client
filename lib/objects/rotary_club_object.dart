import 'dart:convert';

class RotaryClubObject {
  final String clubId;
  final String clubName;
  final String clubAddress;
  final String clubMail;
  final String clubManagerId;

  RotaryClubObject({
    this.clubId,
    this.clubName,
    this.clubAddress,
    this.clubMail,
    this.clubManagerId});

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.clubId},'
        ' ${this.clubName},'
        ' ${this.clubAddress},'
        ' ${this.clubMail},'
        ' ${this.clubManagerId},'
      '}';
  }

  factory RotaryClubObject.fromJson(Map<String, dynamic> parsedJson){
    return RotaryClubObject(
      clubId: parsedJson['_id'],
      clubName: parsedJson['clubName'],
      clubAddress: parsedJson['clubAddress'],
      clubMail: parsedJson['clubMail'],
      clubManagerId: parsedJson['clubManagerId'],
    );
  }

  /// DataBase: Madel for RotaryClubObject
  ///----------------------------------------------------
  RotaryClubObject rotaryClubObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return RotaryClubObject.fromMap(jsonData);
  }

  String rotaryClubObjectToJson(RotaryClubObject aRotaryClubObject) {
    final dyn = aRotaryClubObject.toMap();
    return json.encode(dyn);
  }

  factory RotaryClubObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return RotaryClubObject(
      // clubId: jsonFromMap['_id'],
      clubName: jsonFromMap['clubName'],
      clubAddress: jsonFromMap['clubAddress'],
      clubMail: jsonFromMap['clubMail'],
      clubManagerId: jsonFromMap['clubManagerId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if ((clubId != null) && (clubId != '')) '_id': clubId,
      'clubName': clubName,
      'clubAddress': clubAddress,
      'clubMail': clubMail,
      'clubManagerId': clubManagerId,
    };
  }
}
