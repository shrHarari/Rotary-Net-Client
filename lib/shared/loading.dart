import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[50],
      child: Center(
        child: SpinKitWave(
          color: Colors.teal[900],
          size: 50.0,
        ),
      ),
    );
  }
}

class EventImagePickerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      color: Colors.lightBlue[50],
      child: Center(
        child: SpinKitCircle(
          color: Colors.teal[900],
          size: 50.0,
        ),
      ),
    );
  }
}

class EventImageTileLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      color: Colors.lightBlue[50],
      child: Center(
        child: SpinKitCircle(
          color: Colors.teal[900],
          size: 50.0,
        ),
      ),
    );
  }
}

class PersonCardImageTileLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      color: Colors.lightBlue[50],
      child: Center(
        child: SpinKitCircle(
          color: Colors.teal[900],
          size: 50.0,
        ),
      ),
    );
  }
}