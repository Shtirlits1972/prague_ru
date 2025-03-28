import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:prague_ru/controllers/city_district_controller.dart';
import 'package:prague_ru/controllers/police_controller.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/form/police_map.dart';
import 'package:prague_ru/form/setting_form.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/services/police_crud.dart';
import 'package:prague_ru/widget/drawer.dart';
import 'package:prague_ru/form/district_filter_form.dart';

class PoliceForm extends StatefulWidget {
  const PoliceForm({Key? key}) : super(key: key);

  static const String route = '/PoliceForm';

  @override
  _PoliceFormState createState() => _PoliceFormState();
}

class _PoliceFormState extends State<PoliceForm> {
  final PoliceController policeGetX = Get.find<PoliceController>();
  @override
  Widget build(BuildContext context) {
    Widget central = Center(
      child: Text('Ops...'),
    );

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
        title: Text(AppLocale.police_stations.getString(context)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                DistrictFilterForm.route,
              );
              if (result != null) {
                // Сбрасываем пагинацию и обновляем данные
                policeGetX.resetPagination();
                policeGetX.rxReqRes.value =
                    ReqRes<GeoJSONFeatureCollection>.empty();
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (policeGetX.rxReqRes.value.status == 0) {
          print('hello');
          PoliceCrud.getData().then((value) {
            setState(() {
              policeGetX.rxReqRes.value = value;
            });
          });
        }
        //==//===========//===============//=====================//==============
        if (policeGetX.getPolice.status == 0) {
          PoliceCrud.getData().then((value) {
            policeGetX.setPolice(value);
          });
        }

        central = policeGetX.rxReqRes.value.status == 0
            ? CircularProgressIndicator(
                color: Colors.blue,
              )
            : getCentral(policeGetX.getPolice, context);

        return Center(child: central);
      }),
    );
  }

  // -------------------  getCentral  ----------------------------
  Widget getCentral(
      ReqRes<GeoJSONFeatureCollection?> reqRes, BuildContext context) {
    final policeController = Get.find<PoliceController>();
    final cityDistrictsController = Get.find<CityDistrictsController>();

    if (reqRes.model == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredData =
        policeController.filterByDistricts(cityDistrictsController.rxSelected);

    // Если после фильтрации данных нет
    if (filteredData.features.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocale.no_data.getString(context)),
            if (cityDistrictsController.rxSelected.isNotEmpty)
              Text(AppLocale.try_change_filters.getString(context)),
          ],
        ),
      );
    }

    final paginatedData = policeController.getPaginatedData(filteredData);
    final totalPages = max(1,
        (filteredData.features.length / policeController.itemsPerPage).ceil());

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: paginatedData.length,
            separatorBuilder: (context, index) => const Divider(thickness: 1),
            itemBuilder: (context, index) {
              final item = paginatedData[index]!;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                      '${index + 1 + (policeController.currentPage.value * policeController.itemsPerPage)}'),
                ),
                title: Text(item.properties!['address']['street_address']),
                subtitle: Text(item.properties!['district']),
                onTap: () => Navigator.pushNamed(
                  context,
                  PoliceMap.route,
                  arguments: item,
                ),
              );
            },
          ),
        ),
        if (totalPages > 1)
          NumberPaginator(
            numberPages: totalPages,
            initialPage: policeController.currentPage.value,
            onPageChange: (int page) {
              policeController.changePage(page);
            },
          ),
      ],
    );
  }
}
