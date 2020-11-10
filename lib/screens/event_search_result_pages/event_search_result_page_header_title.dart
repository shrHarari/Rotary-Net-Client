import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class EventSearchResultPageHeaderTitle implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;

  EventSearchResultPageHeaderTitle({
    this.minExtent,
    @required this.maxExtent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: Colors.lightBlue[400],
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: MaterialButton(
                      elevation: 0.0,
                      onPressed: () {},
                      color: Colors.lightBlue.withOpacity(headerOpacity(shrinkOffset)),
                      textColor: Colors.white.withOpacity(headerOpacity(shrinkOffset)),
                      child: Icon(
                        Icons.account_balance,
                        size: 30,
                      ),
                      padding: EdgeInsets.all(20),
                      shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.white.withOpacity(headerOpacity(shrinkOffset)),
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(Constants.rotaryApplicationName,
                      style: TextStyle(
                          color: Colors.white.withOpacity(headerOpacity(shrinkOffset)),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double headerOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
//    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    return max(0.0, (minExtent-shrinkOffset)) / minExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration => null;

  @override
  TickerProvider get vsync => null;
}
