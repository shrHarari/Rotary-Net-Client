import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:rotary_net/screens/rotary_user_detail_pages/rotary_user_detail_edit_page_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';
import 'package:rotary_net/shared/update_button_decoration.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class RotaryUserDetailPageScreen extends StatefulWidget {
  static const routeName = '/RotaryUserDetailPageScreen';
  final UserObject argUserObject;

  RotaryUserDetailPageScreen({Key key, @required this.argUserObject}) : super(key: key);

  @override
  _RotaryUserDetailPageScreenState createState() => _RotaryUserDetailPageScreenState();
}

class _RotaryUserDetailPageScreenState extends State<RotaryUserDetailPageScreen> {

  UserObject displayUserObject;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String error = '';
  bool loading = false;

  @override
  void initState() {
    displayUserObject = widget.argUserObject;
    super.initState();
  }

  //region Open User Detail Edit Screen
  void openUserDetailEditScreen(UserObject aUserObj) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailEditPageScreen(argUserObject: aUserObj),
      ),
    );

    if (result != null) {
      setState(() {
        displayUserObject = result;
      });
    }
  }
  //endregion

  //#region Delete User
  Future deleteUser(RotaryUsersListBloc aUserBloc) async {
    aUserBloc.deleteUserById(displayUserObject);
    Navigator.pop(context);
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
      width: double.infinity,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// --------------- Title Area ---------------------
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
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                width: double.infinity,
                child: buildUserDetailDisplay(displayUserObject),
              ),
            ),
          ]
      ),
    );
  }

  /// ====================== User All Fields ==========================
  Widget buildUserDetailDisplay(UserObject aUserObj) {

    return Column(
      children: <Widget>[
        /// ------------------- User Name -------------------------
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          aUserObj.firstName + " " + aUserObj.lastName,
                          style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                  flex: 2,
                  child: buildEditEventButton(openUserDetailEditScreen, aUserObj)
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.only(left: 0.0, top: 20.0, right: 0.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  /// ---------------- User Details (Icon Images) --------------------
                  Column(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      buildDetailImageIcon(Icons.mail_outline, aUserObj.email, aFunc: Utils.sendEmail),
                      buildDetailImageIcon(Icons.lock, aUserObj.password),
                      buildStayConnectedCheckBox(),
                      buildUserTypeRadioButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        buildDeleteUserButton('הסרת משתמש', Icons.delete_sweep, deleteUser),

      ],
    );
  }

  //#region Build Edit Event Button
  Widget buildEditEventButton(Function aFunc, UserObject aUserObj) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () async {
        await aFunc(aUserObj);
      },
      color: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(side: BorderSide(color: Colors.blue)),
      child: IconTheme(
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

  //#region Build Detail Image Icon
  Row buildDetailImageIcon(IconData aIcon, String aTitle, {Function aFunc}) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(aTitle);},
              color: Colors.blue[10],
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
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            ),
          ),

          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                aTitle,
                style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 14.0),
              ),
            ),
          ),
        ]
    );
  }
  //#endregion

  //#region Build Stay Connected CheckBox
  Widget buildStayConnectedCheckBox() {
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
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(color: Colors.black, width: 1.0),
                  color: Color(0xfff3f3f4)
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: displayUserObject.stayConnected ?
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
    );
  }
  //#endregion

  //#region Build UserType Radio Button
  Widget buildUserTypeRadioButton() {
    String userTypeTitle;
    switch (displayUserObject.userType) {
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
  //#endregion

  //#region Build DeleteUser Button
  Widget buildDeleteUserButton(String aButtonText, IconData aIcon, Function aFunc) {

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
            padding: const EdgeInsets.only(right: 70.0, left: 70.0),
            child: UpdateButtonDecoration(
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
