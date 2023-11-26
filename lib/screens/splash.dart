import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:treka/helpers/style.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("images/lg.png"),
      Container(
          color: white,
          child: SpinKitFadingCircle(
            color: black,
            size: 30,
          )
      ),
        ],
      )
    );
  }
}
