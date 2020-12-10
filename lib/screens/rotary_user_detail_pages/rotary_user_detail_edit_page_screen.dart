import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/user_type_label_radio.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/action_button_decoration.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class UserDetailEditPageScreen extends StatefulWidget {
  static const routeName = '/UserDetailEditPageScreen';
  final UserObject argUserObject;

  UserDetailEditPageScreen({Key key, @required this.argUserObject}) : super(key: key);

  @override
  _UserDetailEditPageScreenState createState() => _UserDetailEditPageScreenState();
}

class _UserDetailEditPageScreenState extends State<UserDetailEditPageScreen> {

  final UserService userService = UserService();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setUserVariables(widget.argUserObject);
    super.initState();
  }

  //#region Declare Variables
  TextEditingController eMailController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController passwordController;
  Constants.UserTypeEnum userType;
  bool stayConnected;

  String error = '';
  bool loading = false;
  //#endregion

  //#region Set PersonCard Variables
  Future<void> setUserVariables(UserObject aUser) async {

    eMailController = TextEditingController(text: aUser.email);
    firstNameController = TextEditingController(text: aUser.firstName);
    lastNameController = TextEditingController(text: aUser.lastName);
    passwordController = TextEditingController(text: aUser.password);

    // Set Current UserType()
    if (widget.argUserObject.userType == null)
      userType = Constants.UserTypeEnum.SystemAdmin;
    else
      userType = widget.argUserObject.userType;

    stayConnected = widget.argUserObject.stayConnected;
  }
  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = true;

    return validationVal;
  }
  //#endregion

  //#region Update User
  Future updateUser(RotaryUsersListBloc aUserBloc) async {

    setState(() {loading = true;});

    bool validationVal = await checkValidation();

    if (validationVal){

      String _emailId = (eMailController.text != null) ? (eMailController.text) : '';
      String _firstName = (firstNameController.text != null) ? (firstNameController.text) : '';
      String _lastName = (lastNameController.text != null) ? (lastNameController.text) : '';
      String _password = (passwordController.text != null) ? (passwordController.text) : '';
      Constants.UserTypeEnum _userType = userType;
      bool _stayConnected = stayConnected;

      UserObject newUserObj =
      userService.createUserAsObject(
          widget.argUserObject.userId, '',
          _emailId, _firstName, _lastName,
          _password, _userType, _stayConnected);

      /// 1. Update Database
      aUserBloc.updateUserById(widget.argUserObject, newUserObj);

      /// If the USER is also the CURRENT user:
      var userGlobal = ConnectedUserGlobal();
      ConnectedUserObject currentConnectedUserObj = userGlobal.getConnectedUserObject();
      if (newUserObj.userId == currentConnectedUserObj.userId)
      {
        /// 2. App Global: Update Global Current Connected User
        ConnectedUserObject newConnectedUserObj = await ConnectedUserObject.getConnectedUserObjectFromUserObject(newUserObj);
        userGlobal.setConnectedUserObject(newConnectedUserObj);

        /// 3. Secure storage: Update only if it's the Current user
        ConnectedUserService _connectedUserService = ConnectedUserService();
        await _connectedUserService.writeConnectedUserObjectDataToSecureStorage(newConnectedUserObj);
      }

      Navigator.pop(context, newUserObj);
    }
    setState(() {loading = false;});
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[50],

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
              height: 180,
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
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
                  width: double.infinity,
                  child: buildUserDetailDisplay()
              ),
            ),
          ]
      ),
    );
  }

  /// ====================== Event All Fields ==========================
  Widget buildUserDetailDisplay() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
              width: double.infinity,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    /// ------------------- Input Text Fields ----------------------
                    buildEnabledDoubleTextInputWithImageIcon(
                        firstNameController, 'First Name',
                        lastNameController, 'Last Name',
                        Icons.person),
                    buildEnabledTextInputWithImageIcon(eMailController, 'Email', Icons.mail_outline),
                    buildEnabledTextInputWithImageIcon(passwordController, 'Password', Icons.lock),
                    buildUserTypeRadioButton(),
                    buildStayConnectedCheckBox(),

                  ],
                ),
              ),
            ),
          ),
        ),

        buildUpdateButton('שמירה', Icons.save, updateUser),
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

  //#region Build Enabled TextInput With ImageIcon
  Widget buildEnabledTextInputWithImageIcon(
      TextEditingController aController, String textInputName, IconData aIcon,
      {bool aMultiLine = false, bool aEnabled = true}) {
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
                child: buildTextFormField(aController, textInputName, aMultiLine: aMultiLine, aEnabled: aEnabled),
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region Build Enabled Double TextInput With ImageIcon
  Widget buildEnabledDoubleTextInputWithImageIcon(
      TextEditingController aController1, String textInputName1,
      TextEditingController aController2, String textInputName2,
      IconData aIcon, {bool aMultiLine = false, bool aEnabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: buildImageIconForTextField(aIcon),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: buildTextFormField(aController1, textInputName1, aMultiLine: aMultiLine, aEnabled: aEnabled),
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: buildTextFormField(aController2, textInputName2, aMultiLine: aMultiLine, aEnabled: aEnabled),
                ),
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region Build Image Icon For Text Field
  MaterialButton buildImageIconForTextField(IconData aIcon) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () {},
      color: Colors.blue[10],
      textColor: Colors.white,
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
          size: 20,
        ),
      ),
    );
  }
  //#endregion

  //#region Build Text Form Field
  TextFormField buildTextFormField(
      TextEditingController aController,
      String textInputName,
      {bool aMultiLine = false, bool aEnabled = true}) {
    return TextFormField(
      keyboardType: aMultiLine ? TextInputType.multiline : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: aEnabled
          ? TextInputDecoration.copyWith(hintText: textInputName)
          : DisabledTextInputDecoration.copyWith(hintText: textInputName), // Disabled Field
      validator: (val) => val.isEmpty ? 'Enter $textInputName' : null,
      enabled: aEnabled,
    );
  }
  //#endregion

  //#region Build UserType Radio Button
  Widget buildUserTypeRadioButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        // textDirection: TextDirection.rtl,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              'סוג משתמש:',
              style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <UserTypeLabelRadio>[
                UserTypeLabelRadio(
                  label: 'מנהל מערכת',
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  value: Constants.UserTypeEnum.SystemAdmin,
                  groupValue: userType,
                  onChanged: (Constants.UserTypeEnum newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                ),
                UserTypeLabelRadio(
                  label: 'חבר מועדון רוטרי',
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  value: Constants.UserTypeEnum.RotaryMember,
                  groupValue: userType,
                  onChanged: (Constants.UserTypeEnum newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                ),
                UserTypeLabelRadio(
                  label: 'אורח',
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  value: Constants.UserTypeEnum.Guest,
                  groupValue: userType,
                  onChanged: (Constants.UserTypeEnum newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Build Stay Connected CheckBox
  Widget buildStayConnectedCheckBox() {
    return InkWell(
      onTap: () {
        setState(() {
          stayConnected = !stayConnected;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Color(0xfff3f3f4)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: stayConnected ?
                  Icon(Icons.check, size: 15.0, color: Colors.black,) :
                  Icon(Icons.check_box_outline_blank, size: 15.0, color: Colors.white,),
                ),
              ),
            ),
            Text(
              'הישאר מחובר',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
  //#endregion

  //#region Build Update Button
  Widget buildUpdateButton(String aButtonText, IconData aIcon, Function aFunc) {

    final usersBloc = BlocProvider.of<RotaryUsersListBloc>(context);

    return StreamBuilder<List<UserObject>>(
      stream: usersBloc.usersStream,
      initialData: usersBloc.usersList,
      builder: (context, snapshot) {
        // List<UserObject> currentUsersList =
        // (snapshot.connectionState == ConnectionState.waiting)
        //     ? usersBloc.usersList
        //     : snapshot.data;

        return Padding(
          padding: const EdgeInsets.only(right: 120.0, left: 120.0),
          child: ActionButtonDecoration(
              argButtonType: ButtonType.Decorated,
              argHeight: 40.0,
              argButtonText: aButtonText,
              argIcon: aIcon,
              onPressed: () {
                aFunc(usersBloc);
              }),
        );
      }
    );
  }
  //#endregion
}
