import 'dart:async';
import 'package:buzzup/src/home_screen/view/home_view.dart';
import 'package:buzzup/src/signup_screen/view/signup_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    navigate_to_homescreen();
    super.onInit();
  }

  navigate_to_homescreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 4), () async {
      if (prefs.getString('email') == null) {
        Get.to(() => SignUpView());
      } else {
        Get.to(() => HomeView());
      }
    });
  }
}
