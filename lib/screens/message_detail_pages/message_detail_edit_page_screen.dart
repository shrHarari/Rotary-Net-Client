import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/messages_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_populated_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/screens/message_detail_pages/message_composer_detail_section.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';
import 'package:rotary_net/services/message_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/update_button_decoration.dart';

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

        List<String> _personCardIdList = await getPersonCardListByRoleHierarchyPermission(currentDataRequired.personCardPopulatedObject);

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
            _personCardIdList,
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
            /// --------------- Page Header Application Menu Area ---------------------
            Container(
              height: 160,
              color: Colors.lightBlue[400],
              child: PageHeaderApplicationMenu(
                argDisplayTitleLogo: true,
                argDisplayTitleLabel: false,
                argTitleLabelText: '',
                argDisplayApplicationMenu: false,
                argApplicationMenuFunction: null,
                argDisplayExit: true,
                argReturnFunction: null,
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
          child: buildUpdateButton("שמירה", Icons.save, updateMessage),
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

  //#region Build Composer Detail Section
  Widget buildComposerDetailSection(PersonCardPopulatedObject aPersonCardPopulatedObj) {

    PersonCardRoleAndHierarchyIdPopulatedObject hierarchyPopulatedObject =
    PersonCardRoleAndHierarchyIdPopulatedObject.createPersonCardRoleAndHierarchyIdAsPopulatedObject(
        aPersonCardPopulatedObj.personCardId,
        aPersonCardPopulatedObj.firstName,
        aPersonCardPopulatedObj.lastName,
        aPersonCardPopulatedObj.areaId,
        aPersonCardPopulatedObj.areaName,
        aPersonCardPopulatedObj.clusterId,
        aPersonCardPopulatedObj.clusterName,
        aPersonCardPopulatedObj.clubId,
        aPersonCardPopulatedObj.clubName,
        aPersonCardPopulatedObj.clubAddress,
        aPersonCardPopulatedObj.clubMail,
        aPersonCardPopulatedObj.roleId,
        aPersonCardPopulatedObj.roleName);

    return MessageComposerDetailSection(
      argHierarchyPopulatedObject: hierarchyPopulatedObject,
      argOpenComposerPersonCardDetailFunction: openComposerPersonCardDetailScreen,);
  }
  //#endregion

  //#region Build Update Button
  Widget buildUpdateButton(String aButtonText, IconData aIcon, Function aFunc) {
    final messagesBloc = BlocProvider.of<MessagesListBloc>(context);

    return StreamBuilder<List<MessagePopulatedObject>>(
        stream: messagesBloc.messagesPopulatedStream,
        initialData: messagesBloc.messagesListPopulated,
        builder: (context, snapshot) {
          // List<MessagePopulatedObject> currentMessagesList =
          // (snapshot.connectionState == ConnectionState.waiting)
          //     ? messagesBloc.messagesListPopulated
          //     : snapshot.data;

          return Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 120.0, left: 120.0),
            child: UpdateButtonDecoration(
                argButtonType: ButtonType.Decorated,
                argHeight: 40.0,
                argButtonText: aButtonText,
                argIcon: aIcon,
                onPressed: () {
                  aFunc(messagesBloc);
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