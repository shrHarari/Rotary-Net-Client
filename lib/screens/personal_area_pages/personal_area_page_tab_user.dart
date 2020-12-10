import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/action_button_decoration.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class PersonalAreaPageTabUser extends StatefulWidget {
  final ConnectedUserObject argConnectedUser;

  PersonalAreaPageTabUser({Key key, @required this.argConnectedUser}) : super(key: key);

  @override
  _PersonalAreaPageTabUserState createState() => _PersonalAreaPageTabUserState();
}

class _PersonalAreaPageTabUserState extends State<PersonalAreaPageTabUser> {

  final ConnectedUserService connectedUserService = ConnectedUserService();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setPersonCardVariables(widget.argConnectedUser);
    super.initState();
  }

  //#region Declare Variables
  bool newStayConnected;

  TextEditingController eMailController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController passwordController;

  String error = '';
  bool loading = false;
  String updateStatus;
  //#endregion

  //#region Set PersonCard Variables
  Future<void> setPersonCardVariables(ConnectedUserObject aConnectedUserObj) async {
    eMailController = TextEditingController(text: aConnectedUserObj.email);
    firstNameController = TextEditingController(text: aConnectedUserObj.firstName);
    lastNameController = TextEditingController(text: aConnectedUserObj.lastName);
    passwordController = TextEditingController(text: aConnectedUserObj.password);
    newStayConnected = aConnectedUserObj.stayConnected;
  }
  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = true;

    if (formKey.currentState.validate()){
    }
    return validationVal;
  }
  //#endregion

  //#region Update User
  Future updateUser() async {

    setState(() {loading = true;});

    bool validationVal = await checkValidation();

    if (validationVal){
      String _email = (eMailController.text != null) ? (eMailController.text) : '';
      String _firstName = (firstNameController.text != null) ? (firstNameController.text) : '';
      String _lastName = (lastNameController.text != null) ? (lastNameController.text) : '';
      String _password = (passwordController.text != null) ? (passwordController.text) : '';

      ConnectedUserObject newConnectedUserObj = connectedUserService.createConnectedUserAsObject(
          widget.argConnectedUser.userId,
          widget.argConnectedUser.personCardId,
          _email, _firstName, _lastName, _password,
          widget.argConnectedUser.userType, newStayConnected);

      /// SAVE ConnectedUser:
      /// 1. Secure Storage: Write to SecureStorage
      await connectedUserService.writeConnectedUserObjectDataToSecureStorage(newConnectedUserObj);

      /// 2. App Global: Update Global Current Connected User
      var userGlobal = ConnectedUserGlobal();
      userGlobal.setConnectedUserObject(newConnectedUserObj);

      /// 3. DataBase: Update the User Data
      UserObject _usrObj = await  UserObject.getUserObjectFromConnectedUserObject(newConnectedUserObj);
      UserService _userService = UserService();
      _userService.updateUserById(_usrObj);

      Navigator.pop(context, newConnectedUserObj);
    }
    setState(() {loading = false;});
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Column(
      children: [
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.only(left: 30, top: 30.0, right: 10.0, bottom: 0.0),
              child: Column(
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        /// ------------------- Input Text Fields ----------------------
                        buildEnabledTextInputWithImageIcon(eMailController, 'דוא"ל', Icons.mail_outline, false),
                        buildEnabledDoubleTextInputWithImageIcon(
                            firstNameController, 'שם פרטי',
                            lastNameController, 'שם משפחה',
                            Icons.person, false),
                        buildEnabledTextInputWithImageIcon(passwordController, 'סיסמה', Icons.lock, false, isPassword: true),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30.0, bottom: 0.0),
                    child: Column(
                        children: [
                          buildStayConnectedCheckBox(),
                          buildUserTypeRadioButton(),
                        ]
                    ),
                  ),
                ],
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
              fontSize: 14.0
          ),
        ),
      ],
    );
  }

  Widget buildEnabledTextInputWithImageIcon(TextEditingController aController, String textInputName, IconData aIcon, bool aMultiLine, {bool aEnabled = true, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                  child: buildImageIconForTextField(aIcon)
              ),
            ),

            Expanded(
              flex: 12,
              child:
              Container(
                child: buildTextFormField(aController, textInputName, aMultiLine, aEnabled: aEnabled, isPassword: isPassword),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildEnabledDoubleTextInputWithImageIcon(
      TextEditingController aController1, String textInputName1,
      TextEditingController aController2, String textInputName2,
      IconData aIcon, bool aMultiLine) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.end,
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
                  child: buildTextFormField(aController1, textInputName1, aMultiLine),
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: buildTextFormField(aController2, textInputName2, aMultiLine),
                ),
              ),
            ),
          ]
      ),
    );
  }

  MaterialButton buildImageIconForTextField(IconData aIcon) {
    return MaterialButton(
      onPressed: () {},
      padding: EdgeInsets.all(5),
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

  TextFormField buildTextFormField(
      TextEditingController aController,
      String textInputName,
      bool aMultiLine,
      {bool aEnabled = true, bool isPassword = false}) {
    return TextFormField(
      keyboardType: aMultiLine ? TextInputType.multiline : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      enabled: aEnabled ? true : false,
      obscureText: isPassword,
      decoration: aEnabled
          ? TextInputDecoration.copyWith(
          hintText: textInputName,
          hintStyle: TextStyle(fontSize: 14.0)
      )
          : DisabledTextInputDecoration.copyWith(
          hintText: textInputName,
          hintStyle: TextStyle(fontSize: 14.0)
      ), // Disabled Field
      validator: (val) => val.isEmpty ? 'Enter $textInputName' : null,
    );
  }

  Widget buildStayConnectedCheckBox() {
    return InkWell(
      onTap: () {
        setState(() {
          newStayConnected = !newStayConnected;
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
                  child: newStayConnected ?
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

  Widget buildUserTypeRadioButton() {
    String userTypeTitle;
    switch (widget.argConnectedUser.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        userTypeTitle = "מנהל מערכת";
        break;
      case Constants.UserTypeEnum.RotaryMember:
        userTypeTitle = "חבר מועדון רוטרי";
        break;
      case Constants.UserTypeEnum.Guest:
        userTypeTitle = "אורח";
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.0),
                  color: Color(0xfff3f3f4)
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Icon(Icons.check, size: 15.0, color: Colors.black,),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'סוג משתמש:',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),

          Text(
            userTypeTitle,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  //#region Build Update Button
  Widget buildUpdateButton(String aButtonText, IconData aIcon, Function aFunc) {

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 120.0, left: 120.0),
      child: ActionButtonDecoration(
          argButtonType: ButtonType.Decorated,
          argHeight: 35.0,
          argButtonText: aButtonText,
          argIcon: aIcon,
          onPressed: () {
            aFunc();
          }),
    );
  }
  //#endregion
}
