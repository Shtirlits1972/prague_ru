import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:prague_ru/controllers/city_district_controller.dart';
import 'package:prague_ru/form/web_google_map_form.dart';
import 'package:prague_ru/services/citydistricts_crud.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/widget/drawer.dart';
import 'package:flutter/foundation.dart';

class CityDistrictsForm extends StatelessWidget {
  const CityDistrictsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CityDistrictsController citydistrictsGetX =
        Get.put(CityDistrictsController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        title: Text(AppLocale.praga_district.getString(context)),

        //   Obx(() => Text(
        //       'Message: ${citydistrictsGetX.rxReqRes.value.message} Status: ${citydistrictsGetX.rxReqRes.value.status}')),
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: Obx(() {
        //   final reqRes = citydistrictsGetX.rxReqRes.value;

        if (citydistrictsGetX.rxDistricts.value.status == 0) {
          // Загрузка данных при первом открытии формы
          CityDistrictsCrud.getData().then((value) {
            citydistrictsGetX.setCityDistricts(value);

            Set<String?> lstDistrict = {};
            lstDistrict.add(null);
            lstDistrict.addAll(citydistrictsGetX.getDistrictSlug());
            citydistrictsGetX.setCityDistrictsSelected(lstDistrict);
          });

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else {
          return getCentral(citydistrictsGetX.rxDistricts.value, context);
        }
      }),
    );
  }

  Widget getCentral(ReqRes<List<CityDistricts>> reqRes, BuildContext context) {
    if (reqRes.model == null || reqRes.model!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No Data'),
            Text(reqRes.message),
          ],
        ),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
        ),
        itemCount: reqRes.model!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              if (kIsWeb) {
                try {
                  final newKey =
                      ValueKey(DateTime.now().millisecondsSinceEpoch);

                  await Navigator.pushNamed(context, WebMapForm.route,
                      arguments: {
                        'key': newKey,
                        'feature': reqRes.model![index].feature,
                        'title': reqRes.model![index].name,
                        'address': reqRes.model![index]!.slug,
                      });
                } catch (e) {
                  print(e);
                  var t = 0;
                }
              } else {
                print(reqRes.model![index]);
                var t = 0;
                Navigator.pushNamed(
                  context,
                  '/CityDistrictMapForm',
                  arguments: reqRes.model![index],
                );
              }
            },
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '${reqRes.model![index].id}',
                  ),
                ),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                '${reqRes.model![index].name}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
