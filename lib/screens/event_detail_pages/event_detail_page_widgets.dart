import 'package:flutter/material.dart';
import 'package:rotary_net/utils/hebrew_syntax_format.dart';

class EventDetailWidgets {

  static Future <Widget> buildEventDateTimeLabel(
      DateTime aEventStartDateTime,
      DateTime aEventEndDateTime) async {
    // String eventDay = Intl.DateFormat('EEEE, d MMM, yyyy').format(aEventObj.eventStartDateTime); // prints Tuesday, 10 Dec, 2019
    // String eventStartTime = Intl.DateFormat('hh:mm').format(aEventObj.eventStartDateTime); // prints 10:02 AM
    // String eventEndTime = Intl.DateFormat('hh:mm').format(aEventObj.eventEndDateTime); // prints 10:02 AM

    final differenceDates = aEventEndDateTime
        .difference(aEventStartDateTime)
        .inDays;

    Map datesMapObj = await HebrewFormatSyntax.getHebrewStartEndDateTimeLabels(
        aEventStartDateTime, aEventEndDateTime);

    if (differenceDates != 0) {
      return RichText(
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'התחלה: ',
              style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 14.0),
            ),
            TextSpan(
              text: datesMapObj["HebrewStartDate"],
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
              text: '${datesMapObj["HebrewStartTime"]}\n',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'סיום: ',
              style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 14.0),
            ),
            TextSpan(
              text: datesMapObj["HebrewEndDate"],
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
              text: '${datesMapObj["HebrewEndTime"]}\n',
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
    else {
      return RichText(
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: datesMapObj["HebrewStartDate"],
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '\nבין השעות: ',
              style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 14.0),
            ),
            TextSpan(
              text: '${datesMapObj["HebrewStartTime"]} - ${datesMapObj["HebrewEndTime"]}',
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
}
