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
        title: Text(AppLocale.setting.getString(context)),
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

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.title,
    required this.content,
  });

  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(title ?? '')),
          const Text(' : '),
          Expanded(child: Text(content ?? '')),
        ],
      ),
    );
  }
}

/*
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('settings_title'.tr),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('dark_theme'.tr),
            value: themeController.isDarkMode.value,
            onChanged: (value) {
              themeController.toggleTheme(value);
            },
          ),
          ...languageController.languages.map((language) {
            return RadioListTile(
              title: Text(language.tr),
              value: language,
              groupValue: languageController.selectedLanguage.value,
              onChanged: (value) {
                languageController.changeLanguage(value);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
*/
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:prague_ru/controller/theme_controller.dart';

// class SettingForm extends StatelessWidget {
//   SettingForm({Key? key}) : super(key: key);
//   final ThemeController themeController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Setting'),
//       ),
//       body: Center(
//         child: SwitchListTile(
//           title: Text('Dark Theme'),
//           value: themeController.isDarkMode.value,
//           onChanged: (value) {
//             print(value);
//             themeController.setTheme(value);
//           },
//         ),
//       ),
//     );
//   }
// }
