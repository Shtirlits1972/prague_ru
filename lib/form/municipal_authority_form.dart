import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:prague_ru/controllers/city_district_controller.dart';
import 'package:prague_ru/controllers/municipal_authorities_controller.dart';
import 'package:prague_ru/controllers/police_controller.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/form/municipal_authority_map.dart';
import 'package:prague_ru/form/police_map.dart';
import 'package:prague_ru/form/setting_form.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/services/municipal_authorities_crud.dart';
import 'package:prague_ru/services/police_crud.dart';
import 'package:prague_ru/widget/alert.dart';
import 'package:prague_ru/widget/drawer.dart';
import 'package:prague_ru/form/district_filter_form.dart';
import 'package:prague_ru/widget/item_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MunicipalAuthorityForm extends StatefulWidget {
  const MunicipalAuthorityForm({Key? key}) : super(key: key);

  static const String route = '/MunicipalAuthorityForm';

  @override
  _MunicipalAuthorityFormState createState() => _MunicipalAuthorityFormState();
}

class _MunicipalAuthorityFormState extends State<MunicipalAuthorityForm> {
  final MunicipalAuthritiesController municipalGetX =
      Get.find<MunicipalAuthritiesController>();
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
        title: Text(AppLocale.municipai_authority.getString(context)),
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
                municipalGetX.resetPagination();
                municipalGetX.rxReqRes.value =
                    ReqRes<GeoJSONFeatureCollection>.empty();
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (municipalGetX.rxReqRes.value.status == 0) {
          MunicipalAuthoritiesCrud.getData().then((value) {
            setState(() {
              municipalGetX.rxReqRes.value = value;
            });
          });
        }
        //==//===========//===============//=====================//==============
        if (municipalGetX.getPolice.status == 0) {
          MunicipalAuthoritiesCrud.getData().then((value) {
            municipalGetX.setMunicipalAuthrities(value);
          });
        }

        central = municipalGetX.rxReqRes.value.status == 0
            ? CircularProgressIndicator(
                color: Colors.blue,
              )
            : getCentral(municipalGetX.getPolice, context);

        return Center(child: central);
      }),
    );
  }

  // -------------------  getCentral  ----------------------------
  Widget getCentral(
      ReqRes<GeoJSONFeatureCollection?> reqRes, BuildContext context) {
    final municipalController = Get.find<MunicipalAuthritiesController>();
    final cityDistrictsController = Get.find<CityDistrictsController>();

    if (reqRes.model == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredData = municipalController
        .filterByDistricts(cityDistrictsController.rxSelected);

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

    final paginatedData = municipalController.getPaginatedData(filteredData);
    final totalPages = max(
        1,
        (filteredData.features.length / municipalController.itemsPerPage)
            .ceil());

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: paginatedData.length,
            separatorBuilder: (context, index) => const Divider(thickness: 1),
            itemBuilder: (context, index) {
              final item = paginatedData[index]!;
              return ExpansionTile(
                controlAffinity: ListTileControlAffinity.trailing,
                childrenPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                      '${index + 1 + (municipalController.currentPage.value * municipalController.itemsPerPage)}'),
                ),
                title: InkWell(
                  child: Text(item.properties!['name']),
                  onTap: () => Navigator.pushNamed(
                    context,
                    MunicipaiAuthorityMap.route,
                    arguments: item,
                  ),
                ),
                subtitle:
                    Text(item.properties!['address']['address_formatted']),
                children: [
                  Image.network(item.properties!['image']['url']),
                  buildLinkWidget(context, item.properties!['official_board']),
                  _buildPhoneColumn(item.properties!['telephone']),
                  _get_open_hours(item.properties!['opening_hours']),
                ],
              );
            },
          ),
        ),
        if (totalPages > 1)
          NumberPaginator(
            numberPages: totalPages,
            initialPage: municipalController.currentPage.value,
            onPageChange: (int page) {
              municipalController.changePage(page);
            },
          ),
      ],
    );
  }

  Widget buildLinkWidget(BuildContext context, String? url) {
    if (url == null || url.isEmpty) {
      return const SizedBox.shrink();
    }

    // Добавляем проверку и коррекцию URL
    String correctedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      correctedUrl = 'http://$url';
    }

    return InkWell(
      onTap: () async {
        try {
          final uri = Uri.parse(correctedUrl);
          if (!await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          )) {
            _showError(context, 'Не удалось открыть ссылку');
            debugPrint('Failed to launch: $correctedUrl');
          }
        } catch (e) {
          _showError(context, 'Incorrect URL');
          debugPrint('URL error: $e\nOriginal URL: $url');
        }
      },
      child: Text(
        AppLocale.official_website.getString(context),
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 20,
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _get_open_hours(List<dynamic> openingHours) {
    if (openingHours.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const Text('opening hours'),
        ...openingHours
            .map((hour) => ItemWidget(
                title: hour['day_of_week'].toString(),
                content: '${hour['opens']} - ${hour['closes']}'))
            .toList(),
      ],
    );
  }

  Widget _buildPhoneColumn(List<dynamic> phoneList) {
    if (phoneList.isEmpty) return const SizedBox.shrink();

    String phones = '';

    phoneList.forEach((item) {
      phones += item.toString() + "\r\n";
    });

    return ItemWidget(title: 'telephone', content: phones.trim());
  }
}
