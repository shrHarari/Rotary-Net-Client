import 'package:flutter/material.dart';
import 'package:rotary_net/shared/page_header_application_menu.dart';

class PersonalAreaPageHeader extends StatelessWidget {
  const PersonalAreaPageHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
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
    );
  }
}
