import 'dart:convert';

class RotaryAreaObject {
  final String areaId;
  final String areaName;
  final List<String> clusters;

  RotaryAreaObject({
    this.areaId,
    this.areaName,
    this.clusters});

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.areaId},'
        ' ${this.areaName},'
        ' ${this.clusters},'
      '}';
  }

  factory RotaryAreaObject.fromJson(Map<String, dynamic> parsedJson){

    List<dynamic> dynClustersList = parsedJson['clusters'] as List<dynamic>;
    List<String> clustersList;
    if (dynClustersList != null) clustersList = dynClustersList.cast<String>();

    return RotaryAreaObject(
      areaId: parsedJson['_id'],
      areaName: parsedJson['areaName'],
      clusters: clustersList,
    );
  }

  /// DataBase: Madel for RotaryAreaObject
  ///----------------------------------------------------
  RotaryAreaObject rotaryAreaObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return RotaryAreaObject.fromMap(jsonData);
  }

  String rotaryAreaObjectToJson(RotaryAreaObject aRotaryAreaObject) {
    final dyn = aRotaryAreaObject.toMap();
    return json.encode(dyn);
  }

  factory RotaryAreaObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return RotaryAreaObject(
      // areaId: jsonFromMap['_id'],
      areaName: jsonFromMap['areaName'],
      clusters: jsonFromMap['clusters'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if ((areaId != null) && (areaId != '')) '_id': areaId,
      'areaName': areaName,
      'clusters': clusters,
    };
  }
}
