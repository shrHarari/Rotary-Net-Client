import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/BLoCs/person_cards_list_bloc.dart';

class PersonCardSearchResultPageHeaderSearchBox implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  PersonCardsListBloc personCardsBloc;
  TextEditingController searchController;

  PersonCardSearchResultPageHeaderSearchBox({
    @required this.minExtent,
    @required this.maxExtent,
    @required this.personCardsBloc,
    @required this.searchController,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: Colors.lightBlue[400],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 10.0, right: 50.0, bottom: 10.0),
          child: TextField(
            maxLines: 1,
            controller: searchController,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.search,
            style: TextStyle(
                fontSize: 14.0,
                height: 0.8,
                color: Colors.black
            ),
            // onSubmitted: (searchText) {bloc.getPersonCardsListBySearchQuery(searchText);},
            onChanged: (searchText) {personCardsBloc.getPersonCardsListBySearchQuery(searchText);},
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.blue,
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    personCardsBloc.getPersonCardsListBySearchQuery(searchController.text);
                  },
                ),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "מילת חיפוש",
                fillColor: Colors.white
            ),
          ),
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
