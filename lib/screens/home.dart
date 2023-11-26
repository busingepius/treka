import 'package:get/get.dart';
import 'package:treka/helpers/stars_method.dart';
import 'package:treka/helpers/style.dart';
import 'package:treka/providers/app_provider.dart';
import 'package:treka/providers/user.dart';
import 'package:treka/screens/ride_request.dart';
import 'package:treka/widgets/custom_text.dart';
import 'package:treka/widgets/drawer.dart';
import 'package:treka/widgets/rider_draggable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scaffoldState = GlobalKey<ScaffoldState>();
  AppStateProvide appState = Get.find();
  UserProvider userProvider = Get.find();

  @override
  void initState() {
    super.initState();
    // _deviceToken();
    _updatePosition();
  }

  // _deviceToken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   UserProvider _user = Get.put(UserProvider());
  // }

  _updatePosition() async {
    //    this section down here will update the drivers current position on the DB when the app is opened
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _id = _prefs.getString("id");
    UserProvider _user = Get.put(UserProvider());
    AppStateProvide _app = Get.find();
    _user.updateUserData({"id": _id, "position": _app.position.toJson()});
  }

  @override
  Widget build(BuildContext context) {
    Widget home = Scaffold(
        key: scaffoldState,
        drawer: SafeArea(
          child: DrawerA(
              text1: userProvider.userModel.value?.name ?? "",
              text2: userProvider.userModel.value?.email ?? "",
              onTap: () {
                userProvider.signOut();
              }),
          // child: Drawer(
          //     child: ListView(
          //   children: [
          //     UserAccountsDrawerHeader(
          //         accountName: CustomText(
          //           text: userProvider.userModel.value?.name ?? "",
          //           size: 18,
          //           weight: FontWeight.bold,
          //         ),
          //         accountEmail: CustomText(
          //           text: userProvider.userModel.value?.email ?? "",
          //         )),
          //     ListTile(
          //       leading: Icon(Icons.exit_to_app),
          //       title: CustomText(text: "Log out"),
          //       onTap: () {
          //         userProvider.signOut();
          //       },
          //     )
          //   ],
          // )),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              MapScreen(scaffoldState),
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
                                      rating:
                                          userProvider.userModel.value.rating,
                                      votes: userProvider.userModel.value.votes)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              // TODO: ANCHOR Draggable DRIVER
              Visibility(
                  visible: appState.show == Show.RIDER, child: RiderWidget()),
            ],
          ),
        ));

    switch (appState.hasNewRideRequest) {
      case false:
        return home;
      case true:
        return RideRequestScreen();
      default:
        return home;
    }
  }
}

class MapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  MapScreen(this.scaffoldState);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController destinationController = TextEditingController();
  Color darkBlue = Colors.black;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();
  String position = "position";

  @override
  void initState() {
    super.initState();
    scaffoldSate = widget.scaffoldState;
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvide appState = Get.find();
    return appState.center == null
        //TODO: REPLACE THE LOADING WIDGET BECAUSE IT WAS DELETED
        ? CircularProgressIndicator()
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: appState.center, zoom: 15),
                onMapCreated: appState.onCreate,
                myLocationEnabled: true,
                mapType: MapType.normal,
                tiltGesturesEnabled: true,
                compassEnabled: false,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                polylines: appState.poly,
              ),
              Positioned(
                top: 10,
                left: 15,
                child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: primary,
                      size: 30,
                    ),
                    onPressed: () {
                      scaffoldSate.currentState.openDrawer();
                    }),
              ),
            ],
          );
  }
}
