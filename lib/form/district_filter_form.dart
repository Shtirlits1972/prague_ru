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

  Set<String?> setDistrictsSelectedSlug = {}; //
  List<CityDistricts?> lstDistr = [];

  @override
  Widget build(BuildContext context) {
    ReqRes<List<CityDistricts?>> rxList =
        ReqRes<List<CityDistricts?>>(200, 'OK', lstDistr);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocale.praga_district.getString(context)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        var dd = citydistrictsGetX.rxDistricts.value.model!.toSet();
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 10,
                child: Center(
                  child:
                      //=============//=========//=====//=============//===========//
                      getCentral(
                          rxList
                          // citydistrictsGetX.rxDistricts.value
                          ,
                          context),
                ),
              ),
              //=============//=========//=====//=============//===========//
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                  ),
                  child: SwitchListTile(
                    title: Text(AppLocale.all.getString(context)),
                    value: setDistrictsSelectedSlug.length == lstDistr.length,
                    onChanged: (value) {
                      if (value) {
                        print(value);
                        int h = 0;
                        setState(() {
                          setDistrictsSelectedSlug.add(null);
                          setDistrictsSelectedSlug
                              .addAll(citydistrictsGetX.getDistrictSlug());
                        });
                      } else {
                        setState(() {
                          setDistrictsSelectedSlug.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
              //=============//=========//=====//=============//===========//
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
                                citydistrictsGetX.setCityDistrictsSelected(
                                    setDistrictsSelectedSlug);
                                Navigator.pop(
                                    context, true); // Возвращаем результат
                              });
                            },
//                             onPressed: () {
//                               setState(() {
// //==//==//==//=================================================
//                                 print(setDistrictsSelectedSlug.length);

//                                 citydistrictsGetX.setCityDistrictsSelected(
//                                     setDistrictsSelectedSlug);
//                                 int h = 0;
//                                 Navigator.pop(context);
// //==//==//==//=================================================
//                               });
//                             },
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

      setDistrictsSelectedSlug.add(null);
      setDistrictsSelectedSlug.addAll(citydistrictsGetX.rxSelected);

      CityDistricts cityNull =
          CityDistricts(id: 0, name: 'null', slug: null, feature: null);

      lstDistr.add(cityNull);
      lstDistr.addAll(citydistrictsGetX.rxDistricts.value.model!);
      int g2 = 0;
    });
    super.initState();
  }

  Widget getCentral(ReqRes<List<CityDistricts?>> reqRes, BuildContext context) {
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
          if (reqRes.model![index]!.slug == null) {
            print(reqRes.model![index]!.slug);
            int a = 0;
          }

          return CheckboxListTile(
            value: setDistrictsSelectedSlug.contains(reqRes.model![index]!.slug)
                ? true
                : false,
            onChanged: (bool? value) {
              print(value);

              if (value!) {
                setState(() {
                  setDistrictsSelectedSlug.add(reqRes.model![index]!.slug);
                });
              } else {
                setState(() {
                  setDistrictsSelectedSlug.removeWhere(
                      (item) => item == reqRes.model![index]!.slug);
                });
              }
              print(reqRes.model![index]!.name);
            },
            title: Text(reqRes.model![index]!.name),
          );
        },
      );
    }
  }
}
