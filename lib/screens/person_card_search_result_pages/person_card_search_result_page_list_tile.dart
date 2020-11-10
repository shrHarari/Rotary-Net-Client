import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';

class PersonCardSearchResultPageListTile extends StatelessWidget {
  final PersonCardObject argPersonCardObj;

  const PersonCardSearchResultPageListTile({Key key, this.argPersonCardObj}) : super(key: key);

  //#region Open Person Card Detail Screen
  openPersonCardDetailScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailPageScreen(
            argPersonCardObject: argPersonCardObj
        ),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 0.0, right: 15.0, bottom: 5.0),
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: Colors.blue[300],
          ),

          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: Colors.grey[50],
            ),

            child: Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                (argPersonCardObj.pictureUrl == null) || (argPersonCardObj.pictureUrl == '')
                    ? buildEmptyPersonCardImageIcon(Icons.person)
                    : CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.blue[900],
                      backgroundImage: FileImage(File('${argPersonCardObj.pictureUrl}')),
                    ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            argPersonCardObj.firstName + " " + argPersonCardObj.lastName,
                            style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          argPersonCardObj.address,
                          style: TextStyle(color: Colors.grey[900], fontSize: 12.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: ()
        {
          // Hide Keyboard
          FocusScope.of(context).requestFocus(FocusNode());
          openPersonCardDetailScreen(context);
        },
      ),
    );
  }

 //#region Build Empty PersonCard Image Icon
  Widget buildEmptyPersonCardImageIcon(IconData aIcon, {Function aFunc}) {
    return Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.blue[700],
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),

        child: Center(
          child: Icon(aIcon,
            size: 30.0,
            color: Colors.grey[700],
          ),
        )
      );
  }
  //#endregion
}
