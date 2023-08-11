import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../../services/location_services.dart';
import '../model/home_devices_model.dart';

class HomeController extends GetxController {
  Stream? streamer;
  StreamSubscription<dynamic>? listener;
  @override
  void onInit() async {
    getListener();

    // setGeoPoint(documentID: prefs.getString('id')!);

    super.onInit();
  }

  @override
  void onClose() async {
    listener!.cancel();
    super.onClose();
  }

  RxList<Devices> deviceList = <Devices>[].obs;
  RxList<Devices> deviceListMasterList = <Devices>[].obs;

  getListener() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_email = prefs.getString('email')!;
    streamer = await FirebaseFirestore.instance
        .collection('devices')
        .where('email', isEqualTo: user_email)
        .snapshots();
    getDevices();
  }

  getDevices() async {
    try {
      listener = streamer!.listen((event) async {
        List data = [];
        for (var devices in event.docs) {
          Map map = {
            "id": devices.id,
            "deviceID": devices["deviceID"],
            "deviceName": devices['deviceName'],
            "deviceType": devices['deviceType'],
            "location":
                devices.data().containsKey('l') ? devices['l'] : [0.0, 0.0],
            "updatedAt": devices.data().containsKey('updatedAt')
                ? devices['updatedAt'].toDate().toString()
                : DateTime.now().toString(),
            "name": devices.data().containsKey('name') ? devices['name'] : "",
          };
          data.add(map);
        }
        var encodedData = await jsonEncode(data);
        log(encodedData);
        deviceList.assignAll(await devicesFromJson(jsonEncode(data)));
        deviceListMasterList.assignAll(await devicesFromJson(jsonEncode(data)));
      });
    } catch (e) {
      print(e.toString() + " eRROR");
    }
  }

  // setGeoPoint({required String documentID}) async {
  //   print(documentID);
  //   try {
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     GeoFirestore geoFirestore = GeoFirestore(firestore.collection('devices'));

  //     await geoFirestore.setLocation(
  //         documentID,
  //         GeoPoint(Get.find<LocationServices>().locationData!.latitude!,
  //             Get.find<LocationServices>().locationData!.longitude!));
  //   } on Exception catch (e) {
  //     print("ERROR: $e");
  //   }
  // }
}
