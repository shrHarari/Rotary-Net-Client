import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/rotary_user_detail_pages/rotary_user_detail_page_screen.dart';

class RotaryUsersListPageTile extends StatelessWidget {
  final UserObject argUserObj;
  final String argSearchText;

  RotaryUsersListPageTile({Key key, this.argUserObj, this.argSearchText}) : super(key: key);

  //#region Open User Detail Screen
  openUserDetailScreen(BuildContext context) async {

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            RotaryUserDetailPageScreen(
                argUserObject: argUserObj
            ),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 5.0),
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
          Container(
            width: double.infinity,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
            ),

          Container(
            child: Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                // CircleAvatar(
                //   radius: 30.0,
                //   backgroundColor: Colors.blue[900],
                //   backgroundImage: userImage,
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                        child: RichText(
                            text: TextSpan(
                              children: highlightOccurrences(argUserObj.firstName + " " + argUserObj.lastName, argSearchText),
                              style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      Text(
                        argUserObj.email,
                        style: TextStyle(color: Colors.grey[900], fontSize: 12.0, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
              bottom: 20.0,
              child: buildDeleteUserButton(context)
            ),
          ],
        ),
        onTap: ()
        {
          // Hide Keyboard
          FocusScope.of(context).requestFocus(FocusNode());
          print("argUserObj: $argUserObj");
          openUserDetailScreen(context);
        },
      ),
    );
  }

  //#region Highlight Occurrences
  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null || query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [ TextSpan(text: source) ];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
  //#endregion

  //#region Build Delete User Button
  Widget buildDeleteUserButton(BuildContext context) {
    final bloc = BlocProvider.of<RotaryUsersListBloc>(context);
    return StreamBuilder<List<UserObject>>(
      stream: bloc.usersStream,
      initialData: bloc.usersList,
      builder: (context, snapshot) {
        List<UserObject> currentUsersList =
        (snapshot.connectionState == ConnectionState.waiting)
            ? bloc.usersList
            : snapshot.data;

        return MaterialButton(
          onPressed: () async {
            await bloc.deleteUserById(argUserObj);
          },
          color: Colors.white,
          shape: CircleBorder(side: BorderSide(color: Colors.blue)),
          child:
          IconTheme(
            data: IconThemeData(
              color: Colors.black,
            ),
            child: Icon(
              Icons.delete,
              size: 20,
            ),
          ),
        );
      },
    );
  }
  //#endregion
}
