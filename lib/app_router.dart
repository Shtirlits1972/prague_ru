import 'package:flutter/material.dart';
import 'package:prague_ru/form/home_page.dart';
import 'package:prague_ru/form/setting_form.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );

      case '/SettingsPage':
        return MaterialPageRoute(builder: (_) => SettingsPage());

      default:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
    }
  }
}
