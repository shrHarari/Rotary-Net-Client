import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/shared/page_header_title_logo.dart';

class RotaryUsersListPageHeaderTitle implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;

  RotaryUsersListPageHeaderTitle({
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
            /// ----------- Header - First line - Application Logo -----------------
            Align(
              alignment: Alignment.center,
              child: PageHeaderTitleLogo(),
            ),
          ],
        ),
      ),
    );
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
