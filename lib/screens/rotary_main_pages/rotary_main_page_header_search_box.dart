import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RotaryMainPageHeaderSearchBox extends StatelessWidget {
  final TextEditingController searchController;
  final Function argExecuteSearchFunc;

  RotaryMainPageHeaderSearchBox({
    this.searchController,
    this.argExecuteSearchFunc,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      // color: Colors.lightBlue[400],
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          /// ----------- Header - Second line - Search Box Area -----------------
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
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
                    //onSubmitted: (value) async {await executeSearch(value);},
//                    onChanged: (value) async {setSearchTextValueFunc(value);},
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.blue,
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            argExecuteSearchFunc(searchController.text);
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
            ],
          ),
        ],
      ),
    );
  }
}
