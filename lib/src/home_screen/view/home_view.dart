import 'package:buzzup/services/colors_services.dart';
import 'package:buzzup/src/trackdevice_screen/view/trackdevice_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 100.h,
          width: 100.w,
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Devices",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                  child: Container(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.deviceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => TrackDeviceView(), arguments: {
                              "deviceDocumentID":
                                  controller.deviceList[index].id,
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 10.h,
                                width: 20.w,
                                color: ColorServices.violet,
                                child:
                                    controller.deviceList[index].deviceType ==
                                            false
                                        ? Icon(
                                            Icons.phone_android_rounded,
                                            size: 25.sp,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.tablet_android_rounded,
                                            size: 25.sp,
                                            color: Colors.white,
                                          ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Expanded(
                                child: Container(
                                  height: 10.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.deviceList[index].deviceName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: .5.h,
                                      ),
                                      Text(
                                        controller.deviceList[index].deviceId,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 9.sp,
                                        ),
                                      ),
                                      Text(
                                        controller.deviceList[index].location[0]
                                                .toString() +
                                            "," +
                                            controller
                                                .deviceList[index].location[1]
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 9.sp,
                                        ),
                                      ),
                                      // Text(
                                      //   DateFormat('yMMMd').format(
                                      //           controller.chatList[index].date) +
                                      //       " " +
                                      //       DateFormat('jm').format(
                                      //           controller.chatList[index].date),
                                      //   style: TextStyle(
                                      //     fontWeight: FontWeight.normal,
                                      //     fontSize: 9.sp,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 10.h,
                                width: 7.w,
                                alignment: Alignment.center,
                                child: Icon(Icons.more_vert),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
