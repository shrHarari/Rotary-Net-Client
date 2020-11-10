import 'package:flutter/material.dart';
import 'package:rotary_net/utils/hebrew_syntax_format.dart';

class MessageDetailWidgets {

  static Future <Widget> buildMessageCreatedTimeLabel(
      DateTime aMessageCreatedDateTime) async {

    Map datesMapObj = await HebrewFormatSyntax.getHebrewDateTimeLabel(aMessageCreatedDateTime);

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: datesMapObj["HebrewDate"],
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '\nבשעה: ',
            style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14.0),
          ),
          TextSpan(
            text: '${datesMapObj["HebrewTime"]}',
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
