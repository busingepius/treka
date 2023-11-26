import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize() async {
    // _fcm.getInitialMessage().then((RemoteMessage message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) { handleOnMessage(message.data);});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { handleOnLaunch(message.data);});
    FirebaseMessaging.onBackgroundMessage((message) => handleOnResume(message.data));

  //   _fcm.configure(
  // //  todo:  this callback is used when the app runs on the foreground
  //       onMessage: handleOnMessage,
  // //   todo:   used when the app is closed completely and is launched using the notification
  //       onLaunch: handleOnLaunch,
  // //   todo:   when its on the background and opened using the notification drawer
  //       onResume: handleOnResume);
  }

  Future handleOnMessage(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }
}
