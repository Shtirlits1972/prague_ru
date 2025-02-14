import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'en.dart';
import 'ru.dart';
import 'cs.dart';

mixin AppLocale {
  static const String home = 'home';
  static const String setting = 'setting';
  static const String dark_theme = 'Dark Theme';

  static const Map<String, dynamic> EN = en;
  static const Map<String, dynamic> RU = ru;
  static const Map<String, dynamic> CS = cs;
}

// mixin AppLocale {
//   static const String home = 'title';
//   static const String setting = 'setting';

//   static const Map<String, dynamic> EN = {
//     home: 'Home',
//     setting: 'Setting',
//   };
//   static const Map<String, dynamic> RU = {
//     home: 'Домой',
//     setting: 'Настройки',
//   };
//   static const Map<String, dynamic> CS = {
//     home: 'Home',
//     setting: 'Nastavení',
//   };
// }
