import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:treka/providers/app_provider.dart';
import 'package:treka/screens/splash.dart';

import 'map.dart';

class TransitionScreen extends StatelessWidget {
  TransitionScreen({Key key}) : super(key: key);
  AppStateProvide geoService = Get.put( AppStateProvide());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: geoService.getInitialLocation(),
          builder: (
            context,
            AsyncSnapshot<Position> position,
          ) {
            print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
            return (position.data != null)
                  ? MapX(position.requireData)
                  :
                Splash();
          }),
    );
  }
}
