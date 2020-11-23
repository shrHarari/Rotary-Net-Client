import 'package:flutter/material.dart';

class PersonCardImageAvatar extends StatelessWidget {

  final String argPersonCardPictureUrl;
  final IconData argIcon;
  final Function argOnTapFunction;

  const PersonCardImageAvatar({
    this.argPersonCardPictureUrl,
    this.argIcon,
    this.argOnTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    if (argOnTapFunction == null)
      {
        return (argPersonCardPictureUrl == null) || (argPersonCardPictureUrl == '')
            ? buildEmptyPersonCardImageIcon(argIcon)
            : buildPersonCardAvatar();
      } else {
        return InkWell(
          onTap: () async { await argOnTapFunction(); },
          child: (argPersonCardPictureUrl == null) || (argPersonCardPictureUrl == '')
              ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: buildEmptyPersonCardImageIcon(argIcon)
          )
              : Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: buildPersonCardAvatar()
          ),
        );
      }
  }

  //#region Build PersonCard Avatar
  Widget buildPersonCardAvatar() {
    return Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xFFF05A22),
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),

      child: CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(argPersonCardPictureUrl),
      ),
    );
  }
  //#endregion

  //#region Build Empty PersonCard Image Icon
  Widget buildEmptyPersonCardImageIcon(IconData aIcon) {
    return Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFFF05A22),
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),

        child: Center(
          child: Icon(aIcon,
            size: 30.0,
            color: Color(0xFFF05A22),
          ),
        )
    );
  }
//#endregion

}