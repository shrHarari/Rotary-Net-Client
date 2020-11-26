import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:rotary_net/services/menu_pages_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  static const routeName = '/PrivacyPolicyScreen';

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String privacyPolicyContent ="";
  Future<Map<String, Object>> privacyPolicyContentMapForBuild;
  Map<String, Object> privacyPolicyContentMap;

  @override
  void initState() {
    privacyPolicyContentMapForBuild = getMenuPrivacyPolicyContent();
    super.initState();
  }

  Future<Map<String, Object>> getMenuPrivacyPolicyContent() async {
    MenuPagesService menuPagesService = MenuPagesService();
    dynamic aContent = await menuPagesService.getMenuPageContentByPageName("PrivacyPolicyContent");

    return aContent;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Object>>(
      future: privacyPolicyContentMapForBuild,
      builder: (context, snapshot) {
        if (snapshot.hasData) privacyPolicyContentMap = snapshot.data;

        return  Scaffold(
          backgroundColor: Colors.white,
          body:Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// --------------- Screen Header Area ---------------------
                buildPrivacyPolicyScreenHeader(),

                (snapshot.connectionState == ConnectionState.waiting) ?
                  Container(child: Loading()) :

                (snapshot.hasError) ?
                Container(
                  child: DisplayErrorText(
                    errorText: 'דף מדיניות הפרטיות חסר',
                  ),
                ) :

                (snapshot.hasData) ?
                Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40.0, 50.0, 40.0, 50.0),

                        child: RichText(
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(privacyPolicyContentMap['rotary_introduction_start']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.black87
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(privacyPolicyContentMap['rotary_introduction_service']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 17.0,
                                    height: 1.7,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(privacyPolicyContentMap['rotary_introduction_end']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.black87
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(privacyPolicyContentMap['privacy_introduction']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.black87
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(privacyPolicyContentMap['add_line_1']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.black87
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(privacyPolicyContentMap['add_line_2']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.black87
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(privacyPolicyContentMap['rotary_privacy_condition']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.black87
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(privacyPolicyContentMap['rotary_privacy_condition_mail']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                ),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {launch('https://he.wikipedia.org/wiki/%D7%A8%D7%95%D7%98%D7%A8%D7%99');},
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ) :

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                    width: double.infinity,
                    child: Center(child: Text('אין תוצאות')),
                  ),
                ),
              ],
            )
          )
        );
      },
    );
  }

  Widget buildPrivacyPolicyScreenHeader() {
  return
    Container(
      height: 120,
      color: Colors.lightBlue[400],
      child: PageHeaderApplicationMenu(
        argDisplayTitleLogo: false,
        argDisplayTitleLabel: true,
        argTitleLabelText: 'מדיניות הפרטיות',
        argDisplayApplicationMenu: false,
        argDisplayExit: true,
        argApplicationMenuFunction: null,
        argReturnFunction: null,
      ),
    );
  }
}
