import 'dart:convert';

class RotaryRoleObject {
  final String roleId;
  final int roleEnum;
  final String roleName;

  RotaryRoleObject({
    this.roleId,
    this.roleEnum,
    this.roleName});

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.roleId},'
        ' ${this.roleEnum},'
        ' ${this.roleName},'
      '}';
  }

  factory RotaryRoleObject.fromJson(Map<String, dynamic> parsedJson){
    return RotaryRoleObject(
      roleId: parsedJson['_id'],
      roleEnum: parsedJson['roleEnum'],
      roleName: parsedJson['roleName'],
    );
  }

  /// DataBase: Madel for RotaryRole
  ///----------------------------------------------------
  RotaryRoleObject rotaryRoleObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return RotaryRoleObject.fromMap(jsonData);
  }

  String rotaryRoleObjectToJson(RotaryRoleObject aRotaryRoleObject) {
    final dyn = aRotaryRoleObject.toMap();
    return json.encode(dyn);
  }

  factory RotaryRoleObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return RotaryRoleObject(
      // roleId: jsonFromMap['_id'],
      roleEnum: jsonFromMap['roleEnum'],
      roleName: jsonFromMap['roleName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if ((roleId != null) && (roleId != '')) '_id': roleId,
      'roleEnum': roleEnum,
      'roleName': roleName,
    };
  }
}
