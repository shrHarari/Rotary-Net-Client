import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_widgets.dart';
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/utils/hebrew_syntax_format.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/widgets/pick_date_time_dialog_widget.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:path/path.dart' as Path;

class EventDetailEditPageScreen extends StatefulWidget {
  static const routeName = '/EventDetailEditPageScreen';
  final EventObject argEventObject;
  final Widget argHebrewEventTimeLabel;

  EventDetailEditPageScreen({Key key, @required this.argEventObject, this.argHebrewEventTimeLabel}) : super(key: key);

  @override
  _EventDetailEditPageScreenState createState() => _EventDetailEditPageScreenState();
}

class _EventDetailEditPageScreenState extends State<EventDetailEditPageScreen> {

  final EventService eventService = EventService();

  final formKey = GlobalKey<FormState>();

  //#region Declare Variables
  String currentEventImage;
  bool isEventExist = false;
  Widget currentHebrewEventTimeLabel;

  AssetImage eventImageDefaultAsset;
  DateTime selectedPickStartDateTime;
  DateTime selectedPickEndDateTime;

  TextEditingController eventNameController;
  TextEditingController eventDescriptionController;
  TextEditingController eventLocationController;
  TextEditingController eventManagerController;

  String error = '';
  bool loading = false;
  //#endregion

  @override
  void initState() {
    setEventVariables(widget.argEventObject);

    super.initState();
  }

  //#region Set Event Variables
  Future<void> setEventVariables(EventObject aEvent) async {
    eventImageDefaultAsset = AssetImage('assets/images/events/EventImageDefaultPicture.jpg');

    if (aEvent != null)
    {
      isEventExist = true;   /// If Exist ? Update(has Id) : Insert(copy Guid)

      currentEventImage = aEvent.eventPictureUrl;
      currentHebrewEventTimeLabel = widget.argHebrewEventTimeLabel;

      eventNameController = TextEditingController(text: aEvent.eventName);
      eventDescriptionController = TextEditingController(text: aEvent.eventDescription);
      eventLocationController = TextEditingController(text: aEvent.eventLocation);
      eventManagerController = TextEditingController(text: aEvent.eventManager);

      selectedPickStartDateTime = aEvent.eventStartDateTime;
      selectedPickEndDateTime = aEvent.eventEndDateTime;
    } else {
      isEventExist = false;

      eventNameController = TextEditingController(text: '');
      eventDescriptionController = TextEditingController(text: '');
      eventLocationController = TextEditingController(text: '');
      eventManagerController = TextEditingController(text: '');
    }
  }
  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = false;

    if (formKey.currentState.validate()){
      if (selectedPickStartDateTime == null)
      {
        validationVal = false;
        setState(() {
          error = "יש להגדיר מועד ושעה לאירוע";
        });
      } else
        validationVal = true;
    }

    return validationVal;
  }
  //#endregion

  //#region Update Event
  Future updateEvent(EventsListBloc aEventBloc) async {

    bool validationVal = await checkValidation();

    if (validationVal){

      String _eventName = (eventNameController.text != null) ? (eventNameController.text) : '';
      String _eventDescription = (eventDescriptionController.text != null) ? (eventDescriptionController.text) : '';
      String _eventLocation = (eventLocationController.text != null) ? (eventLocationController.text) : '';
      String _eventManager = (eventManagerController.text != null) ? (eventManagerController.text) : '';

      String _pictureUrl = '';
      if (currentEventImage != null) _pictureUrl = currentEventImage;

      EventObject _newEventObj;
      if (isEventExist) {
        _newEventObj = eventService.createEventAsObject(
            widget.argEventObject.eventId,
            _eventName, _pictureUrl, _eventDescription,
            selectedPickStartDateTime, selectedPickEndDateTime,
            _eventLocation, _eventManager,);

        await aEventBloc.updateEvent(widget.argEventObject, _newEventObj);
      }
      else {
        _newEventObj = eventService.createEventAsObject(
            '',
            _eventName, _pictureUrl, _eventDescription,
            selectedPickStartDateTime, selectedPickEndDateTime,
            _eventLocation, _eventManager,);

        await aEventBloc.insertEvent(_newEventObj);
      }

      /// Return multiple data using MAP
      final returnDataDateTimeMap = {
        "EventObject": _newEventObj,
        "HebrewEventTimeLabel": currentHebrewEventTimeLabel,
      };
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context, returnDataDateTimeMap);
    }
  }
  //#endregion

  //#region Pick DateTime Dialog
  Future<void> openDateTimePickerDialog(BuildContext context) async {

    if (selectedPickStartDateTime == null) {
      DateTime dtNow = DateTime.now();
      selectedPickStartDateTime = DateTime(dtNow.year, dtNow.month, dtNow.day, dtNow.hour+1, 0, 0);
      selectedPickEndDateTime = selectedPickStartDateTime.add(Duration(hours: 1));
    } else {
      if (selectedPickEndDateTime == null) {
        selectedPickEndDateTime = selectedPickStartDateTime.add(Duration(hours: 1));
      }
    }

    Map datesMapObj = await HebrewFormatSyntax.getHebrewStartEndDateTimeLabels(selectedPickStartDateTime, selectedPickEndDateTime);

    final returnDataMapFromPicker = await showDialog(
        context: context,
        builder: (context) {
          return PickDateTimeDialogWidget(
              argStartDateTime: selectedPickStartDateTime,
              argEndDateTime: selectedPickEndDateTime,
              argDatesMapObj: datesMapObj);
        }
    );

    if (returnDataMapFromPicker != null) {
      DateTime _startDateTime = returnDataMapFromPicker["EventPickedStartDateTime"];
      DateTime _endDateTime = returnDataMapFromPicker["EventPickedEndDateTime"];
      Widget _displayHebrewDateTime = await EventDetailWidgets.buildEventDateTimeLabel(_startDateTime, _endDateTime);

      setState(() {
        selectedPickStartDateTime = _startDateTime;
        selectedPickEndDateTime = _endDateTime;
        currentHebrewEventTimeLabel = _displayHebrewDateTime;
      });
    }
  }
  //#endregion

  //#region Pick Image File
  Future <void> pickImageFile() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile _compressedImage = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 800
    );

    if (_compressedImage != null)
    {
      if ((currentEventImage != null) && (currentEventImage != ''))
      {
        File originalImageFile = File(currentEventImage);
        originalImageFile.delete();
      }

      File _pickedPictureFile = File(_compressedImage.path);
      String _newEventImagesDirectory = await Utils.createDirectoryInAppDocDir('assets/images/event_images');
      String _newImageFileName =  Path.basename(_pickedPictureFile.path);

      String _copyFilePath = '$_newEventImagesDirectory/$_newImageFileName';

      // copy the file to a new path
      await _pickedPictureFile.copy(_copyFilePath).then((File _newImageFile) {
        if (_newImageFile != null) {

          setState(() {
            currentEventImage = _newImageFile.path;
          });
        }
      });
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      backgroundColor: Colors.blue[50],

      drawer: Container(
        width: 250,
        child: Drawer(
          child: ApplicationMenuDrawer(),
        ),
      ),

      body: buildMainScaffoldBody(),
    );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      // width: double.infinity,
      child: Column(
          children: <Widget>[
            /// --------------- Title Area ---------------------
            Container(
              height: 160,
              color: Colors.lightBlue[400],
              child: SafeArea(
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    /// ----------- Header - First line - Application Logo -----------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: MaterialButton(
                                elevation: 0.0,
                                onPressed: () {},
                                color: Colors.lightBlue,
                                textColor: Colors.white,
                                child: Icon(
                                  Icons.account_balance,
                                  size: 30,
                                ),
                                padding: EdgeInsets.all(20),
                                shape: CircleBorder(side: BorderSide(color: Colors.white)),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(Constants.rotaryApplicationName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// --------------- Application Menu ---------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        /// Exit Icon --->>> Close Screen
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.close, color: Colors.white, size: 26.0,),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode()); // Hide Keyboard
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),

                    // Positioned(
                    //   left: 20.0,
                    //   bottom: -25.0,
                    //   child: buildUpdateCircleButton(updateEvent),
                    // ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: buildEventDetailDisplay(),
            ),
          ]
      ),
    );
  }

  /// ====================== Event All Fields ==========================
  Widget buildEventDetailDisplay() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: <Widget>[
                  /// ------------------- Event Image -------------------------
                  buildEventImage(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          /// ------------------- Input Text Fields ----------------------
                          buildEnabledTextInputWithImageIcon(eventNameController, 'שם אירוע', Icons.description, false),
                          buildEnabledTextInputWithImageIcon(eventManagerController, 'מנהל ואיש קשר', Icons.person, false),
                          buildEnabledTextInputWithImageIcon(eventDescriptionController, 'תיאור האירוע', Icons.view_list, true),
                          buildEnabledTextInputWithImageIcon(eventLocationController, 'מיקום האירוע', Icons.location_on, false),
                          buildEventDetailImageIcon(Icons.event_available, currentHebrewEventTimeLabel, openDateTimePickerDialog),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        buildUpdateButtonRectangleWithIcon("עדכן", updateEvent, Icons.update),

        /// ---------------------- Display Error -----------------------
        Text(
          error,
          style: TextStyle(
              color: Colors.red,
              fontSize: 14.0),
        ),
      ],
    );
  }

  //#region Build Event Image
  Widget buildEventImage() {
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          width: double.infinity,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: (currentEventImage == null) || (currentEventImage == '')
                    ? eventImageDefaultAsset
                    : FileImage(File(currentEventImage)),
                fit: BoxFit.cover
            ),
          ),
        ),
        Positioned(
          bottom: 30.0,
          child: buildUpdateEventImageButton(pickImageFile),
        ),
      ]
    );
  }
  //#endregion

  //#region Build Enabled TextInput With Image Icon
  Widget buildEnabledTextInputWithImageIcon(TextEditingController aController, String textInputName, IconData aIcon, bool aMultiLine) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: buildImageIconForTextField(aIcon),
            ),

            Expanded(
              flex: 12,
              child:
              Container(
                child: buildTextFormField(aController, textInputName, aMultiLine),
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region Build ImageIcon For TextField
  MaterialButton buildImageIconForTextField(IconData aIcon) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () {},
      color: Colors.blue[10],
      padding: EdgeInsets.all(10),
      shape: CircleBorder(
          side: BorderSide(color: Colors.blue)
      ),
      child:
      IconTheme(
        data: IconThemeData(
            color: Colors.blue[500]
        ),
        child: Icon(
          aIcon,
          size: 30,
        ),
      ),
    );
  }
  //#endregion

  //#region Build Text Form Field
  TextFormField buildTextFormField(
      TextEditingController aController,
      String textInputName,
      bool aMultiLine,
      {bool aEnabled = true}) {
    return TextFormField(
      keyboardType: aMultiLine ? TextInputType.multiline : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: aEnabled ?
      TextInputDecoration.copyWith(hintText: textInputName) :
      DisabledTextInputDecoration.copyWith(hintText: textInputName), // Disabled Field
      validator: (val) => val.isEmpty ? 'הקלד $textInputName' : null,
    );
  }
  //#endregion

  //#region Build Event Detail Image Icon
  Widget buildEventDetailImageIcon(IconData aIcon, Widget aDisplayWidgetDate, Function aFunc) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: MaterialButton(
              elevation: 0.0,
              onPressed: () {},
              color: Colors.blue[10],
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.blue[500],
                ),
                child: Icon(
                  aIcon,
                  size: 30,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.centerRight,
              child: aDisplayWidgetDate,
            ),
          ),

          Expanded(
            flex: 2,
            child: buildUpdateDateTimeButton(aFunc),
          ),
        ]
    );
  }
  //#endregion

  //#region Build Update Event Image Button
  Widget buildUpdateEventImageButton(Function aFunc) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () async {await aFunc();},
      color: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(side: BorderSide(color: Colors.blue)),
      child: IconTheme(
        data: IconThemeData(
          color: Colors.black,
        ),
        child: Icon(
          Icons.add_photo_alternate,
          size: 30,
        ),
      ),
    );
  }
  //#endregion

  //#region Build Update DateTime Button
  Widget buildUpdateDateTimeButton(Function aFunc) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () async {await aFunc(context);},
      color: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(side: BorderSide(color: Colors.blue)),
      child:
      IconTheme(
        data: IconThemeData(
          color: Colors.black,
        ),
        child: Icon(
          Icons.edit,
          size: 20,
        ),
      ),
    );
  }
  //#endregion

  //#region Build Update Circle Button
  Widget buildUpdateCircleButton(Function aFunc) {

    final eventsBloc = BlocProvider.of<EventsListBloc>(context);

    return StreamBuilder<List<EventObject>>(
        stream: eventsBloc.eventsStream,
        initialData: eventsBloc.eventsList,
        builder: (context, snapshot) {
          List<EventObject> currentEventsList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? eventsBloc.eventsList
              : snapshot.data;

          return MaterialButton(
            elevation: 0.0,
            onPressed: () async {
              aFunc(eventsBloc);
            },
            color: Colors.white,
            padding: EdgeInsets.all(10),
            shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            child: IconTheme(
              data: IconThemeData(
                color: Colors.black,
              ),
              child: Icon(
                Icons.save,
                size: 20,
              ),
            ),
          );
        }
    );
  }
  //#endregion

  //#region Build Update Rectangle Button
  Widget buildUpdateButtonRectangleWithIcon(String buttonText, Function aFunc, IconData aIcon) {

    final eventsBloc = BlocProvider.of<EventsListBloc>(context);

    return StreamBuilder<List<EventObject>>(
        stream: eventsBloc.eventsStream,
        initialData: eventsBloc.eventsList,
        builder: (context, snapshot) {
          List<EventObject> currentEventsList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? eventsBloc.eventsList
              : snapshot.data;

        return RaisedButton.icon(
          onPressed: () {
            aFunc(eventsBloc);
          },
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
        );
      }
    );
  }
  //#endregion
}
