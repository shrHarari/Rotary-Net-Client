import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/register_screen.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/registration_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';

class Wrapper extends StatefulWidget {
  static const routeName = '/Wrapper';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  final ConnectedUserService connectedUserService = ConnectedUserService();
  final RegistrationService registrationService = RegistrationService();

  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;
  bool loading = true;

  @override
  void initState() {
    dataRequiredForBuild = getAllRequiredDataForBuild();
    super.initState();
  }

  //#region Get All Required Data For Build
  Future<DataRequiredForBuild> getAllRequiredDataForBuild() async {
    setState(() {
      loading = true;
    });

    ConnectedUserObject _connectedUserObj = await initializeConnectedUserObject();

    setState(() {
      loading = false;
    });

    return DataRequiredForBuild(
      connectedUserObj: _connectedUserObj,
    );
  }
  //#endregion

  //#region Initialize Connected UserObject [CONNECTED USER]
  Future <ConnectedUserObject> initializeConnectedUserObject() async {
    var userGlobal = ConnectedUserGlobal();

    ConnectedUserObject _currentConnectedUserObj = userGlobal.getConnectedUserObject();
    print('Wrapper / _currentConnectedUserObj: $_currentConnectedUserObj');
    return _currentConnectedUserObj;
  }
  //#endregion

  //#endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return getPageByConnectedUserStatus(
                    currentDataRequired.connectedUserObj);
              }
              else
                return Center(child: Text('אין תוצאות'));
            }
        }
      ),
    );
  }

  //#region Get Page By ConnectedUser Status
  Widget getPageByConnectedUserStatus(ConnectedUserObject aConnectedUserObject) {

    if (aConnectedUserObject == null) {
      return RegisterScreen();
    }
    else {
      if ((aConnectedUserObject.stayConnected == null) || (!aConnectedUserObject.stayConnected))
        return LoginScreen();
      else
        return RotaryMainPageScreen();
    }
  }
  //#endregion
}

class DataRequiredForBuild {
  ConnectedUserObject connectedUserObj;

  DataRequiredForBuild({
    this.connectedUserObj,
  });
}
