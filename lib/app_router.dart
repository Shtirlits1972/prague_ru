import 'package:flutter/material.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/form/city_district_map_form.dart';
import 'package:prague_ru/form/city_districts_form.dart';
import 'package:prague_ru/form/home_page.dart';
import 'package:prague_ru/form/setting_form.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => CityDistrictsForm(),
        );

      case '/SettingsPage':
        return MaterialPageRoute(builder: (_) => SettingsPage());

      case '/CityDistrictMapForm':
        final CityDistricts cityDistricts =
            routeSettings.arguments as CityDistricts;
        return MaterialPageRoute(
          builder: (_) => CityDistrictMapForm(
            cityDistricts: cityDistricts,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => CityDistrictsForm(),
        );
    }
  }
}
