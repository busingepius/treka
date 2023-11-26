import 'package:treka/helpers/constants.dart';
import 'package:treka/models/user.dart';

class UserServices {
  String collection = "drivers";

  void createUser(
      {String id,
      String name,
      String email,
      String phone,
      String token,
      int votes,
      int trips,
      double rating,
      Map position}) {
    firebaseFiretore.collection(collection).doc(id).set({
      "name": name,
      "id": id,
      "phone": phone,
      "email": email,
      "votes": votes,
      "trips": trips,
      "rating": rating,
      "position": position,
      "car": "Toyota Corolla",
      "plate": "CBA 321 7",
      "token": token
    });
  }

  void updateUserData(Map<String, dynamic> values) {
    firebaseFiretore.collection(collection).doc(values['id']).update(values);
  }
  //TODO:Important to always get the token
  void addDeviceToken({String token, String userId}) {
    firebaseFiretore
        .collection(collection)
        .doc(userId)
        .update({"token": token});
  }

  Future<UserModel> getUserById(String id) =>
      firebaseFiretore.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
