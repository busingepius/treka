import 'package:flutter/material.dart';

class RouteModel {
  final String points;
  final Distance distance;
  final TimeNeeded timeNeeded;
  final String startAddress;
  final String endAddress;

  RouteModel(
      {@required this.points,
      @required this.distance,
      @required this.timeNeeded,
      @required this.startAddress,
      @required this.endAddress});
}

class Distance {
  String text;
  int value;

  Distance({this.text, this.value});

  Distance.fromMap(Map data) {
    text = data["text"];
    value = data["value"];
  }
}

class TimeNeeded {
  String text;
  int value;

  TimeNeeded({this.value, this.text});

  TimeNeeded.fromMap(Map data) {
    text = data["text"];
    value = data["value"];
  }
}
