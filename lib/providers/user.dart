import 'package:get/get.dart';
import 'package:treka/helpers/constants.dart';
import 'package:treka/helpers/showLoading.dart';
import 'package:treka/models/user.dart';
import 'package:treka/screens/login.dart';
import 'package:treka/screens/transition.dart';
import 'package:treka/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider extends GetxController {
  // static const ID = "id";
  Rx<UserServices> userServices = UserServices().obs;
  final formkey = GlobalKey<FormState>();
  //
  // UserProvider.initialize() {
  //   _fireSetUp();
  // }
  //
  // _fireSetUp() async {
  //   // await initialization.then((value) {
  //     auth.authStateChanges().listen(_onStateChanged);
  //   // });
  // }

  // Future<bool> signIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   try {
  //     // _status = Status.Authenticating;
  //     // notifyListeners();
  //     await auth
  //         .signInWithEmailAndPassword(
  //             email: email.text.trim(), password: password.text.trim())
  //         .then((value) async {
  //       // await prefs.setString(ID, value.user.uid);
  //       // await prefs.setBool(LOGGED_IN, true);
  //       _userModel = await _userServices.getUserById(value.user.uid);
  //       // _status = Status.Authenticated;
  //     });
  //     return prefs.getBool(LOGGED_IN);
  //   } catch (e) {
  //     // _status = Status.Unauthenticated;
  //     // notifyListeners();
  //     // print(e.toString());
  //     return false;
  //   }
  // }

  // Future<bool> signUp(Position position) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   try {
  //     // _status = Status.Authenticating;
  //     // notifyListeners();
  //     await auth
  //         .createUserWithEmailAndPassword(
  //             email: email.text.trim(), password: password.text.trim())
  //         .then((result) async {
  //       String _deviceToken = await fcm.getToken();
  //       // await prefs.setString(ID, result.user.uid);
  //       // await prefs.setBool(LOGGED_IN, true);
  //       userServices.value.createUser(
  //         id: result.user.uid,
  //         name: name.text.trim(),
  //         email: email.text.trim(),
  //         phone: phone.text.trim(),
  //         position: position.toJson(),
  //         token: _deviceToken,
  //       );
  //       // _status = Status.Authenticated;
  //     });
  //     // return prefs.getBool(LOGGED_IN);
  //   } catch (e) {
  //     // _status = Status.Unauthenticated;
  //     // notifyListeners();
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // Future signOut() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   auth.signOut();
  //   _status = Status.Unauthenticated;
  //   await prefs.setString(ID, null);
  //   await prefs.setBool(LOGGED_IN, false);
  //   notifyListeners();
  //   return Future.delayed(Duration.zero);
  // }
  //
  // void clearController() {
  //   name.text = "";
  //   password.text = "";
  //   email.text = "";
  //   phone.text = "";
  // }
  //
  // Future<void> reloadUserModel() async {
  //   userModel.value = await _userServices.value.getUserById(user.uid);
  //  // upDate();
  // }

  updateUserData(Map<String, dynamic> data) async {
    userServices.value.updateUserData(data);
  }

  //TODO:NO USAGE FOUND
  // saveDeviceToken() async {
  //   String deviceToken = await fcm.getToken();
  //   if (deviceToken != null) {
  //     userServices.value.addDeviceToken(
  //       userId: user.uid,
  //       token: deviceToken,
  //     );
  //   }
  // }

  // _onStateChanged(User firebaseUser) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // bool loggedIn = prefs.getBool(LOGGED_IN) ?? false;
  //   if (firebaseUser == null) {
  //     // _status = Status.Unauthenticated;
  //   } else {
  //     _user = firebaseUser;
  //     await prefs.setString(ID, firebaseUser.uid);
  //     _userModel = await _userServices.getUserById(user.uid).then((value) {
  //       _status = Status.Authenticated;
  //       return value;
  //     });
  //   }
    // notifyListeners();
  // }

//  TODO: Integrate this into authenticatio
//   static UserController instance = Get.find();
  Rx<User> firebaseUser;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  // String usersCollection = "users";
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User user) async {
    if (user == null) {
      print('gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
      Get.offAll(() => LoginScreen());
    } else {
      userModel.value = await userServices.value.getUserById(user.uid);
      // userModel.bindStream(listenToUser());
      Get.offAll(() => TransitionScreen());
    }
  }

  void signIn() async {
    try {
      showLoading();
      await auth
          .signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      )
          .then((result) {
        clearController();
        dismissLoadingWidget();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Sign In Failed", "Try again");
    }
  }

  void signUp(Position position) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      showLoading();
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result)async {
        String _deviceToken = await fcm.getToken();
        // String _userId = result.user.uid;
        userServices.value.createUser(
          id: result.user.uid,
          name: name.text.trim(),
          email: email.text.trim(),
          phone: phone.text.trim(),
          position: position.toJson(),
          token: _deviceToken,
        );
        clearController();
        dismissLoadingWidget();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Sign Up Failed", "Try again later");
    }
  }

  void signOut() async {
   try{
     auth.signOut();
   }catch(e){
     Get.snackbar("Sign Out Failed", "Try again");
   }
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
    phone.text = "";
  }

  // Stream<UserModel> listenToUser() => firebaseFirestore
  //     .collection(usersCollection)
  //     .doc(firebaseUser.value.uid)
  //     .snapshots()
  //     .map((snapshot) => UserModel.fromSnapshot(snapshot));
}
