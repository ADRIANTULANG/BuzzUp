import 'dart:async';
import 'dart:developer';

import 'package:buzzup/services/location_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackDeviceController extends GetxController {
  RxString deviceDocumentID = "".obs;
  @override
  void onInit() async {
    await getCurrentLocation();
    deviceDocumentID.value = await Get.arguments['deviceDocumentID'];
    await initializedListener();

    isLoading(false);

    super.onInit();
  }

  Stream? streamer;
  StreamSubscription<dynamic>? listener;

  final Completer<GoogleMapController> googleMapController = Completer();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? camera_controller;
  RxBool isLoading = true.obs;

  RxList<Marker> marker = <Marker>[].obs;
  LatLng current_position = LatLng(0.0, 0.0);
  LatLng centerLocation = LatLng(0.0, 0.0);
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;

  @override
  void onClose() async {
    listener!.cancel();
    super.onClose();
  }

  initializedListener() async {
    streamer = await FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceDocumentID.value)
        .snapshots();
    getDevices();
  }

  getDevices() async {
    try {
      listener = streamer!.listen((event) async {
        // List data = [];
        var data = await event.data();
        // var encodedData = await jsonEncode(data);
        log("[TRACK DEVICE] ${data.toString()}");
        List listLocation = data['l'];
        String deviceID = data['deviceID'];
        String deviceName = data['deviceName'];
        lat.value = listLocation[0];
        long.value = listLocation[1];
        centerLocation = LatLng(lat.value, long.value);
        marker.clear();
        marker.add(Marker(
            position: LatLng(lat.value, long.value),
            markerId: MarkerId(deviceID),
            infoWindow: InfoWindow(title: deviceName)));

        LatLng loc = LatLng(lat.value, long.value);
        final GoogleMapController controller = await googleMapController.future;
        await controller
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: loc,
          zoom: 14.4746,
        )));
      });
    } catch (e) {
      print(e.toString() + " eRROR");
    }
  }

  getCurrentLocation() async {
    var location = await Get.find<LocationServices>().determinePosition();
    current_position = LatLng(location.latitude, location.longitude);
  }
}
