import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' as SymbolData;
import 'package:intl/intl.dart' as Intl;

class PickDateTimeDialogWidget extends StatefulWidget {
  final DateTime argStartDateTime;
  final DateTime argEndDateTime;
  final Map argDatesMapObj;

  PickDateTimeDialogWidget({Key key,
    @required this.argStartDateTime,
    @required this.argEndDateTime,
    this.argDatesMapObj});

  @override
  _PickDateTimeDialogWidgetState createState() => _PickDateTimeDialogWidgetState();
}

class _PickDateTimeDialogWidgetState extends State<PickDateTimeDialogWidget> {
  DateTime pickedStartDateTime;
  DateTime pickedEndDateTime;

  String hebrewStartDate;
  String hebrewStartTime;
  String hebrewEndDate;
  String hebrewEndTime;

  String errorMessage;

  @override
  void initState() {
    super.initState();
    setEventVariables();
  }

  //#region Set event Variables
  Future<void> setEventVariables() async {

    pickedStartDateTime = widget.argStartDateTime;
    pickedEndDateTime = widget.argEndDateTime;

    hebrewStartDate = widget.argDatesMapObj["HebrewStartDate"];
    hebrewStartTime = widget.argDatesMapObj["HebrewStartTime"];
    hebrewEndDate = widget.argDatesMapObj["HebrewEndDate"];
    hebrewEndTime = widget.argDatesMapObj["HebrewEndTime"];
  }
  //#endregion

  //#region Close Picker And Return EventDateTime Values Event
  Future closePickerEventAndReturnDateTimeValues() async {
    if (pickedStartDateTime.isAfter(pickedEndDateTime))
    {
      setState(() {
        errorMessage = "טווח תאריכים לא חוקי";
      });
    } else {
      /// Return multiple data using MAP
      final returnDataDateTimeMap = {
        "EventPickedStartDateTime": pickedStartDateTime,
        "EventPickedEndDateTime": pickedEndDateTime,
      };
      Navigator.pop(context, returnDataDateTimeMap);
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context){

    var radius = Radius.circular(5);

    return AlertDialog(
      content: Container(
        height: 300,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              ),
            ),

            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: Scaffold(
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(50),
                          child: Container(
                            color: Colors.lightBlue[400],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TabBar(
                                  indicatorColor: Colors.white,
                                  labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),   //For Selected tab
                                  unselectedLabelStyle: TextStyle(fontSize: 12.0),                      //For Un-selected Tabs
                                  tabs: <Widget>[
                                    Tab(text :"מועד התחלה"),
                                    Tab(text :"מועד סיום"),
                                  ],
                                  indicator: ShapeDecoration(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: radius, topLeft: radius)),
                                      color: Colors.lightBlue[700]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        body: TabBarView(
                          children: <Widget>[
                            /// --------------- TAB: Start Event Time ---------------------
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
                              child: Column(
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      hebrewStartDate,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: Icon(Icons.calendar_today, color: Colors.blue),
                                    onTap: pickStartDate,
                                  ),
                                  ListTile(
                                    title: Text(
                                      hebrewStartTime,
                                      // "${pickedStartTime.hour}:${pickedStartTime.minute}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: Icon(Icons.access_time, color: Colors.blue),
                                    onTap: pickStartTime,
                                  ),
                                ],
                              ),
                            ),

                            /// --------------- TAB: End Event Time ---------------------
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
                              child: Column(
                                textDirection: TextDirection.rtl,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      hebrewEndDate,
                                      // "${pickedEndDate.year}, ${pickedEndDate.month}, ${pickedEndDate.day}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: Icon(Icons.calendar_today, color: Colors.blue),
                                    onTap: pickEndDate,
                                  ),
                                  ListTile(
                                    title: Text(
                                      hebrewEndTime,
                                      // "${pickedEndTime.hour}:${pickedEndTime.minute}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: Icon(Icons.access_time, color: Colors.blue,),
                                    onTap: pickEndTime,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (errorMessage != null)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),

                  buildUpdateImageButton('אישור', closePickerEventAndReturnDateTimeValues, Icons.check_circle_outline),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //#region Pick StartDate
  pickStartDate() async {
    DateTime _dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedStartDateTime,
    );

    if (_dateTime != null){
      await SymbolData.initializeDateFormatting("he", null);
      var formatterDate = Intl.DateFormat.yMMMMEEEEd('he');
      var formatterTime = Intl.DateFormat.Hm('he');

      String _hebrewStartDate = formatterDate.format(_dateTime);
      DateTime _newStartDateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, pickedStartDateTime.hour, pickedStartDateTime.minute);

      if (_newStartDateTime.isAfter(pickedEndDateTime))
      {
        /// If the new [StartDateTime] Is After [EndDateTime] ===>>> Fix the [EndDateTime]
        DateTime _newEndDateTime = _newStartDateTime.add(Duration(hours: 1));
        String _hebrewEndDate = formatterDate.format(_newEndDateTime);
        String _hebrewEndTime = formatterTime.format(_newEndDateTime);

        setState(() {
          errorMessage = null;
          pickedStartDateTime = _newStartDateTime;
          hebrewStartDate = _hebrewStartDate;

          pickedEndDateTime = _newEndDateTime;
          hebrewEndDate = _hebrewEndDate;
          hebrewEndTime = _hebrewEndTime;
        });
      } else {
        setState(() {
          errorMessage = null;
          pickedStartDateTime = _newStartDateTime;
          hebrewStartDate = _hebrewStartDate;
        });
      }
    }
  }
  //#endregion

  //#region Pick EndDate
  pickEndDate() async {
    DateTime _dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedEndDateTime,
    );

    if (_dateTime != null) {
      await SymbolData.initializeDateFormatting("he", null);
      var formatterDate = Intl.DateFormat.yMMMMEEEEd('he');

      String _hebrewEndDate = formatterDate.format(_dateTime);
      DateTime _newEndDateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, pickedEndDateTime.hour, pickedEndDateTime.minute);

      setState(() {
        errorMessage = null;
        pickedEndDateTime = _newEndDateTime;
        hebrewEndDate = _hebrewEndDate;
      });
    }
  }
  //#endregion

  //#region Pick StartTime
  pickStartTime() async {
    TimeOfDay _currentStartTime = TimeOfDay.fromDateTime(pickedStartDateTime);
    TimeOfDay _time = await showTimePicker(
        context: context,
        initialTime: _currentStartTime
    );

    if (_time != null) {
      await SymbolData.initializeDateFormatting("he", null);
      var formatterTime = Intl.DateFormat.Hm('he');

      DateTime _newStartDateTime = DateTime(
          pickedStartDateTime.year, pickedStartDateTime.month,
          pickedStartDateTime.day, _time.hour, _time.minute);
      String _hebrewStartTime = formatterTime.format(_newStartDateTime);

      if (_newStartDateTime.isAfter(pickedEndDateTime)) {
        /// If the new [StartTime] Is After [EndTime] ===>>> Fix the [EndTime]
        DateTime _newEndDateTime = _newStartDateTime.add(Duration(hours: 1));
        String _hebrewEndTime = formatterTime.format(_newEndDateTime);

        setState(() {
          errorMessage = null;
          pickedStartDateTime = _newStartDateTime;
          hebrewStartTime = _hebrewStartTime;

          pickedEndDateTime = _newEndDateTime;
          hebrewEndTime = _hebrewEndTime;
        });
      } else {
        setState(() {
          errorMessage = null;
          pickedStartDateTime = _newStartDateTime;
          hebrewStartTime = _hebrewStartTime;
        });
      }
    }
  }
  //#endregion

  //#region Pick EndTime
  pickEndTime() async {
    TimeOfDay _currentEndTime = TimeOfDay.fromDateTime(pickedEndDateTime);
    TimeOfDay _time = await showTimePicker(
        context: context,
        initialTime: _currentEndTime
    );

    if (_time != null)
    {
      DateTime _newEndDateTime = DateTime(pickedEndDateTime.year, pickedEndDateTime.month, pickedEndDateTime.day, _time.hour, _time.minute);
      await SymbolData.initializeDateFormatting("he", null);
      var formatterTime = Intl.DateFormat.Hm('he');
      String _hebrewEndTime = formatterTime.format(_newEndDateTime);

      setState(() {
        errorMessage = null;
        pickedEndDateTime = _newEndDateTime;
        hebrewEndTime = _hebrewEndTime;
      });
    }
  }
  //#endregion

  //#region Build Update ImageButton
  Widget buildUpdateImageButton(String buttonText, Function aFunc, IconData aIcon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: RaisedButton.icon(
        onPressed: () {aFunc(); },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        label: Text(
          buttonText,
          style: TextStyle(
              color: Colors.white, fontSize: 16.0
          ),
        ),
        icon: Icon(
          aIcon,
          color:Colors.white,
        ),
        textColor: Colors.white,
        color: Colors.blue[400],
      ),
    );
  }
  //#endregion
}
