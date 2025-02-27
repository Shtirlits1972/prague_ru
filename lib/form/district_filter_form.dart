import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:prague_ru/controllers/city_district_controller.dart';
import 'package:prague_ru/controllers/medical_controller.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/form/setting_form.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/services/medical_crud.dart';
import 'package:prague_ru/services/medical_type_crud.dart';
import 'package:prague_ru/widget/drawer.dart';

class DistrictFilterForm extends StatefulWidget {
  DistrictFilterForm({Key? key}) : super(key: key);

  static const String route = '/DistrictFilterForm';

  @override
  State<DistrictFilterForm> createState() => _DistrictFilterFormState();
}

class _DistrictFilterFormState extends State<DistrictFilterForm> {
  CityDistrictsController citydistrictsGetX =
      Get.put(CityDistrictsController());

  Set<CityDistricts> listDistricts = {}; //

  @override
  Widget build(BuildContext context) {
    // if (listDistricts.isEmpty) {
    //   listDistricts = citydistrictsGetX.rxReqRes.value.model!.toSet();
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocale.praga_district.getString(context)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 10,
                child: Center(
                  child:
                      getCentral(citydistrictsGetX.rxDistricts.value, context),
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                  ),
                  child: SwitchListTile(
                    title: Text('All'),
                    value: listDistricts.length ==
                        citydistrictsGetX.rxDistricts.value.model!
                            .toSet()
                            .length,
                    onChanged: (value) {
                      if (value) {
                        print(value);
                        int h = 0;
                        setState(() {
                          listDistricts = citydistrictsGetX
                              .rxDistricts.value.model!
                              .toSet();
                        });
                      } else {
                        setState(() {
                          listDistricts.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    //   color: Theme.of(context).primaryColor, // Фоновый цвет
                    border: Border(
                      top: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    //  borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
//==//==//==//=================================================
                                print(listDistricts.length);
                                ReqRes<List<CityDistricts>> newModel =
                                    ReqRes<List<CityDistricts>>(
                                        200, 'OK', listDistricts.toList());

                                citydistrictsGetX
                                    .setCityDistrictsSelected(newModel);
                                int h = 0;
                                Navigator.pop(context);
//==//==//==//=================================================
                              });
                            },
                            child: Text('OK'),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    setState(() {
      print(citydistrictsGetX.rxDistricts.value.model!.toSet());
      listDistricts = citydistrictsGetX.rxSelected.value.model!.toSet();
      int g2 = 0;
    });
    super.initState();
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
          return CheckboxListTile(
            value: listDistricts.contains(reqRes.model![index]) ? true : false,
            onChanged: (bool? value) {
              print(value);

              if (value!) {
                setState(() {
                  listDistricts.add(reqRes.model![index]);
                });
              } else {
                setState(() {
                  listDistricts.removeWhere(
                      (item) => item.id == reqRes.model![index].id);
                });
              }
              print(reqRes.model![index].name);
            },
            title: Text(reqRes.model![index].name),
          );
        },
      );
    }
  }
}
