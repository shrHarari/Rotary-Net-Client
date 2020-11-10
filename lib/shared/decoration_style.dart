import 'package:flutter/material.dart';

const TextInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
  ),
);


const DisabledTextInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
  fillColor: Color(0xFFEEEEEE),
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 1.0),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  ),
);

