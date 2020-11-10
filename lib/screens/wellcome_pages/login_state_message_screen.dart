import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/shared/circle_button.dart';
import 'package:rotary_net/shared/loading.dart';

class LoginStateMessageScreen extends StatefulWidget {
  static const routeName = '/LoginStateMessageScreen';
  final ConnectedUserObject argConnectedUserObject;

  LoginStateMessageScreen({Key key, @required this.argConnectedUserObject}) : super(key: key);

  @override
  _LoginStateMessageScreen createState() => _LoginStateMessageScreen();
}

class _LoginStateMessageScreen extends State<LoginStateMessageScreen> {

  ConnectedUserObject currentConnectedUserObj;
  String appBarTitle = 'רוטרי / אישור בקשה';
  String iconBarTitle = 'יציאה';
  String currentConnectedUserData = '';
  String messageTitle = '';
  String messageBody = '';
  bool loading = true;
  bool isShowDataForDebug = false;

  @override
  void initState() {

    getConnectedUserObject().then((value) {
      setState(() {
        currentConnectedUserObj = value;
        createDataToDisplay();
      });
    });
    super.initState();
  }

  Future<ConnectedUserObject> getConnectedUserObject() async {
    var _userGlobal = ConnectedUserGlobal();
    ConnectedUserObject _connectedUserObj = _userGlobal.getConnectedUserObject();
    return _connectedUserObj;
  }

  Future<Null> createDataToDisplay() async {

    if (currentConnectedUserObj.email == null)
    {
      setState(() {
        currentConnectedUserData = 'שגיאה ברישום נתונים';
        loading = false;
      });
    } else {
      setState(() {
        messageTitle = 'שלום '
            '${currentConnectedUserObj.firstName} '
            '${currentConnectedUserObj.lastName},';
        messageBody = 'מנהלי המערכת מטפלים בבקשתך.\n\n'
            'אנא המתן ואנו נשלח אליך מייל לאישור בקשתך\n';

        currentConnectedUserData = 'User Data To Display: \n'
            'User Guid Id: ${currentConnectedUserObj.userId}\n'
            'User EmailId: ${currentConnectedUserObj.email}\n'
            'User Name: ${currentConnectedUserObj.firstName} '
                       '${currentConnectedUserObj.lastName}\n'
            'User Password: ${currentConnectedUserObj.password}\n';
        loading = false;
      });
    }
  }

  Future<void> openDebugSettings() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebugSettingsScreen(),
      ),
    );
  }

  void exitFromApp() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() :
    Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[500],
          elevation: 5.0,
          title: Text(appBarTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.build, color: Colors.white),
              onPressed: () async {await openDebugSettings();},
            ),
            FlatButton.icon(
                onPressed: () {
                  exitFromApp();
                },
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                label: Text(iconBarTitle,
                  style: TextStyle(color: Colors.white),
                )
            )
          ],
        ),

        body: buildMainScaffoldBody()
    );
  }

  Widget buildMainScaffoldBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Container(
                      color: Colors.blue[50],
                      child: Text(messageTitle,
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                onDoubleTap: () {
                  setState(() {
                    isShowDataForDebug = !isShowDataForDebug;
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 60, left: 30.0, right: 30.0),
                child: Center(
                  child: Container(
                    color: Colors.blue[50],
                    child: Text(messageBody,
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ),

              ///--------------------- Circle Button ---------------------
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: CircleButton(
                    buttonText: 'OK',
                    backgroundButtonSize: 140.0,
                    foregroundButtonSize: 120.0,
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    onTap: exitFromApp
                ),
              ),

              Visibility(
                visible: isShowDataForDebug,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    color: Colors.white,
                    child: Text(
                      currentConnectedUserData,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}

