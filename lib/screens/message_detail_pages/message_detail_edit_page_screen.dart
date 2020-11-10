import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/messages_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_populated_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';
import 'package:rotary_net/services/message_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';

class MessageDetailEditPageScreen extends StatefulWidget {
  static const routeName = '/MessageDetailEditPageScreen';
  final MessagePopulatedObject argMessagePopulatedObject;
  final Widget argHebrewMessageCreatedTimeLabel;

  MessageDetailEditPageScreen({Key key, @required this.argMessagePopulatedObject, this.argHebrewMessageCreatedTimeLabel}) : super(key: key);

  @override
  _MessageDetailEditPageScreenState createState() => _MessageDetailEditPageScreenState();
}

class _MessageDetailEditPageScreenState extends State<MessageDetailEditPageScreen> {

  final MessageService messageService = MessageService();

  final formKey = GlobalKey<FormState>();

  //#region Declare Variables
  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;

  bool isMessageExist = false;
  Widget currentHebrewMessageCreatedTimeLabel;

  TextEditingController messageController;

  String error = '';
  bool loading = false;
  //#endregion

  @override
  void initState() {
    dataRequiredForBuild = getAllRequiredDataForBuild();

    setMessageVariables(widget.argMessagePopulatedObject);

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
    if (widget.argMessagePopulatedObject == null)
      _personCardId = _connectedUserObj.personCardId;
    else
      _personCardId = widget.argMessagePopulatedObject.composerId;

    PersonCardPopulatedObject _personCardPopulatedObject =
              await _personCardService.getPersonCardByIdPopulated(_personCardId);

    setState(() {
      loading = false;
    });

    return DataRequiredForBuild(
      // personCardWithDescriptionObject: _personCardWithDescriptionObject,
      personCardPopulatedObject: _personCardPopulatedObject,
    );
  }
  //#endregion

  //#region Set Message Variables
  Future<void> setMessageVariables(MessagePopulatedObject aMessagePopulatedObj) async {

    currentHebrewMessageCreatedTimeLabel = widget.argHebrewMessageCreatedTimeLabel;

    /// If Exist ? Update(has Guid) : Insert(copy Guid)
    if (aMessagePopulatedObj != null)
    {
      isMessageExist = true;
      messageController = TextEditingController(text: aMessagePopulatedObj.messageText);
    } else {
      isMessageExist = false;
      messageController = TextEditingController(text: '');
    }
  }
  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = false;

    if (formKey.currentState.validate()){
      validationVal = true;
    }

    return validationVal;
  }
  //#endregion

  //#region Get PersonCardList By RoleHierarchyPermission
  Future getPersonCardListByRoleHierarchyPermission(PersonCardPopulatedObject aPersonCardPopulatedObject) async {

    PersonCardRoleAndHierarchyIdObject _personCardHierarchyObject =
        PersonCardRoleAndHierarchyIdObject.createPersonCardRoleAndHierarchyIdAsObject(
            aPersonCardPopulatedObject.areaId,
            aPersonCardPopulatedObject.clusterId,
            aPersonCardPopulatedObject.clubId,
            aPersonCardPopulatedObject.roleId,
            aPersonCardPopulatedObject.roleEnum
        );

    PersonCardService personCardService = PersonCardService();
    List<dynamic> personCardsList = await personCardService.getPersonCardListByRoleHierarchyPermission(_personCardHierarchyObject);

    // var personCardsList = personCardIdList.map((personCardJson) => personCardJson).toList().cast<String>();
    List<String> personCardIdList = personCardsList.map((personCardJson) => personCardJson['_id']).toList().cast<String>();

    return personCardIdList;
  }
  //#endregion

  //#region Update Message
  Future updateMessage(MessagesListBloc aMessageBloc) async {
    bool validationVal = await checkValidation();

    if (validationVal){

      String _messageText = (messageController.text != null) ? (messageController.text) : '';

      MessagePopulatedObject _newMessagePopulatedObj;

      if (isMessageExist) {
        _newMessagePopulatedObj = messageService.createMessagePopulatedAsObject(
            widget.argMessagePopulatedObject.messageId,
            widget.argMessagePopulatedObject.composerId,
            widget.argMessagePopulatedObject.composerFirstName,
            widget.argMessagePopulatedObject.composerLastName,
            widget.argMessagePopulatedObject.composerEmail,
            _messageText,
            widget.argMessagePopulatedObject.messageCreatedDateTime,
            widget.argMessagePopulatedObject.areaId,
            widget.argMessagePopulatedObject.areaName,
            widget.argMessagePopulatedObject.clusterId,
            widget.argMessagePopulatedObject.clusterName,
            widget.argMessagePopulatedObject.clubId,
            widget.argMessagePopulatedObject.clubName,
            widget.argMessagePopulatedObject.clubAddress,
            widget.argMessagePopulatedObject.clubMail,
            widget.argMessagePopulatedObject.clubManagerId,
            widget.argMessagePopulatedObject.roleId,
            widget.argMessagePopulatedObject.roleEnum,
            widget.argMessagePopulatedObject.roleName,
            widget.argMessagePopulatedObject.personCards,
        );

        await aMessageBloc.updateMessage(
            widget.argMessagePopulatedObject,
            _newMessagePopulatedObj);
      }
      else {
        /// Message NOT Exists --->>> Insert
        /// Using personCardWithDescriptionObject ===>>> Because there is no Current Message (Insert State)
        DateTime _messageCreatedDateTime = DateTime.now();

        List<String> personCardIdList = await getPersonCardListByRoleHierarchyPermission(currentDataRequired.personCardPopulatedObject);

        _newMessagePopulatedObj = messageService.createMessagePopulatedAsObject(
            '',
            currentDataRequired.personCardPopulatedObject.personCardId,
            currentDataRequired.personCardPopulatedObject.firstName,
            currentDataRequired.personCardPopulatedObject.lastName,
            currentDataRequired.personCardPopulatedObject.email,
            _messageText,
            _messageCreatedDateTime,
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
            personCardIdList,
        );

        await aMessageBloc.insertMessage(_newMessagePopulatedObj);
      }

      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context, _newMessagePopulatedObj);
    }
  }
  //#endregion

  //#region Open Composer Person Card Detail Screen
  openComposerPersonCardDetailScreen(String aComposerId) async {

    PersonCardService _personCardService = PersonCardService();
    PersonCardObject _personCardObj = await _personCardService.getPersonCardByPersonId(aComposerId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailPageScreen(
            argPersonCardObject: _personCardObj
        ),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    //     left: 20.0,
                    //     bottom: -25.0,
                    //     child: buildUpdateButton(updateMessage),
                    // ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: buildMessageDetailDisplay(currentDataRequired.personCardPopulatedObject),
            ),
          ]
      ),
    );
  }

  /// ====================== Message All Fields ==========================
  Widget buildMessageDetailDisplay(PersonCardPopulatedObject aPersonCardPopulatedObj) {
    return Column(
      children: <Widget>[
        /// ---------------- Message Content ----------------------
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: <Widget>[
                  /// --------------- MessageWithDescriptionObj Details [Metadata]---------------------
                  buildComposerDetailSection(aPersonCardPopulatedObj),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 0.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          /// ------------------- Input Text Fields ----------------------
                          buildMessageTextInput(messageController, 'תוכן ההודעה'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: buildUpdateButtonRectangleWithIcon("עדכן", updateMessage, Icons.update),
        ),

        /// ---------------------- Display Error -----------------------
        if (error.length > 0)
          Text(
            error,
            style: TextStyle(
                color: Colors.red,
                fontSize: 14.0),
          ),
      ],
    );
  }

  //#region Build Message Text Input
  Widget buildMessageTextInput(TextEditingController aController, String textInputName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 12,
              child:
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlign: TextAlign.right,
                  controller: aController,
                  style: TextStyle(fontSize: 16.0),
                  decoration: TextInputDecoration.copyWith(hintText: textInputName), // Disabled Field
                  validator: (val) => val.isEmpty ? '$textInputName' : null,
                ),
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region Composer Detail Section

  //#region Build Composer Detail Section
  Widget buildComposerDetailSection(PersonCardPopulatedObject aPersonCardPopulatedObj) {

    return Container(
      // color: Colors.grey[200],
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),

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
            if (aPersonCardPopulatedObj.firstName != "")
              buildComposerDetailName(Icons.person, aPersonCardPopulatedObj, openComposerPersonCardDetailScreen),

            if (aPersonCardPopulatedObj.areaName != "")
              buildComposerDetailAreaClusterClub(Icons.location_on, aPersonCardPopulatedObj, Utils.launchInMapByAddress),
          ],
        ),
      ),
    );
  }
  //#endregion

  //#region Build Composer Detail Name
  Widget buildComposerDetailName(IconData aIcon, PersonCardPopulatedObject aPersonCardPopulatedObj, Function aFunc) {
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
                aFunc(aPersonCardPopulatedObj.personCardId);
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
                aPersonCardPopulatedObj.firstName + ' ' + aPersonCardPopulatedObj.lastName,
                style: TextStyle(color: Colors.grey[900], fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            Text(
              '[${aPersonCardPopulatedObj.roleName}]',
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
  Widget buildComposerDetailAreaClusterClub(IconData aIcon, PersonCardPopulatedObject aPersonCardPopulatedObj, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(aPersonCardPopulatedObj.clubAddress);},
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
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'מועדון:',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        '${aPersonCardPopulatedObj.clubName}',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'אשכול:',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0),
                      ),
                    ),

                    Text(
                      '${aPersonCardPopulatedObj.areaName} / ${aPersonCardPopulatedObj.clusterName}',
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
                          await Utils.sendEmail(aPersonCardPopulatedObj.clubMail);
                        },
                        child: Text(
                          // '${aMessageObj.clubMail}',
                          '${aPersonCardPopulatedObj.clubMail}',
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

  //#endregion

  //#region Build Update Circle Button
  Widget buildUpdateCircleButton(Function aFunc) {

    final messagesBloc = BlocProvider.of<MessagesListBloc>(context);

    return StreamBuilder<List<MessagePopulatedObject>>(
      stream: messagesBloc.messagesPopulatedStream,
      initialData: messagesBloc.messagesListPopulated,
      builder: (context, snapshot) {
        List<MessagePopulatedObject> currentMessagesList =
        (snapshot.connectionState == ConnectionState.waiting)
            ? messagesBloc.messagesListPopulated
            : snapshot.data;

        return MaterialButton(
          elevation: 0.0,
          onPressed: () async {
            aFunc(messagesBloc);
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

    final messagesBloc = BlocProvider.of<MessagesListBloc>(context);

    return StreamBuilder<List<MessagePopulatedObject>>(
        stream: messagesBloc.messagesPopulatedStream,
        initialData: messagesBloc.messagesListPopulated,
        builder: (context, snapshot) {
          List<MessagePopulatedObject> currentMessagesList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? messagesBloc.messagesListPopulated
              : snapshot.data;

          return RaisedButton.icon(
            onPressed: () {
              aFunc(messagesBloc);
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

class DataRequiredForBuild {
  PersonCardPopulatedObject personCardPopulatedObject;

  DataRequiredForBuild({
    this.personCardPopulatedObject,
  });
}