import 'package:intl/date_symbol_data_local.dart' as SymbolData;
import 'package:intl/intl.dart' as Intl;

class HebrewFormatSyntax {

  static Future<Map> getHebrewStartEndDateTimeLabels(DateTime aStartTime, DateTime aEndTime) async {

    Map startDateMapObj = await getHebrewDateTimeLabel(aStartTime);
    Map endDateMapObj = await getHebrewDateTimeLabel(aEndTime);

    /// Return multiple data using MAP
    final hebrewDatesMap = {
      "HebrewStartDate": startDateMapObj["HebrewDate"],
      "HebrewStartTime": startDateMapObj["HebrewTime"],
      "HebrewEndDate": endDateMapObj["HebrewDate"],
      "HebrewEndTime": endDateMapObj["HebrewTime"],
    };

    return hebrewDatesMap;
  }

  static Future<Map> getHebrewDateTimeLabel(DateTime aDateTime) async {

    await SymbolData.initializeDateFormatting("he", null);

    var formatterDate = Intl.DateFormat.yMMMMEEEEd('he');
    String hebrewDate = formatterDate.format(aDateTime);

    var formatterTime = Intl.DateFormat.Hm('he');
    String hebrewTime = formatterTime.format(aDateTime);

    /// Return multiple data using MAP
    final hebrewDatesMap = {
      "HebrewDate": hebrewDate,
      "HebrewTime": hebrewTime,
    };

    return hebrewDatesMap;
  }
}