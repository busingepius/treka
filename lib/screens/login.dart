import 'package:get/get.dart';
import 'package:treka/helpers/style.dart';
import 'package:treka/providers/user.dart';
import 'package:treka/screens/registration.dart';
import 'package:treka/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final UserProvider authProvider = Get.find();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: white,
              height: 100,
            ),
            Container(
              color: white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "images/lg.png",
                    width: 230,
                    height: 230,
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              color: white,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: white),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: authProvider.email,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: white),
                        border: InputBorder.none,
                        hintText: "Email",
                        icon: Icon(
                          Icons.email,
                          color: white,
                        )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: white),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: authProvider.password,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: white),
                        border: InputBorder.none,
                        hintText: "Password",
                        icon: Icon(
                          Icons.lock,
                          color: white,
                        )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () async {
                  await authProvider.signIn();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomText(
                          text: "Login",
                          color: Colors.white,
                          size: 22,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(()=>RegistrationScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      text: "Register here",
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
