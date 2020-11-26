import 'package:flutter/material.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/utils/utils_class.dart';

class MessageComposerDetailSection extends StatelessWidget {
  final PersonCardRoleAndHierarchyIdPopulatedObject argHierarchyPopulatedObject;
  final Function argOpenComposerPersonCardDetailFunction;

  MessageComposerDetailSection({
    @required this.argHierarchyPopulatedObject,
    @required this.argOpenComposerPersonCardDetailFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0),

      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          bottom: BorderSide(
            color: Colors.amber,
            width: 2.0,
          ),
        ),
      ),

      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            if (argHierarchyPopulatedObject.firstName != "")
              buildComposerDetailName(Icons.person, argOpenComposerPersonCardDetailFunction),

            if (argHierarchyPopulatedObject.areaName != "")
              buildComposerDetailAreaClusterClub(Icons.location_on, Utils.launchInMapByAddress),
          ],
        ),
      ),
    );
  }

  //#region Build Composer Detail Name
  Widget buildComposerDetailName(IconData aIcon, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              elevation: 0.0,
              onPressed: () {
                aFunc(argHierarchyPopulatedObject.personCardId);
              },
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.black,
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(5),
              shape: CircleBorder(side: BorderSide(color: Colors.black)),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                argHierarchyPopulatedObject.firstName + ' ' + argHierarchyPopulatedObject.lastName,
                style: TextStyle(color: Colors.grey[900], fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            Text(
              '[${argHierarchyPopulatedObject.roleName}]',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region Build Composer Detail Area Cluster Club
  Widget buildComposerDetailAreaClusterClub(IconData aIcon, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(argHierarchyPopulatedObject.clubAddress);},
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.black,
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(5),
              shape: CircleBorder(side: BorderSide(color: Colors.black)),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'מועדון:',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0),
                      ),
                    ),
                    Text(
                      '${argHierarchyPopulatedObject.clubName}',
                      style: TextStyle(color: Colors.grey[900], fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'אשכול:',
                            style: TextStyle(color: Colors.grey[900], fontSize: 14.0),
                          ),
                        ),
                        Text(
                          '${argHierarchyPopulatedObject.areaName} / ${argHierarchyPopulatedObject.clusterName}',
                          style: TextStyle(color: Colors.grey[900], fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),


                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await Utils.sendEmail(argHierarchyPopulatedObject.clubMail);
                        },
                        child: Text(
                          '${argHierarchyPopulatedObject.clubMail}',
                          style: TextStyle(color: Colors.blue,
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }
//#endregion

}
