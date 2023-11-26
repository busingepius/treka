import 'package:get/get.dart';
import 'package:treka/helpers/style.dart';
import 'package:treka/providers/app_provider.dart';
import 'package:treka/providers/user.dart';
import 'package:treka/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegistrationScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    UserProvider authProvider = Get.find();
    AppStateProvide app = Get.put(AppStateProvide());

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
                  Image.asset("images/lg.png", width: 230, height: 120,),
                ],
              ),
            ),

            Container(
              height: 40,
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
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: authProvider.name,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: white),
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: white),
                        labelText: "Name",
                        hintText: "eg: Pius Businge",
                        icon: Icon(Icons.person, color: white,)
                    ),
                  ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: white),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: authProvider.email,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: white),
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: white),
                        labelText: "Email",
                        hintText: "busingepius@gmail.com",
                        icon: Icon(Icons.email, color: white,)
                    ),
                  ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: white),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: authProvider.phone,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: white),
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: white),
                        labelText: "Phone",
                        hintText: "+256 3213452",
                        icon: Icon(Icons.phone, color: white,)
                    ),
                  ),),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: white),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: authProvider.password,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: white),
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: white),
                        labelText: "Password",
                        hintText: "at least 6 digits",
                        icon: Icon(Icons.lock, color: white,)
                    ),
                  ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () async {
                  await authProvider.signUp(app.position);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomText(text: "Register", color: white, size: 22,)
                      ],
                    ),),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              child: GestureDetector(
                onTap: (){
                  Get.to(()=> LoginScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomText(text: "Login here", size: 20,color: Colors.white,),
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
