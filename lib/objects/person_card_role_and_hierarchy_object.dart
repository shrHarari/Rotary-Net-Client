import 'package:flutter/material.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';

class PersonCardRoleAndHierarchyObject {
  RotaryRoleObject rotaryRoleObject;
  RotaryAreaObject rotaryAreaObject;
  RotaryClusterObject rotaryClusterObject;
  RotaryClubObject rotaryClubObject;

  PersonCardRoleAndHierarchyObject({
    this.rotaryRoleObject,
    this.rotaryAreaObject,
    this.rotaryClusterObject,
    this.rotaryClubObject,
  });

  //#region Get Text styles
  static const TextStyle messageTextSpanStyleBold = TextStyle(
    fontFamily: 'Heebo-Light',
    fontSize: 18.0,
    height: 1.5,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle messageTextSpanStyle = TextStyle(
      fontFamily: 'Heebo-Light',
      fontSize: 17.0,
      height: 1.5,
      color: Colors.black87
  );
  //#endregion

  //#region Get PersonCard Hierarchy Title RichText
  static RichText getPersonCardHierarchyTitleRichText (
      String aRoleName, String aAreaName,
      String aClusterName, String aClubName) {

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: aRoleName,
            style: messageTextSpanStyleBold,
          ),
          TextSpan(
            text: ' מועדון ',
            style: messageTextSpanStyleBold,
          ),
          TextSpan(
            text: aClubName,
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: '\nבאשכול ',
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: aClusterName,
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: ' / ',
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: aAreaName,
            style: messageTextSpanStyle,
          ),
        ],
      ),
    );
  }
  //#endregion
}

class PersonCardRoleAndHierarchyListObject {
  List<RotaryRoleObject> rotaryRoleObjectList;
  List<RotaryAreaObject> rotaryAreaObjectList;
  List<RotaryClusterObject> rotaryClusterObjectList;
  List<RotaryClubObject> rotaryClubObjectList;

  PersonCardRoleAndHierarchyListObject({
    this.rotaryRoleObjectList,
    this.rotaryAreaObjectList,
    this.rotaryClusterObjectList,
    this.rotaryClubObjectList,
  });
}

class PersonCardRoleAndHierarchyIdObject {
  String areaId;
  String clusterId;
  String clubId;
  String roleId;
  int roleEnum;

  PersonCardRoleAndHierarchyIdObject({
    this.areaId,
    this.clusterId,
    this.clubId,
    this.roleId,
    this.roleEnum,
  });

  //#region Create RoleAndHierarchyId As Object
  //=============================================================================
  static PersonCardRoleAndHierarchyIdObject createPersonCardRoleAndHierarchyIdAsObject(
      String aAreaId,
      String aClusterId,
      String aClubId,
      String aRoleId,
      int aRoleEnum,
      )
  {
    if (aRoleId == null)
      return PersonCardRoleAndHierarchyIdObject(
        areaId: null,
        clusterId: null,
        clubId: null,
        roleId: null,
        roleEnum: null,
      );
    else
      return PersonCardRoleAndHierarchyIdObject(
        areaId: aAreaId,
        clusterId: aClusterId,
        clubId: aClubId,
        roleId: aRoleId,
        roleEnum: aRoleEnum,
      );
  }
  //#endregion
}

class PersonCardRoleAndHierarchyIdPopulatedObject {
  String personCardId;
  String firstName;
  String lastName;
  String areaId;
  String areaName;
  String clusterId;
  String clusterName;
  String clubId;
  String clubName;
  String clubAddress;
  String clubMail;
  String roleId;
  String roleName;

  PersonCardRoleAndHierarchyIdPopulatedObject({
    this.personCardId,
    this.firstName,
    this.lastName,
    this.areaId,
    this.areaName,
    this.clusterId,
    this.clusterName,
    this.clubId,
    this.clubName,
    this.clubAddress,
    this.clubMail,
    this.roleId,
    this.roleName,
  });

  //#region Create RoleAndHierarchyId As Populated Object
  //=============================================================================
  static PersonCardRoleAndHierarchyIdPopulatedObject createPersonCardRoleAndHierarchyIdAsPopulatedObject(
      String aPersonCardId,
      String aFirstName,
      String aLastName,
      String aAreaId,
      String areaName,
      String aClusterId,
      String aClusterName,
      String aClubId,
      String aClubName,
      String aClubAddress,
      String aClubMail,
      String aRoleId,
      String aRoleName,
      )
  {
    if (aPersonCardId == null)
      return PersonCardRoleAndHierarchyIdPopulatedObject(
        personCardId: null,
        firstName: null,
        lastName: null,
        areaId: null,
        areaName: null,
        clusterId: null,
        clusterName: null,
        clubId: null,
        clubName: null,
        clubAddress: null,
        clubMail: null,
        roleId: null,
        roleName: null,
      );
    else
      return PersonCardRoleAndHierarchyIdPopulatedObject(
        personCardId: aPersonCardId,
        firstName: aFirstName,
        lastName: aLastName,
        areaId: aAreaId,
        areaName: areaName,
        clusterId: aClusterId,
        clusterName: aClusterName,
        clubId: aClubId,
        clubName: aClubName,
        clubAddress: aClubAddress,
        clubMail: aClubMail,
        roleId: aRoleId,
        roleName: aRoleName,
      );
  }
//#endregion
}

