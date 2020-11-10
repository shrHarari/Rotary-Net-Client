import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget rotaryTitle(BuildContext context) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
        text: 'Rotary',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w700,
//          color: Color(0xffe46b10),
          color: Colors.lightBlue[600],
        ),
        children: [
          TextSpan(
            text: 'Net',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ]),
  );
}

Widget loginTextEditField(String title, TextDirection aTextDirection, {bool isPassword = false}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          textDirection: aTextDirection,
            obscureText: isPassword,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true)
        )
      ],
    ),
  );
}


Widget backButton(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
          ),
          Text('חזרה',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
        ],
      ),
    ),
  );
}

BoxDecoration actionButtonBoxDecoration() {
  return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.grey.shade200,
            offset: Offset(2, 4),
            blurRadius: 5,
            spreadRadius: 2)
      ],
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
//          colors: [Color(0xfffbb448), Color(0xfff7892b)]
          colors: [Colors.lightBlue[200], Colors.lightBlue[600]]
      )
  );
}