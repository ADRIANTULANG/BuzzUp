import 'package:buzzup/services/location_services.dart';
import 'package:buzzup/src/home_screen/view/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SignUpController extends GetxController {
  TextEditingController email = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  checkIfDeviceAndEmail({required String email}) async {
    var deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceID = androidDeviceInfo.id;
    String deviceName =
        androidDeviceInfo.brand + " " + androidDeviceInfo.product;

    var res = await FirebaseFirestore.instance
        .collection('devices')
        .where("deviceID", isEqualTo: deviceID)
        .where("deviceName", isEqualTo: deviceName)
        .where("email", isEqualTo: email)
        .limit(1)
        .get();
    var resCount = res.docs.length;
    if (resCount == 0) {
      var doc = await FirebaseFirestore.instance.collection('devices').add({
        "deviceName": deviceName,
        "deviceID": deviceID,
        "email": email,
        "deviceType": SizerUtil.deviceType == DeviceType.tablet,
        "name": deviceName
      });
      setGeoPoint(documentID: doc.id);
      await prefs.setString('id', doc.id);
      await prefs.setString('email', email);
    } else {
      for (var i = 0; i < res.docs.length; i++) {
        await prefs.setString('id', res.docs[i]['email']);
        await prefs.setString('email', email);

        setGeoPoint(documentID: res.docs[i].id);
      }
    }
    Get.to(() => HomeView());
  }

  setGeoPoint({required String documentID}) async {
    print(documentID);
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      GeoFirestore geoFirestore = GeoFirestore(firestore.collection('devices'));
      var locations = await Get.find<LocationServices>().determinePosition();
      await geoFirestore.setLocation(
          documentID,
          GeoPoint(
            locations.latitude,
            locations.latitude,
          ));
    } on Exception catch (e) {
      print("ERROR: $e");
    }
  }
}
