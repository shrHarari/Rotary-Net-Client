import 'package:flutter/material.dart';
import 'package:rotary_net/shared/page_header_title_logo.dart';

class RotaryMainPageHeaderTitle extends StatelessWidget {

  RotaryMainPageHeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: PageHeaderTitleLogo(),
            ),
          ],
        ),
      ),
    );
  }
}
