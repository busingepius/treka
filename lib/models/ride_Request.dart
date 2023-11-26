import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequestModel {
  static const ID = "id";
  static const USERNAME = "username";
  static const USER_ID = "userId";
  static const DESTINATION = "destination";
  static const DESTINATION_LAT = "destination_latitude";
  static const DESTINATION_LNG = "destination_longitude";
  static const USER_LAT = "user_latitude";
  static const USER_LNG = "user_longitude";
  static const DISTANCE_TEXT = "distance_text";
  static const DISTANCE_VALUE = "distance_value";

  String id;
  String username;
  String userId;
  String destination;
  double dLatitude;
  double dLongitude;
  double uLatitude;
  double uLongitude;
  Distance distance;

  RideRequestModel(
      {this.username,
      this.userId,
      this.destination,
      this.id,
      this.distance,
      this.dLatitude,
      this.dLongitude,
      this.uLatitude,
      this.uLongitude});

  RideRequestModel.fromMap(Map data) {
    String _d = data[DESTINATION];
    id = data[ID];
    username = data[USERNAME];
    userId = data[USER_ID];
    destination = _d.substring(0, _d.indexOf(','));
    dLatitude = double.parse(data[DESTINATION_LAT]);
    dLongitude = double.parse(data[DESTINATION_LNG]);
    uLatitude = double.parse(data[USER_LAT]);
    uLongitude = double.parse(data[USER_LAT]);
    distance = Distance.fromMap({
      "text": data[DISTANCE_TEXT],
      "value": int.parse(data[DISTANCE_VALUE])
    });
  }
}

class Distance {
  String text;
  int value;

  Distance({this.value,this.text});

  Distance.fromMap(Map data) {
    text = data["text"];
    value = data["value"];
  }

  Map toJson() => {"text": text, "value": value};
}

class RequestModelFirebase {
  static const ID = "id";
  static const USERNAME = "username";
  static const USER_ID = "userId";
  static const DRIVER_ID = "driverId";
  static const STATUS = "status";
  static const POSITION = "position";
  static const DESTINATION = "destination";

  String id;
  String username;
  String userId;
  String driverId;
  String status;
  Map position;
  Map destination;

  RequestModelFirebase(
      {this.id,
      this.status,
      this.position,
      this.destination,
      this.driverId,
      this.userId,
      this.username});

  RequestModelFirebase.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data()[ID];
    username = snapshot.data()[USERNAME];
    userId = snapshot.data()[USER_ID];
    driverId = snapshot.data()[DRIVER_ID];
    status = snapshot.data()[STATUS];
    position = snapshot.data()[POSITION];
    destination = snapshot.data()[DESTINATION];
  }

  LatLng getCoordinates() =>
      LatLng(position['latitude'], position['longitude']);
}
