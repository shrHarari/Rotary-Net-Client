import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/event_populated_object.dart';
import 'package:rotary_net/objects/person_card_populated_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_widgets.dart';
import 'package:rotary_net/services/aws_service.dart';
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/utils/hebrew_syntax_format.dart';
import 'package:rotary_net/widgets/pick_date_time_dialog_widget.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/action_button_decoration.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:path/path.dart' as Path;

import 'dart:async';

class EventDetailEditPageScreen extends StatefulWidget {
  static const routeName = '/EventDetailEditPageScreen';
  final EventPopulatedObject argEventPopulatedObject;
  final Widget argHebrewEventTimeLabel;

  EventDetailEditPageScreen({Key key, @required this.argEventPopulatedObject, this.argHebrewEventTimeLabel}) : super(key: key);

  @override
  _EventDetailEditPageScreenState createState() => _EventDetailEditPageScreenState();
}

class _EventDetailEditPageScreenState extends State<EventDetailEditPageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final EventService eventService = EventService();

  //#region Declare Variables
  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;

  String currentEventImage;
  ConnectedUserObject currentConnectedUserObj;
  FileInfo currentEventImageFileInfo;
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
    dataRequiredForBuild = getAllRequiredDataForBuild();

    setEventVariables(widget.argEventPopulatedObject);

    super.initState();
  }

  //#region Get All Required Data For Build
  Future<DataRequiredForBuild> getAllRequiredDataForBuild() async {
    setState(() {
      loading = true;
    });

    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;

    PersonCardService _personCardService = PersonCardService();
    String _personCardId;
    if (widget.argEventPopulatedObject == null)
      _personCardId = _connectedUserObj.personCardId;
    else
      _personCardId = widget.argEventPopulatedObject.eventComposerId;

    PersonCardPopulatedObject _personCardPopulatedObject =
              await _personCardService.getPersonCardByIdPopulated(_personCardId);

    setState(() {
      loading = false;
    });

    return DataRequiredForBuild(
      personCardPopulatedObject: _personCardPopulatedObject,
    );
  }
  //#endregion

  // executeAfterBuildComplete(BuildContext context){
  //   setState(() {
  //     loading = false;
  //   });
  // }

  //#region Set Event Variables
  Future<void> setEventVariables(EventPopulatedObject aEventPopulated) async {
    eventImageDefaultAsset = AssetImage('${Constants.rotaryEventImageDefaultFolder}/EventImageDefaultPicture.jpg');
    currentConnectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;

    if (aEventPopulated != null)
    {
      isEventExist = true;   /// If Exist ? Update : Insert(Create EventId in DB)

      currentEventImage = aEventPopulated.eventPictureUrl;
      currentHebrewEventTimeLabel = widget.argHebrewEventTimeLabel;

      eventNameController = TextEditingController(text: aEventPopulated.eventName);
      eventDescriptionController = TextEditingController(text: aEventPopulated.eventDescription);
      eventLocationController = TextEditingController(text: aEventPopulated.eventLocation);
      eventManagerController = TextEditingController(text: aEventPopulated.eventManager);

      selectedPickStartDateTime = aEventPopulated.eventStartDateTime;
      selectedPickEndDateTime = aEventPopulated.eventEndDateTime;
    } else {
      isEventExist = false;

      eventNameController = TextEditingController(text: '');
      eventDescriptionController = TextEditingController(text: '');
      eventLocationController = TextEditingController(text: '');
      eventManagerController = TextEditingController(text: '${currentConnectedUserObj.firstName} ${currentConnectedUserObj.lastName}');
    }
  }
  //#endregion

  //#region Pick DateTime Dialog
  Future<void> openDateTimePickerDialog(BuildContext context) async {

    DateTime _startDateTime;
    DateTime _endDateTime;

    if (selectedPickStartDateTime == null) {
      DateTime dtNow = DateTime.now();
      _startDateTime = DateTime(dtNow.year, dtNow.month, dtNow.day, dtNow.hour + 1, 0, 0);
      _endDateTime = _startDateTime.add(Duration(hours: 1));
    } else {
      _startDateTime = selectedPickStartDateTime;
      if (selectedPickEndDateTime == null) {
        _endDateTime = _startDateTime.add(Duration(hours: 1));
      }
    }

    Map datesMapObj = await HebrewFormatSyntax.getHebrewStartEndDateTimeLabels(_startDateTime, _endDateTime);

    final returnDataMapFromPicker = await showDialog(
        context: _scaffoldKey.currentContext,
        builder: (context) {
          return PickDateTimeDialogWidget(
              argStartDateTime: _startDateTime,
              argEndDateTime: _endDateTime,
              argDatesMapObj: datesMapObj);
        }
    );

    if (returnDataMapFromPicker != null) {
      Widget _displayHebrewEventTimeLabel = await EventDetailWidgets.buildEventDateTimeLabel(
          returnDataMapFromPicker["EventPickedStartDateTime"],
          returnDataMapFromPicker["EventPickedEndDateTime"]
      );

      setState(() {
        selectedPickStartDateTime = _startDateTime;
        selectedPickEndDateTime = _endDateTime;
        currentHebrewEventTimeLabel = _displayHebrewEventTimeLabel;
      });
    }
  }
  //#endregion

  //#region Pick Image File
  Future <void> pickImageFile() async {
    String _imagePickerError;

    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedPickedFile = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 700
    );

    setState(() {
      error = '';
      loading = true;
    });

    String originalImageFileName;

    if (compressedPickedFile != null)
    {
      /// If currentEventImage Exists on Client --->>> Delete Original file
      String eventImagesDirectory = await Utils.createDirectoryInAppDocDir(Constants.rotaryEventImagesFolderName);
      if ((currentEventImage != null) && (currentEventImage != ''))
      {
        File originalImageFile = File(currentEventImage);
        originalImageFileName = Path.basename(originalImageFile.path);

        String localFilePath = '$eventImagesDirectory/$originalImageFileName';
        File localImageFile = File(localFilePath);
        if (localImageFile.existsSync()) localImageFile.delete();
      }

      File pickedPictureFile = File(compressedPickedFile.path);
      // copy the New CompressedPickedFile to a new path --->>> On Client
      String copyImageFileName = '${widget.argEventPopulatedObject.eventId}_${DateTime.now()}.jpg';
      String copyFilePath = '$eventImagesDirectory/$copyImageFileName';

      await pickedPictureFile.copy(copyFilePath).then((File newImageFile) async {
        if (newImageFile != null) {

          /// START Uploading
          Map<String, dynamic> uploadReturnVal;

          String fileType = Path.extension(compressedPickedFile.path);      /// <<<---- [.JPG]

          uploadReturnVal = await AwsService.awsUploadImageToServer(
              widget.argEventPopulatedObject.eventId,
              compressedPickedFile, copyImageFileName, fileType,
              originalImageFileName, aBucketFolderName: Constants.rotaryEventImagesFolderName);

          if ((uploadReturnVal != null) && (uploadReturnVal["returnCode"] == 200)) {
            setState(() {
              currentEventImage = uploadReturnVal["imageUrl"];
            });
          } else {
            _imagePickerError = "כשלון בהעלאת התמונה, נסה שנית ...";
            print('<EventDetailEditPageScreen> Upload Image Url >>> Failed: ${uploadReturnVal["returnCode"]} / ${uploadReturnVal["message"]}');
          }
        }
      });
    }

    setState(() {
      if ((_imagePickerError != null) && (_imagePickerError.length > 0)) error = _imagePickerError;
      loading = false;
    });
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

    setState(() {
      loading = true;
    });

    bool validationVal = await checkValidation();

    if (validationVal){

      String _eventName = (eventNameController.text != null) ? (eventNameController.text) : '';
      String _eventDescription = (eventDescriptionController.text != null) ? (eventDescriptionController.text) : '';
      String _eventLocation = (eventLocationController.text != null) ? (eventLocationController.text) : '';
      String _eventManager = (eventManagerController.text != null) ? (eventManagerController.text) : '';

      String _pictureUrl = '';
      if (currentEventImage != null) _pictureUrl = currentEventImage;

      EventPopulatedObject _newEventPopulatedObj;
      /// If Exist ? Update(has eventId) : Insert(Mongoose creates new _id)
      if (isEventExist)
      {
        _newEventPopulatedObj = eventService.createEventPopulatedAsObject(
            widget.argEventPopulatedObject.eventId,
            _eventName, _pictureUrl, _eventDescription,
            selectedPickStartDateTime, selectedPickEndDateTime,
            _eventLocation, _eventManager,
            widget.argEventPopulatedObject.eventComposerId,
            widget.argEventPopulatedObject.composerFirstName,
            widget.argEventPopulatedObject.composerLastName,
            widget.argEventPopulatedObject.composerEmail,
            widget.argEventPopulatedObject.areaId,
            widget.argEventPopulatedObject.areaName,
            widget.argEventPopulatedObject.clusterId,
            widget.argEventPopulatedObject.clusterName,
            widget.argEventPopulatedObject.clubId,
            widget.argEventPopulatedObject.clubName,
            widget.argEventPopulatedObject.clubAddress,
            widget.argEventPopulatedObject.clubMail,
            widget.argEventPopulatedObject.clubManagerId,
            widget.argEventPopulatedObject.roleId,
            widget.argEventPopulatedObject.roleEnum,
            widget.argEventPopulatedObject.roleName,
        );
        await aEventBloc.updateEvent(widget.argEventPopulatedObject, _newEventPopulatedObj);
      }
      else
      {
        _newEventPopulatedObj = eventService.createEventPopulatedAsObject(
            '',
            _eventName, _pictureUrl, _eventDescription,
            selectedPickStartDateTime, selectedPickEndDateTime,
            _eventLocation, _eventManager,
            currentDataRequired.personCardPopulatedObject.personCardId,
            currentDataRequired.personCardPopulatedObject.firstName,
            currentDataRequired.personCardPopulatedObject.lastName,
            currentDataRequired.personCardPopulatedObject.email,
            currentDataRequired.personCardPopulatedObject.areaId,
            currentDataRequired.personCardPopulatedObject.areaName,
            currentDataRequired.personCardPopulatedObject.clusterId,
            currentDataRequired.personCardPopulatedObject.clusterName,
            currentDataRequired.personCardPopulatedObject.clubId,
            currentDataRequired.personCardPopulatedObject.clubName,
            currentDataRequired.personCardPopulatedObject.clubAddress,
            currentDataRequired.personCardPopulatedObject.clubMail,
            currentDataRequired.personCardPopulatedObject.clubManagerId,
            currentDataRequired.personCardPopulatedObject.roleId,
            currentDataRequired.personCardPopulatedObject.roleEnum,
            currentDataRequired.personCardPopulatedObject.roleName,
        );

        await aEventBloc.insertEvent(_newEventPopulatedObj);
      }

      /// Return multiple data using MAP
      final returnEventDataMap = {
        "EventPopulatedObject": _newEventPopulatedObj,
        "HebrewEventTimeLabel": currentHebrewEventTimeLabel,
      };
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context, returnEventDataMap);
    }
    setState(() {
      loading = false;
    });
  }
  //#endregion

  //#region Exit And Navigate Back
  Future exitAndNavigateBack() async {
    String _pictureUrl = '';

    if (widget.argEventPopulatedObject == null) {
      Navigator.pop(context);
    } else {
      if (currentEventImage != null) _pictureUrl = currentEventImage;
      EventPopulatedObject _newEventPopulatedObj = widget.argEventPopulatedObject;
      _newEventPopulatedObj.setEventPictureUrl(_pictureUrl);

      /// Return multiple data using MAP
      final returnEventDataMap = {
        "EventPopulatedObject": _newEventPopulatedObj,
        "HebrewEventTimeLabel": null,
      };
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context, returnEventDataMap);
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[50],

      body: FutureBuilder<DataRequiredForBuild>(
          future: dataRequiredForBuild,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Loading();
            else
            if (snapshot.hasError) {
              return DisplayErrorTextAndRetryButton(
                errorText: 'שגיאה בשליפת אירועים',
                buttonText: 'אנא פנה למנהל המערכת',
                onPressed: () {},
              );
            } else {
              if (snapshot.hasData)
              {
                currentDataRequired = snapshot.data;
                return buildMainScaffoldBody();
              }
              else
                return Center(child: Text('אין תוצאות'));
            }
          }
      ),
      // body: buildMainScaffoldBody(),
    );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      // width: double.infinity,
      child: Column(
          children: <Widget>[
            /// --------------- Page Header Application Menu ---------------------
            Container(
              height: 160,
              color: Colors.lightBlue[400],
              child: PageHeaderApplicationMenu(
                argDisplayTitleLogo: true,
                argDisplayTitleLabel: false,
                argTitleLabelText: '',
                argDisplayApplicationMenu: false,
                argApplicationMenuFunction: null,
                argDisplayExit: false,
                argReturnFunction: exitAndNavigateBack,
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

                          /// ---------------------- Display Error -----------------------
                          Text(
                            error,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        buildUpdateButton("שמירה", Icons.save, updateEvent),

      ],
    );
  }

  //#region Build Event Image
  Widget buildEventImage() {
    return Stack(
      children: <Widget>[
        loading ? EventImagePickerLoading()
        : Container(
          height: 200.0,
          width: double.infinity,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: (currentEventImage == null) || (currentEventImage == '')
                    ? eventImageDefaultAsset
                    : NetworkImage(currentEventImage),
                fit: BoxFit.cover
            ),
          ),
        ),
        Positioned(
          bottom: 30.0,
          child: buildEventImagePickerButton(pickImageFile),
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

  //#region Build Event Image Picker Button
  Widget buildEventImagePickerButton(Function aFunc) {
    return ActionButtonDecoration(
        argButtonType: ButtonType.Circle,
        argHeight: null,
        argButtonText: '',
        argIcon: Icons.add_photo_alternate,
        argIconSize: 30.0,
        onPressed: () async {
          await aFunc();
        });
  }
  //#endregion

  //#region Build Update DateTime Button
  Widget buildUpdateDateTimeButton(Function aFunc) {
    return ActionButtonDecoration(
        argButtonType: ButtonType.Circle,
        argHeight: null,
        argButtonText: '',
        argIcon: Icons.edit,
        argIconSize: 20.0,
        onPressed: () async {
          await aFunc(context);
        });
  }
  //#endregion

  //#region Build Update Button
  Widget buildUpdateButton(String aButtonText, IconData aIcon, Function aFunc) {

    final eventsBloc = BlocProvider.of<EventsListBloc>(context);

    return StreamBuilder<List<EventPopulatedObject>>(
        stream: eventsBloc.eventsPopulatedStream,
        initialData: eventsBloc.eventsListPopulated,
        builder: (context, snapshot) {
          // List<EventObject> currentEventsList =
          // (snapshot.connectionState == ConnectionState.waiting)
          //     ? eventsBloc.eventsList
          //     : snapshot.data;

          return Padding(
            padding: const EdgeInsets.only(right: 120.0, left: 120.0, bottom: 10.0),
            child: ActionButtonDecoration(
                argButtonType: ButtonType.Decorated,
                argHeight: 40.0,
                argButtonText: aButtonText,
                argIcon: aIcon,
                onPressed: () {
                aFunc(eventsBloc);
              }),
        );
      }
    );
  }
  //#endregion
}

class DataRequiredForBuild {
  PersonCardPopulatedObject personCardPopulatedObject;

  DataRequiredForBuild({
    this.personCardPopulatedObject,
  });
}