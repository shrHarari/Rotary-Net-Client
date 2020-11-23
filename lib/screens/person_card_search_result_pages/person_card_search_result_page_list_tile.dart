import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/person_card_image_avatar.dart';

class PersonCardSearchResultPageListTile extends StatefulWidget {
  static const routeName = '/PersonCardSearchResultPageListTile';
  final PersonCardObject argPersonCardObject;

  const PersonCardSearchResultPageListTile({Key key, this.argPersonCardObject}) : super(key: key);

  @override
  _PersonCardSearchResultPageListTileState createState() => _PersonCardSearchResultPageListTileState();
}

class _PersonCardSearchResultPageListTileState extends State<PersonCardSearchResultPageListTile> {

  PersonCardObject displayPersonCardObject;
  bool loading = true;

  @override
  void initState() {
    displayPersonCardObject = widget.argPersonCardObject;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => executeAfterBuildComplete(context));
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   WidgetsBinding.instance.addPostFrameCallback((_) => executeAfterBuildComplete(context));
  // }

  executeAfterBuildComplete(BuildContext context){
    setState(() {
      loading = false;
    });
  }

  //#region Open Person Card Detail Screen
  openPersonCardDetailScreen(BuildContext context) async {
    final returnPersonCardDataMap = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailPageScreen(
            argPersonCardObject: widget.argPersonCardObject
        ),
      ),
    );

    if (returnPersonCardDataMap != null) {
      setState(() {
        displayPersonCardObject = returnPersonCardDataMap["PersonCardObject"];
      });
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? PersonCardImageTileLoading()
      : Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 0.0, right: 15.0, bottom: 5.0),
        child: GestureDetector(
          child: Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: Colors.blue[300],
            ),

            child: Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Colors.grey[50],
              ),

              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  PersonCardImageAvatar(
                    argPersonCardPictureUrl: displayPersonCardObject.pictureUrl,
                    argIcon: Icons.person
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              displayPersonCardObject.firstName + " " + displayPersonCardObject.lastName,
                              style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            displayPersonCardObject.address,
                            style: TextStyle(color: Colors.grey[900], fontSize: 12.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: ()
          {
            // Hide Keyboard
            FocusScope.of(context).requestFocus(FocusNode());
            openPersonCardDetailScreen(context);
          },
        ),
      );
  }
}
