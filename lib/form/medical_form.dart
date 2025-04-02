import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:prague_ru/controllers/city_district_controller.dart';
import 'package:prague_ru/controllers/medical_controller.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/form/district_filter_form.dart';
import 'package:prague_ru/form/medical_type_form.dart';
import 'package:prague_ru/form/setting_form.dart';
import 'package:prague_ru/form/web_google_map_form.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/services/medical_crud.dart';
import 'package:prague_ru/widget/drawer.dart';
import 'package:prague_ru/widget/item_widget.dart';
import 'package:flutter/foundation.dart';

class MedicalForm extends StatefulWidget {
  const MedicalForm({Key? key}) : super(key: key);

  @override
  _MedicalFormState createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  final MedicalController medicalController = Get.put(MedicalController());
  final CityDistrictsController cityDistrictsController =
      Get.put(CityDistrictsController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPage = 0;
  late UniqueKey _paginatorKey;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _paginatorKey = UniqueKey();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (medicalController.rxReqRes.value.status == 0) {
      await medicalController.loadMedicalData();
    }
    if (medicalController.rxMedicalType.value.status == 0) {
      await medicalController.loadMedicalTypes();
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Добавляем ключ к Scaffold
      drawer: const DrawerMenu(),
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Obx(() => _buildBody(context)),
      bottomNavigationBar: _buildPaginator(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        icon: const Icon(Icons.menu_rounded),
      ),
      title: Text(AppLocale.medical_institurions.getString(context)),
      centerTitle: true,
      actions: [_buildFilterMenu()],
    );
  }

  Widget _buildFilterMenu() {
    return PopupMenuButton<int>(
      onSelected: (item) async {
        if (item == 0) {
          await Navigator.pushNamed(
              _scaffoldKey.currentContext!, DistrictFilterForm.route);
        } else if (item == 1) {
          await Navigator.pushNamed(
              _scaffoldKey.currentContext!, MedicalTypeForm.route);
        }
        _resetPaginator();
      },
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              const Icon(Icons.apartment, color: Colors.black),
              const SizedBox(width: 5),
              Text(AppLocale.districts.getString(context)),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.medical_information, color: Colors.black),
              const SizedBox(width: 5),
              Text(AppLocale.medical_types.getString(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final filteredData = medicalController.getFiltered(
      cityDistrictsController.rxSelected,
      medicalController.rxSelected,
    );

    if (filteredData.model == null || filteredData.model!.features.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No Data'),
            Text(filteredData.message),
          ],
        ),
      );
    }

    final paginatedFeatures = _getPaginatedFeatures(filteredData.model!);
    return _buildMedicalList(context, paginatedFeatures);
  }

  Widget _buildMedicalList(
      BuildContext context, List<GeoJSONFeature> features) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(thickness: 1),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildMedicalItem(context, feature, index);
      },
    );
  }

  Widget _buildMedicalItem(
      BuildContext context, GeoJSONFeature feature, int index) {
    final properties = feature.properties!;
    final name = properties['name'];
    final address = properties['address']['address_formatted'];
    final district = properties['district'];
    final type = properties['type']['description'];
    final phoneList = properties['telephone'] as List;
    final openingHours = properties['opening_hours'] as List;

    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.trailing,
      childrenPadding: const EdgeInsets.all(16),
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text('${index + 1}'),
        ),
      ),
      title: InkWell(
        onTap: () => _navigateToMedicalMap(feature),
        child: Text(
          name,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      subtitle: Text(properties['address']['street_address']),
      children: [
        ItemWidget(title: 'address', content: address),
        _buildPhoneColumn(phoneList),
        ItemWidget(title: 'district', content: district?.toString() ?? 'N/A'),
        ItemWidget(title: 'type', content: type),
        _buildOpeningHoursColumn(openingHours),
      ],
    );
  }

  Widget _buildPhoneColumn(List<dynamic> phoneList) {
    if (phoneList.isEmpty) return const SizedBox.shrink();

    return Column(
      children: phoneList
          .map((phone) =>
              ItemWidget(title: 'telephone', content: phone.toString()))
          .toList(),
    );
  }

  Widget _buildOpeningHoursColumn(List<dynamic> openingHours) {
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

  Widget _buildPaginator() {
    final filteredData = medicalController.getFiltered(
      cityDistrictsController.rxSelected,
      medicalController.rxSelected,
    );

    final totalPages = _calculateTotalPages(filteredData.model);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      child: NumberPaginator(
        key: _paginatorKey,
        initialPage: _currentPage,
        numberPages: totalPages,

        onPageChange: (int index) {
          final totalPages = _calculateTotalPages(filteredData.model);
          if (index >= 0 && index < totalPages) {
            setState(() => _currentPage = index);
          }
        },

        // onPageChange: (index) => setState(() => _currentPage = index),
      ),
    );
  }

  void _navigateToMedicalMap(GeoJSONFeature feature) async {
    if (kIsWeb) {
      try {
        final newKey = ValueKey(DateTime.now().millisecondsSinceEpoch);

        await Navigator.pushNamed(context, WebMapForm.route, arguments: {
          'key': newKey,
          'feature': feature,
          'title': feature.properties!['name'],
          'address': feature.properties!['address']['street_address'],
        });

        setState(() {});
      } catch (e) {
        print(e);
        var t = 0;
      }
    } else {
      Navigator.pushNamed(context, '/MedicalMapForm', arguments: feature);
    }
  }

  void _resetPaginator() {
    setState(() {
      _currentPage = 0; // Сбрасываем на первую страницу
      _paginatorKey = UniqueKey(); // Пересоздаём ключ пагинатора
    });
  }

  List<GeoJSONFeature> _getPaginatedFeatures(
      GeoJSONFeatureCollection collection) {
    if (collection.features.isEmpty) {
      return [];
    }

    final allFeatures =
        collection.features.whereType<GeoJSONFeature>().toList();
    final start = _currentPage * MedicalCrud.page_size;

    // Если start выходит за пределы списка, возвращаем пустой список
    if (start >= allFeatures.length) {
      return [];
    }

    var end = start + MedicalCrud.page_size;
    end = end.clamp(
        0, allFeatures.length); // Гарантируем, что end в пределах списка

    // Дополнительная проверка на случай, если clamp не сработал как ожидалось
    if (start >= end) {
      return [];
    }

    return allFeatures.sublist(start, end);
  }

  int _calculateTotalPages(GeoJSONFeatureCollection? collection) {
    if (collection == null || collection.features.isEmpty) {
      return 1; // Минимум 1 страница даже для пустой коллекции
    }
    return (collection.features.length / MedicalCrud.page_size)
        .ceil()
        .clamp(1, 100);
  }
}
