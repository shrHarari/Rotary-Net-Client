import 'package:flutter/material.dart';
import 'package:rotary_net/shared/page_header_title_logo.dart';

class PageHeaderApplicationMenu extends StatelessWidget {
  final bool argDisplayTitleLogo;               // True: Display Application Logo
  final bool argDisplayTitleLabel;              // True: Display Page Label (without Logo)
  final String argTitleLabelText;               // Label Text
  final bool argDisplayApplicationMenu;         // True: Display Menu Icon
  final Function argApplicationMenuFunction;    // Function to execute with menu
  final bool argDisplayExit;                    // True: Exit Icon || False: Back Icon (with return Value)
  final Function argReturnFunction;             // Function to execute in case of Back Icon

  PageHeaderApplicationMenu({
    @required this.argDisplayTitleLogo,
    @required this.argDisplayTitleLabel,
    this.argTitleLabelText,
    @required this.argDisplayApplicationMenu,
    this.argApplicationMenuFunction,
    @required this.argDisplayExit,
    this.argReturnFunction
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          /// ----------- Header - First line - Application Logo -----------------
          if (argDisplayTitleLogo)
            Center(
              child: PageHeaderTitleLogo()
            ),
          if (argDisplayTitleLabel)
            Center(
              child: Text(
                argTitleLabelText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0),
              ),
            ),
          /// --------------- Application Menu ---------------------
          if (argDisplayApplicationMenu)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20.0, right: 0.0, bottom: 0.0),
                child: IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () async {await argApplicationMenuFunction();},
                ),
              ),
            ),

          if (argDisplayExit)
          /// Exit Icon --->>> Back to previous screen
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 20.0, right: 10.0, bottom: 0.0),
                child: IconButton(
                  icon: Icon(
                  Icons.close, color: Colors.white, size: 26.0,),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          else
            Align(
              /// Back Icon --->>> Back to previous screen with Return Data
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 20.0, right: 10.0, bottom: 0.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {argReturnFunction();}
                ),
              ),
            ),
        ],
      ),
    );
  }
}
