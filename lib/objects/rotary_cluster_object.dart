import 'dart:convert';

class RotaryClusterObject {
  // final String areaId;
  final String clusterId;
  final String clusterName;
  final List<String> clubs;

  RotaryClusterObject({
    // this.areaId,
    this.clusterId,
    this.clusterName,
    this.clubs});

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        // ' ${this.areaId},'
        ' ${this.clusterId},'
        ' ${this.clusterName},'
        ' ${this.clubs},'
      '}';
  }

  factory RotaryClusterObject.fromJson(Map<String, dynamic> parsedJson){

    List<dynamic> dynClubsList = parsedJson['clubs'] as List<dynamic>;
    List<String> clubsList;
    if (dynClubsList != null) clubsList = dynClubsList.cast<String>();

    return RotaryClusterObject(
      // areaId: parsedJson['areaId'],
      clusterId: parsedJson['_id'],
      clusterName: parsedJson['clusterName'],
      clubs: clubsList,
    );
  }

  /// DataBase: Madel for RotaryClusterObject
  ///----------------------------------------------------
  RotaryClusterObject rotaryClusterObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return RotaryClusterObject.fromMap(jsonData);
  }

  String rotaryClusterObjectToJson(RotaryClusterObject aRotaryClusterObject) {
    final dyn = aRotaryClusterObject.toMap();
    return json.encode(dyn);
  }

  factory RotaryClusterObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return RotaryClusterObject(
      // areaId: jsonFromMap['areaId'],
      // clusterId: jsonFromMap['_id'],
      clusterName: jsonFromMap['clusterName'],
      clubs: jsonFromMap['clubs'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'areaId': areaId,
      if ((clusterId != null) && (clusterId != '')) '_id': clusterId,
      'clusterName': clusterName,
      'clubs': clubs,
    };
  }
}
