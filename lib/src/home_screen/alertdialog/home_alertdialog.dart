import 'package:buzzup/src/home_screen/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomeAlertDialog {
  static showInputEmail(
      {required HomeController controller,
      required String deviceID,
      required String deviceName}) async {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    Get.dialog(AlertDialog(
        actions: [TextButton(onPressed: () {}, child: Text("Submit"))],
        content: Container(
          height: 20.h,
          width: 100.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Colors.black),
              ),
              SizedBox(
                height: 3.5.h,
              ),
              Container(
                height: 7.h,
                width: 100.w,
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Email'),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 7.h,
                width: 100.w,
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Password'),
                ),
              ),
            ],
          ),
        )));
  }
}
