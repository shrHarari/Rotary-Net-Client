import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rotary_net/services/menu_pages_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/utils/utils_class.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/AboutScreen';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String aboutContent ="";
  Map<String, Object> aboutContentMap;
  Future<Map<String, Object>> aboutContentMapForBuild;

  @override
  void initState() {
    aboutContentMapForBuild = getMenuAboutContent();
    super.initState();
  }

  Future<Map<String, Object>> getMenuAboutContent() async {
    MenuPagesService menuPagesService = MenuPagesService();
    dynamic aContent = await menuPagesService.getMenuPageContentByPageName("AboutContent");

    return aContent;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Object>>(
        future: aboutContentMapForBuild,
        builder: (context, snapshot) {
          if (snapshot.hasData) aboutContentMap = snapshot.data;

          return  Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[

                /// --------------- Screen Header Area ---------------------
                buildAboutScreenHeader(),

                (snapshot.connectionState == ConnectionState.waiting) ?
                Container(child: Loading()) :

                (snapshot.hasError) ?
                Container(
                  child: DisplayErrorText(
                    errorText: 'דף אודות חסר',
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
                                text: Utils.convertTextBreakLineFromDB(aboutContentMap['line1']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.black87
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(aboutContentMap['line2']),
                                style: TextStyle(
                                  fontFamily: 'Heebo-Light',
                                  fontSize: 18.0,
                                  height: 1.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: Utils.convertTextBreakLineFromDB(aboutContentMap['line3']),
                                style: TextStyle(
                                    fontFamily: 'Heebo-Light',
                                    fontSize: 18.5,
                                    height: 1.5,
                                    color: Colors.black87
                                ),
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
            ),
        );
      },
    );
  }

  Widget buildAboutScreenHeader() {
  return
    Container(
      height: 120,
      color: Colors.lightBlue[400],
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                'מדיניות הפרטיות',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0),
              ),
            ),

            /// Menu Icon
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10.0, 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close, color: Colors.white, size: 26.0,),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}
