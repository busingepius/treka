import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:treka/helpers/style.dart';
import 'package:treka/models/ride_Request.dart';
import 'package:treka/models/rider.dart';
import 'package:treka/models/route.dart';
import 'package:treka/services/map_requests.dart';
import 'package:treka/services/ride_request.dart';
import 'package:treka/services/rider.dart';
import 'package:treka/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

enum Show { RIDER, TRIP }

class AppStateProvide extends GetxController  {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';
  //TODO: ANCHOR: VARIABLES DEFINITION
  Set<Marker> _markers = {};
  Set<Polyline> _poly = {};
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapController _mapController;
  Position position;
  static LatLng _center;
  LatLng _lastPosition = _center;
  TextEditingController _locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  LatLng get center => _center;
  LatLng get lastPosition => _lastPosition;
  TextEditingController get locationController => _locationController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get poly => _poly;
  GoogleMapController get mapController => _mapController;
  RouteModel routeModel;
  SharedPreferences prefs;

  // Location location = new Location();
  bool hasNewRideRequest = false;
  UserServices _userServices = UserServices();
  RideRequestModel rideRequestModel;
  RequestModelFirebase requestModelFirebase;

  RiderModel riderModel;
  RiderServices _riderServices = RiderServices();
  double distanceFromRider = 0;
  double totalRideDistance = 0;
  StreamSubscription<QuerySnapshot> requestStream;
  int timeCounter = 0;
  double percentage = 0;
  Timer periodicTimer;
  RideRequestServices _requestServices = RideRequestServices();
  Show show;

  // AppStateProvider() {
  //  _subscribeUser();
  //    _saveDeviceToken();
  //    fcm.getInitialMessage().then((RemoteMessage message) {
  //      FirebaseMessaging.onMessage.listen((RemoteMessage message) { handleOnMessage(message.data);});
  //      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { handleOnLaunch(message.data);});
  //      FirebaseMessaging.onBackgroundMessage((message) => handleOnResume(message.data));
  //    });
  //
  //   _getUserLocation();
  //   Geolocator.getPositionStream().listen(_userCurrentLocationUpdate);
  // }

  //TODO: ANCHOR LOCATION METHODS

  _userCurrentLocationUpdate(Position updatedPosition) async {
    double distance = await Geolocator.distanceBetween(
        prefs.getDouble('lat'),
        prefs.getDouble('lng'),
        updatedPosition.latitude,
        updatedPosition.longitude);
    Map<String, dynamic> values = {
      "id": prefs.getString("id"),
      "position": updatedPosition.toJson()
    };
    if (distance >= 50) {
      if(show == Show.RIDER){
        sendRequest(coordinates: requestModelFirebase.getCoordinates());
      }
      _userServices.updateUserData(values);
      await prefs.setDouble('lat', updatedPosition.latitude);
      await prefs.setDouble('lng', updatedPosition.longitude);
    }
  }

   _getUserLocation() async {
    prefs = await SharedPreferences.getInstance();
    /*position = */await Geolocator.getCurrentPosition().then((value) => position = value);
    List<dynamic> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    _center = LatLng(position.latitude, position.longitude);
    await prefs.setDouble('lat', position.latitude);
    await prefs.setDouble('lng', position.longitude);
    _locationController.text = placemark[0].name;
    update();
  }

  //TODO: ANCHOR MAPS METHODS

  onCreate(GoogleMapController controller) {
    _mapController = controller;
    update();
  }

  setLastPosition(LatLng position) {
    _lastPosition = position;
    update();
  }

  onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    update();
  }

  void sendRequest({String intendedLocation, LatLng coordinates}) async {
    LatLng origin = LatLng(position.latitude, position.longitude);

    LatLng destination = coordinates;
    RouteModel route =
        await _googleMapsServices.getRouteByCoordinates(origin, destination);
    routeModel = route;
    addLocationMarker(
        destination, routeModel.endAddress, routeModel.distance.text);
    _center = destination;
    destinationController.text = routeModel.endAddress;

    _createRoute(route.points);
    update();
  }

  void _createRoute(String decodeRoute) {
    _poly = {};
    var uuid = new Uuid();
    String polyId = uuid.v1();
    poly.add(Polyline(
        polylineId: PolylineId(polyId),
        width: 8,
        color: primary,
        onTap: () {},
        points: _convertToLatLong(_decodePoly(decodeRoute))));
    update();
  }

  List<LatLng> _convertToLatLong(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // TODO:ANCHOR MARKERS
  addLocationMarker(LatLng position, String destination, String distance) {
    _markers = {};
    var uuid = new Uuid();
    String markerId = uuid.v1();
    _markers.add(Marker(
        markerId: MarkerId(markerId),
        position: position,
        infoWindow: InfoWindow(title: destination, snippet: distance),
        icon: BitmapDescriptor.defaultMarker));
    update();
  }

  Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/car.png");
    return byteData.buffer.asUint8List();
  }

  clearMarkers() {
    _markers.clear();
    update();
  }

  // _saveDeviceToken() async {
  //   prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('token') == null) {
  //     String deviceToken = await fcm.getToken();
  //     await prefs.setString('token', deviceToken);
  //   }
  // }/*uncommented these above*/

// todo:ANCHOR PUSH NOTIFICATION METHODS
  Future handleOnMessage(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  _handleNotificationData(Map<String, dynamic> data) async {
    hasNewRideRequest = true;
    rideRequestModel = RideRequestModel.fromMap(data['data']);
    riderModel = await _riderServices.getRiderById(rideRequestModel.userId);
    update();
  }

// TODO:ANCHOR RIDE REQUEST METHODS
  changeRideRequestStatus() {
    hasNewRideRequest = false;
    update();
  }

  //TODO:LISTEN TO RIDE REQUEST
  listenToRequest({String id, BuildContext context}) async {
   // requestModelFirebase = await _requestServices.getRequestById(id);
    print("======= LISTENING =======");
    requestStream = _requestServices.requestStream().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((doc) {
        if (doc.doc.data()['id'] == id) {
          requestModelFirebase = RequestModelFirebase.fromSnapshot(doc.doc);
          update();
          switch (doc.doc.data()['status']) {
            case CANCELLED:
              print("====== CANCELED");
              break;
            case ACCEPTED:
              print("====== ACCEPTED");
              break;
            case EXPIRED:
              print("====== EXPIRED");
              break;
            default:
              print("==== PENDING");
              break;
          }
        }
      });
    });
  }

  //  TODO: Timer counter for driver request
  percentageCounter({String requestId, BuildContext context}) {
    update();
    periodicTimer = Timer.periodic(Duration(seconds: 1), (time) {
      timeCounter = timeCounter + 1;
      percentage = timeCounter / 100;
      print("====== GOOOO $timeCounter");
      if (timeCounter == 100) {
        timeCounter = 0;
        percentage = 0;
        time.cancel();
        hasNewRideRequest = false;
        requestStream.cancel();
      }
      update();
    });
  }

  //TODO:ACCEPT RIDE REQUEST
  acceptRequest({String requestId, String driverId}) {
    hasNewRideRequest = false;
    _requestServices.updateRequest(
        {"id": requestId, "status": "accepted", "driverId": driverId});
    update();
  }

  //TODO:CANCEL THE REQUEST FROM PASSENGER
  cancelRequest({String requestId}) {
    hasNewRideRequest = false;
    _requestServices.updateRequest({"id": requestId, "status": "cancelled"});
    update();
  }

  // TODO: ANCHOR UI METHODS
  changeWidgetShowed({Show showWidget}) {
    show = showWidget;
    update();
  }
  //TODO:Added this file to help use getx
  // RxBool? _status = false.obs;

  Completer<GoogleMapController> controllerG = Completer();

  Stream<Position> getCurrentLocation() {
    return Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high, distanceFilter: 10);
  }

  // Future<Position> getInitialLocation() async {
  //   return Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await controllerG.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 15.0)));
  }

  Future<Position> getInitialLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    //Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      //  Location services are not enabled don't continue
      // accessing the position and request users of App to enable the location services.
      Get.defaultDialog(
        title: 'Alert!!',
        middleText: 'GPS Permission Request',
        textCancel: 'Cancel',
        textConfirm: 'GPS',
        onConfirm: () async {
          Get.back(closeOverlays : true,);
          await Geolocator.openLocationSettings();
        },
      );
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //TODO: Complete this condition
        //    Permissions are denied, next time you could try requesting permissions again
        //    (this is also where Android's shouldShowPermissionRationale returned true).
        //    According to Android guidelines your App should show an explanatory UI now.
        Get.defaultDialog(
          title: 'Permission Request!!',
          middleText: 'We use your location privately',
          textCancel: 'Cancel',
          textConfirm: 'Allow',
          onConfirm: () async => await Geolocator.requestPermission(),
        );
      }
      if (permission == LocationPermission.deniedForever) {
        //    Permissions are denied forever, handle appropriately.
        Get.snackbar('PERMISSIONS', 'LOCATION PERMISSIONS DENIED',
            isDismissible: false);
      }
    }
//When we reach here, permissions are granted and we can continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void onInit() async {
    //TODO: By then this was not yet included in its functions
    _getUserLocation();
    // Geolocator..getServiceStatusStream().listen((event) {
    //   print(
    //       "$event iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
    //   service(event);
    // });
    // await Geolocator.isLocationServiceEnabled().then((value) => print(
    //     '{$value}hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh'));
    // // _position = await Geolocator.getCurrentPosition();
    getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    super.onInit();
  }
  //TODO: Cannot work with out the status update from Geolocator..getServiceStatusStream().listen
  // service(status) {
  //   if (status == ServiceStatus.enabled) {
  //     Get.snackbar('Service', '$status');
  //   } else {
  //     Get.snackbar('Service', '$status');
  //   }
  // }
}
