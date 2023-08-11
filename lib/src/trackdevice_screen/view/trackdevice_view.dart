import 'package:buzzup/services/colors_services.dart';
import 'package:buzzup/src/trackdevice_screen/controller/trackdevice_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class TrackDeviceView extends GetView<TrackDeviceController> {
  const TrackDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TrackDeviceController());
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => controller.isLoading.value == true
              ? Container(
                  height: 100.h,
                  width: 100.w,
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: ColorServices.violet,
                      size: 35.sp,
                    ),
                  ),
                )
              : Obx(
                  () => GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: controller.centerLocation,
                      zoom: 14.4746,
                    ),
                    markers: controller.marker.toSet(),
                    myLocationEnabled: true,
                    onCameraMove: (position) {},
                    onCameraMoveStarted: () {},
                    onMapCreated: (GoogleMapController g_controller) async {
                      if (controller.googleMapController.isCompleted) {
                      } else {
                        controller.googleMapController.complete(g_controller);
                      }
                      controller.camera_controller = await g_controller;
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
