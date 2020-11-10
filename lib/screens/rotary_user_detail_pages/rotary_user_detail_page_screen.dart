import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/rotary_user_detail_pages/rotary_user_detail_edit_page_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';

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
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    /// ----------- Header - First line - Application Logo -----------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
            children: <Widget>[
              Expanded(
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
              Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: IconButton(
                  icon: Icon(Icons.mode_edit, color: Colors.grey[900]),
                  onPressed: () {
                    openUserDetailEditScreen(aUserObj);
                  },
                ),
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
                      buildDetailImageIcon(Icons.language, aUserObj.userId),
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

        _buildDeleteUserButton('מחק משתמש', Icons.delete_sweep),

      ],
    );
  }

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

  Widget _buildDeleteUserButton(String buttonText, IconData aIcon) {

    final usersBloc = BlocProvider.of<RotaryUsersListBloc>(context);

    return StreamBuilder<List<UserObject>>(
        stream: usersBloc.usersStream,
        initialData: usersBloc.usersList,
        builder: (context, snapshot) {
          List<UserObject> currentUsersList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? usersBloc.usersList
              : snapshot.data;

          return RaisedButton.icon(
            onPressed: () {
              usersBloc.deleteUserById(displayUserObject);
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            label: Text(
              buttonText,
              style: TextStyle(
                  color: Colors.white,fontSize: 16.0
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
}
