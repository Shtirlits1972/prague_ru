import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'en.dart';
import 'ru.dart';
import 'cs.dart';

mixin AppLocale {
  static const String lang = 'en';

  static const String home = 'home';
  static const String setting = 'setting';
  static const String dark_theme = 'Dark Theme';

  static const String praga_district = 'Prague districts';
  static const String medical_institurions = 'Medical Institutions';

  static const String menu = 'Menu';
  static const String cancel = 'Cancel';
  static const String map = 'map';

  static const String districts = 'districts';
  static const String medical_types = 'type medical Institutions';
  static const String all = 'all';
  static const String police_stations = 'Police stations';

  static const String no_data = 'no data ';
  static const String try_change_filters = 'try change filters';

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
