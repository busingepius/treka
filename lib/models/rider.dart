import 'package:cloud_firestore/cloud_firestore.dart';

class RiderModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const PHONE = "phone";
  static const VOTES = "votes";
  static const TRIPS = "trips";
  static const RATING = "rating";
  static const TOKEN = "token";
  static const PHOTO = "photo";

  String id;
  String name;
  String email;
  String phone;
  String token;
  String photo;

  int votes;
  int trips;
  double rating;

  RiderModel(
      {this.email,
      this.votes,
      this.trips,
      this.token,
      this.rating,
      this.photo,
      this.phone,
      this.name,
      this.id});

  RiderModel.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.data()[NAME];
    email = snapshot.data()[EMAIL];
    id = snapshot.data()[ID];
    phone = snapshot.data()[PHONE];
    token = snapshot.data()[TOKEN];
    votes = snapshot.data()[VOTES];
    trips = snapshot.data()[TRIPS];
    rating = snapshot.data()[RATING];
    photo = snapshot.data()[PHOTO];
  }
}
