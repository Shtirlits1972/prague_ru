import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:prague_ru/app_router.dart';
import 'package:prague_ru/controllers/language_controller.dart';
import 'package:prague_ru/form/home_page.dart';
import 'package:prague_ru/form/setting_form.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/theme_controller.dart';
import 'package:prague_ru/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // Get.put(ThemeController(prefs));
  // Get.put(LanguageController(prefs));

  await FlutterLocalization.instance.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Get.put(ThemeController(prefs)); // Инициализация контроллера темы

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  final ThemeController _themeController = Get.find<ThemeController>();

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'ru',
          AppLocale.RU,
          countryCode: 'RU',
          fontFamily: 'Font RU',
        ),
        const MapLocale(
          'cs',
          AppLocale.CS,
          countryCode: 'CS',
          fontFamily: 'Font CS',
        ),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  final AppRouter _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MaterialApp(
        supportedLocales: _localization.supportedLocales,
        localizationsDelegates: _localization.localizationsDelegates,
        onGenerateRoute: _appRouter.onGenerateRoute,
        theme: _themeController.themeData.value, // Применяем тему
      );
    });
  }
}

/*
class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'Prague RU',
        theme: themeController.themeData.value,
        locale: languageController.locale.value,
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ru', 'RU'),
          const Locale('cs', 'CZ'),
        ],
        localizationsDelegates: [
          Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        onGenerateRoute: _appRouter.onGenerateRoute,
      );
    });
  }
}
*/
