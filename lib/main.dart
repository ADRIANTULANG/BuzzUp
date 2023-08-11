// import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:ui';

// import 'package:buzzup/services/notification_services.dart';
import 'package:buzzup/services/location_services.dart';
import 'package:buzzup/src/splash_screen/view/splash_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
// import 'package:tm/services/notification_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.put(LocationServices());
  await initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      // notificationChannelId: 'my_foreground',
      // initialNotificationTitle: 'AWESOME SERVICE',
      // initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
    var deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    String deviceID = androidDeviceInfo.id;
    String deviceName =
        androidDeviceInfo.brand + " " + androidDeviceInfo.product;
    bool isFirebaseInitialized = Firebase.apps.isNotEmpty;
    print("is Firebase Inititialize? $isFirebaseInitialized");
    if (isFirebaseInitialized == true) {
    } else {
      await Firebase.initializeApp();
      print("Firebase Inititialized already");
    }
    var res = await FirebaseFirestore.instance
        .collection('devices')
        .where('deviceName', isEqualTo: deviceName)
        .where('deviceID', isEqualTo: deviceID)
        .get();
    QueryDocumentSnapshot<Map<String, dynamic>>? devicesDocument;
    if (res.docs.length > 0) {
      devicesDocument = res.docs[0];
    }
    if (devicesDocument != null) {
      if (Get.isRegistered<LocationServices>() == true) {
        print("[MESSAGE] the location services is still not registered");
        await FirebaseFirestore.instance
            .collection('devices')
            .doc(devicesDocument.id)
            .update({"updatedAt": DateTime.now()});
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        GeoFirestore geoFirestore =
            GeoFirestore(firestore.collection('devices'));
        var locations = await Get.find<LocationServices>().determinePosition();
        await geoFirestore.setLocation(
            devicesDocument.id,
            GeoPoint(
              locations.latitude,
              locations.longitude,
            ));
        print("[MESSAGE] background code executed");
      } else {
        print("[MESSAGE] the location services is still not registered");
        Get.put(LocationServices());
      }
    } else {
      print("[MESSAGE] the device still not registered");
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print("App is Detached");
    } else if (state == AppLifecycleState.paused) {
      print("App is Paused");
    } else if (state == AppLifecycleState.resumed) {
      print("App is Resumed");
    } else if (state == AppLifecycleState.inactive) {
      print("App is Inactive");
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BuzzUp',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: SplashView(),
      );
    });
  }
}
