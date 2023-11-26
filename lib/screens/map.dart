import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treka/helpers/stars_method.dart';
import 'package:treka/helpers/style.dart';
import 'package:treka/providers/app_provider.dart';
import 'package:treka/providers/user.dart';
import 'package:treka/widgets/custom_text.dart';
import 'package:treka/widgets/drawer.dart';

class MapX extends StatelessWidget {
  final Position initialPosition;

  MapX(this.initialPosition);

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final TextEditingController destinationController = TextEditingController();
  final AppStateProvide geoService = Get.put(AppStateProvide());
  UserProvider userProvider = Get.put(UserProvider());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      drawer: SafeArea(
        child: DrawerA(
            text1: userProvider.userModel.value.name ?? "",
            text2: userProvider.userModel.value.email ?? "",
            onTap: () {
              userProvider.signOut();
            }),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      initialPosition.latitude, initialPosition.longitude),
                  zoom: 10.0,
                ),
                mapType: MapType.satellite /*normal*/,
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                rotateGesturesEnabled: true,
                compassEnabled: true,
                //TODO: FOLLOW UP THIS ON MAP CREATED
                onMapCreated: (GoogleMapController controller) {
                  geoService.controllerG.complete(controller);
                },
                // markers: geoService.markers,
                // onCameraMove: geoService.onCameraMove,
                // polylines: geoService.poly,
              ),
            ),
            Positioned(
              top: 10,
              left: 15,
              child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: /*primary*/Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {
                    scaffoldState.currentState.openDrawer();
                  }),
            ),
            Positioned(
                top: 60,
                left: MediaQuery.of(context).size.width / 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: grey, blurRadius: 17)]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: userProvider.userModel.value?.phone == null
                                ? CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 25,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    // backgroundImage: NetworkImage(userProvider.userModel?.photo),/*commented out*/
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 25,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: userProvider.userModel.value.name,
                                  size: 18,
                                  weight: FontWeight.bold,
                                ),
                                stars(
                                    rating: userProvider.userModel.value.rating,
                                    votes: userProvider.userModel.value.votes)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
