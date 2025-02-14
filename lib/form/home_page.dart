import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/widget/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu_rounded),
            );
          },
        ),
        title: Text(AppLocale.home.getString(context)),
        // title: Obx(() => Text('home_title'.tr)),
        centerTitle: true,
      ),
      drawer: DrawerMenu(),
      body: Center(
        child: Text('Setting ${AppLocale.setting.getString(context)}'),
      ),
    );
  }
}
