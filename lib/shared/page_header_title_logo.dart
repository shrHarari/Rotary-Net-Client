import 'package:flutter/material.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class PageHeaderTitleLogo extends StatelessWidget {

  PageHeaderTitleLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child:
          Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Constants.rotaryApplicationLogo),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Text(Constants.rotaryApplicationName,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );

    /////////////////////////////////////////////////////////////////////////////
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: <Widget>[
    //     Padding(
    //       padding: const EdgeInsets.only(top: 10.0),
    //       child: MaterialButton(
    //         elevation: 0.0,
    //         onPressed: () {},
    //         color: Colors.lightBlue.withOpacity(headerOpacity(shrinkOffset)),
    //         textColor: Colors.white.withOpacity(headerOpacity(shrinkOffset)),
    //         child: Icon(
    //           Icons.account_balance,
    //           size: 30,
    //         ),
    //         padding: EdgeInsets.all(20),
    //         shape: CircleBorder(
    //             side: BorderSide(
    //               color: Colors.white.withOpacity(headerOpacity(shrinkOffset)),
    //             )
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.only(top: 10.0),
    //       child: Text(
    //         Constants.rotaryApplicationName,
    //         style: TextStyle(
    //             color: Colors.white.withOpacity(headerOpacity(shrinkOffset)),
    //             fontSize: 14.0,
    //             fontWeight: FontWeight.bold
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
    //     double headerOpacity(double shrinkOffset) {
    //       // simple formula: fade out text as soon as shrinkOffset > 0
    // //    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    //       return max(0.0, (minExtent-shrinkOffset)) / minExtent;
    //       // more complex formula: starts fading out text when shrinkOffset > minExtent
    //       //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
    //     }
  }
}
