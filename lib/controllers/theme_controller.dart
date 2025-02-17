import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final SharedPreferences prefs;
  ThemeController(this.prefs);

  var isDarkMode = false.obs;
  var themeData = lightTheme.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    themeData.value = isDarkMode.value ? darkTheme : lightTheme;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    themeData.value = value ? darkTheme : lightTheme;
    prefs.setBool('isDarkMode', value);
  }
}

final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
);
