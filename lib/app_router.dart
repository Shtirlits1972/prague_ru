import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/form/city_district_map_form.dart';
import 'package:prague_ru/form/city_districts_form.dart';
import 'package:prague_ru/form/district_filter_form.dart';
import 'package:prague_ru/form/home_page.dart';
import 'package:prague_ru/form/medical_form.dart';
import 'package:prague_ru/form/medical_map_form.dart';
import 'package:prague_ru/form/medical_type_form.dart';
import 'package:prague_ru/form/municipal_authority_form.dart';
import 'package:prague_ru/form/municipal_authority_map.dart';
import 'package:prague_ru/form/police_form.dart';
import 'package:prague_ru/form/police_map.dart';
import 'package:prague_ru/form/setting_form.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/CityDistrictsForm':
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

      case '/MedicalForm':
        return MaterialPageRoute(builder: (_) => MedicalForm());

      case '/MedicalMapForm':
        final GeoJSONFeature feature =
            routeSettings.arguments as GeoJSONFeature;
        return MaterialPageRoute(
          builder: (_) => MedicalMapForm(feature: feature),
        );

      case DistrictFilterForm.route:
        return MaterialPageRoute(
          builder: (context) => DistrictFilterForm(),
        );

      case MedicalTypeForm.route:
        return MaterialPageRoute(
          builder: (context) => MedicalTypeForm(),
        );

      case PoliceForm.route:
        return MaterialPageRoute(
          builder: (context) => PoliceForm(),
        );

      case PoliceMap.route:
        final GeoJSONFeature feature =
            routeSettings.arguments as GeoJSONFeature;
        return MaterialPageRoute(
          builder: (_) => PoliceMap(feature: feature),
        );

      case MunicipalAuthorityForm.route:
        return MaterialPageRoute(
          builder: (context) => MunicipalAuthorityForm(),
        );

      case MunicipaiAuthorityMap.route:
        final GeoJSONFeature feature =
            routeSettings.arguments as GeoJSONFeature;
        return MaterialPageRoute(
          builder: (_) => MunicipaiAuthorityMap(feature: feature),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => CityDistrictsForm(),
        );
    }
  }
}
