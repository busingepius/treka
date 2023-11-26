import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
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

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.photo,
      this.rating,
      this.token,
      this.trips,
      this.votes});

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.data()[NAME];
    email = snapshot.data()[EMAIL];
    id = snapshot.data()[ID];
    phone = snapshot.data()[PHONE];
    token = snapshot.data()[TOKEN];
    photo = snapshot.data()[PHOTO];
    votes = snapshot.data()[VOTES];
    trips = snapshot.data()[TRIPS];
    rating = snapshot.data()[RATING];
  }
}
