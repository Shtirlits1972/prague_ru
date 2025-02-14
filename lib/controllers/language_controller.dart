import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final SharedPreferences prefs;
  LanguageController(this.prefs);

  var selectedLanguage = 'en'.obs;
  var locale = const Locale('en', 'US').obs;

  final languages = ['en', 'ru', 'cs'];

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = prefs.getString('language') ?? 'en';
    locale.value = Locale(selectedLanguage.value);
  }

  void changeLanguage(String? value) {
    if (value != null) {
      selectedLanguage.value = value;
      locale.value = Locale(value);
      prefs.setString('language', value);
      Get.updateLocale(Locale(value));
    }
  }
}
