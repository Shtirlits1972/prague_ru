import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:prague_ru/controllers/city_district_controller.dart';
import 'package:prague_ru/controllers/medical_controller.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/form/district_filter_form.dart';
import 'package:prague_ru/form/medical_type_form.dart';
import 'package:prague_ru/form/setting_form.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/services/medical_crud.dart';
import 'package:prague_ru/services/medical_type_crud.dart';
import 'package:prague_ru/widget/drawer.dart';

class MedicalForm extends StatefulWidget {
  const MedicalForm({Key? key}) : super(key: key);

  @override
  _MedicalFormState createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  final MedicalController medicalGetX = Get.put(MedicalController());
  final CityDistrictsController cityDistrCtrl =
      Get.put(CityDistrictsController());

  ReqRes<GeoJSONFeatureCollection?> all =
      ReqRes<GeoJSONFeatureCollection?>.empty();

  ReqRes<GeoJSONFeatureCollection?> parts =
      ReqRes<GeoJSONFeatureCollection?>.empty();

  // @override
  // void initState() {
  //   super.initState();

  //   all = medicalGetX.getFiltered(
  //       cityDistrCtrl.rxSelected, medicalGetX.rxSelected);

  // }

  @override
  Widget build(BuildContext context) {
    int _currentPage = 0; // Переменная для хранения текущей страницы
    UniqueKey _paginatorKey = UniqueKey();
    Widget central = Center(
      child: Text('Ops...'),
    );

    // _currentPage = 4;

    if ((cityDistrCtrl.rxSelected != null &&
            cityDistrCtrl.rxSelected.isNotEmpty) &&
        (medicalGetX.rxSelected != null && medicalGetX.rxSelected.isNotEmpty)) {
      try {
        all = medicalGetX.getFiltered(
            cityDistrCtrl.rxSelected, medicalGetX.rxSelected);
      } catch (e) {
        print(e);
        var rr = 0;
      }

      print(all);

      var start = 0;
      var end = 0;

      if (all.model!.features.length >= _currentPage * MedicalCrud.page_size) {
        start = _currentPage * MedicalCrud.page_size;
      }

      if (all.model!.features.length >=
          _currentPage * MedicalCrud.page_size + MedicalCrud.page_size) {
        end = _currentPage * MedicalCrud.page_size + MedicalCrud.page_size;
      } else {
        end = all.model!.features.length;
      }

      List<GeoJSONFeature?> collect = all.model!.features.sublist(start, end);

      List<GeoJSONFeature> collect2 = [];

      collect.forEach((val) {
        if (val != null) {
          collect2.add(val);
        }
      });

      GeoJSONFeatureCollection geo = GeoJSONFeatureCollection(collect2);
      print(geo);
      var r1 = 0;
      parts = ReqRes<GeoJSONFeatureCollection?>(all.status, all.message, geo);

      print(parts);

      var r = 0;
    }

    return Scaffold(
      drawer: const DrawerMenu(),
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
        title: Text(AppLocale.medical_institurions.getString(context)),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) {
              if (item == 0) {
                Navigator.pushNamed(context, DistrictFilterForm.route)
                    .then((value) {
                  int h = 0;
                  setState(() {
                    central = getCentral(
                        medicalGetX.getFiltered(
                            cityDistrCtrl.rxSelected, medicalGetX.rxSelected),
                        context);
                  });
                });
              } else if (item == 1) {
                Navigator.pushNamed(context, MedicalTypeForm.route)
                    .then((value) {
                  int h = 0;
                  setState(() {
                    central = getCentral(
                        medicalGetX.getFiltered(
                            cityDistrCtrl.rxSelected, medicalGetX.rxSelected),
                        context);
                  });
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.apartment, color: Colors.black),
                      SizedBox(width: 5),
                      Text(AppLocale.districts.getString(context)),
                    ],
                  )),
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.medical_information, color: Colors.black),
                      SizedBox(width: 5),
                      Text(AppLocale.medical_types.getString(context)),
                    ],
                  )),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (medicalGetX.rxReqRes.value.status == 0) {
          print('hello');
          MedicalCrud.getData().then((value) {
            setState(() {
              medicalGetX.rxReqRes.value = value;
            });
          });
        }
        //==//===========//===============//=====================//==============
        if (medicalGetX.rxMedicalType.value.status == 0) {
          MedicalCrud.getMedicalTypes().then((value) {
            medicalGetX.setMedicalType(value);
            medicalGetX.setMedicalTypeSelected(value.model!);
          });
        }

        central = medicalGetX.rxReqRes.value.status == 0
            ? CircularProgressIndicator(
                color: Colors.blue,
              )
            : getCentral(
                medicalGetX.getFiltered(
                    cityDistrCtrl.rxSelected, medicalGetX.rxSelected),
                context);

        return Center(child: central);
      }),
      //===================   paginator   ======================
      // bottomNavigationBar: Card(
      //   margin: EdgeInsets.zero,
      //   elevation: 4,
      //   child: NumberPaginator(
      //     key: _paginatorKey,
      //     initialPage: _currentPage,
      //     // by default, the paginator shows numbers as center content
      //     numberPages: (parts.model != null && parts.model!.features.isNotEmpty)
      //         ? (parts.model!.features.length / MedicalCrud.page_size).round()
      //         : 1,
      //     onPageChange: (int index) {
      //       setState(() {
      //         _currentPage = index; // Обновление текущей страницы

      //         print('indes = $index');
      //       });
      //     },
      //   ),
      // ),
      //===================   paginator   ======================
    );
  }

  // -------------------  getCentral  ----------------------------
  Widget getCentral(
      ReqRes<GeoJSONFeatureCollection?> reqRes, BuildContext context) {
    if (reqRes.model == null && reqRes.model!.features.isEmpty) {
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
        itemCount: reqRes.model!.features.length,
        itemBuilder: (context, index) {
          var properties = reqRes.model!.features[index]!.properties!;

          String name = properties['name'];
          String adress = properties['address']['address_formatted'];
          String? district = properties['district'];

          var phone_list = properties['telephone'] as List;

          List<ItemWidget> listPhones = [];

          Column phoneCol = Column();

          if (phone_list.isNotEmpty) {
            String phoneValue = '';
            for (int i = 0; i < phone_list.length; i++) {
              phoneValue += phone_list[i].toString() + '\n';
            }
            listPhones.add(ItemWidget(title: 'telephone', content: phoneValue));

            phoneCol = Column(
              children: listPhones,
            );
          }
          String type = properties['type']['description'];

          var opening_hours = properties['opening_hours'] as List;

          List<Widget> listHours = [];

          if (opening_hours.isNotEmpty) {
            listHours.add(Text('opening hours'));

            opening_hours.forEach(
              (element) {
                listHours.add(ItemWidget(
                    title: element['day_of_week'].toString(),
                    content:
                        '${element['opens'].toString()} - ${element['closes'].toString()}'));
              },
            );
          }

          Column colHours = Column(
            children: listHours,
          );

          return ExpansionTile(
            controlAffinity: ListTileControlAffinity.trailing,
            childrenPadding: EdgeInsets.all(16),
            leading: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  '${index + 1}',
                ),
              ),
            ),
            dense: true,
            title: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/MedicalMapForm',
                    arguments: reqRes.model!.features[index]!);
                // print(reqRes.model!.features[index]!.properties!);
              },
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            subtitle: Text(properties['address']['street_address']),
            children: [
              ItemWidget(title: 'adress', content: adress),
              phoneCol,
              ItemWidget(title: 'district', content: district),
              ItemWidget(title: 'type', content: type),
              colHours
            ],
          );
        },
      );
    }
  }
}
