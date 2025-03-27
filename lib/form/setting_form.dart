import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prague_ru/controllers/language_controller.dart';
import 'package:prague_ru/controllers/theme_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  final ThemeController _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocale.setting.getString(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Переключение темы
            SwitchListTile(
              title: Text(AppLocale.dark_theme.getString(context)),
              value: _themeController.isDarkMode.value,
              onChanged: (value) {
                _themeController.toggleTheme(value);
              },
            ),
            const SizedBox(height: 20),
            // Выбор языка
            Column(
              children: [
                RadioListTile(
                  title: const Text('English'),
                  value: 'en',
                  groupValue: _localization.currentLocale!.languageCode,
                  onChanged: (value) {
                    _localization.translate(value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Русский'),
                  value: 'ru',
                  groupValue: _localization.currentLocale!.languageCode,
                  onChanged: (value) {
                    _localization.translate(value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Česky'),
                  value: 'cs',
                  groupValue: _localization.currentLocale!.languageCode,
                  onChanged: (value) {
                    _localization.translate(value!);
                  },
                ),
              ],
            ),
            // const SizedBox(height: 20),
            // // Информация о текущем языке
            // ItemWidget(
            //   title: 'Current Language',
            //   content: _localization.getLanguageName(),
            // ),
            // ItemWidget(
            //   title: 'Font Family',
            //   content: _localization.fontFamily,
            // ),
            // ItemWidget(
            //   title: 'Locale Identifier',
            //   content: _localization.currentLocale.localeIdentifier,
            // ),
          ],
        ),
      ),
    );
  }
}
