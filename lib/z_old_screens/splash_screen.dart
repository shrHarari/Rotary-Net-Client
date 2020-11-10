import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/z_old_screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

const isOnBoardingFinished = 'isOnBoardingFinished';

class _SplashScreenState extends State<SplashScreen1> {
  Timer timer;
  bool isLoading = true;

  @override
  void initState() {
    getAllRequiredDataForBuild();
    super.initState();
  }

  Future<void> getAllRequiredDataForBuild() async {
    final prefs = await SharedPreferences.getInstance();
    var hasOpened = prefs.getBool(isOnBoardingFinished) ?? false;

    final ConnectedUserService connectedUserService = ConnectedUserService();
    ConnectedUserObject _connectedUserObj = await connectedUserService.readConnectedUserObjectDataFromSecureStorage();

    if (hasOpened) {
      prefs.remove(isOnBoardingFinished);
      goToHomePage();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  goToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomePage(),
      ),
    );
  }

  Future<void> handleClose() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isOnBoardingFinished, true);
    goToHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container() : handleClose();
  }
}
