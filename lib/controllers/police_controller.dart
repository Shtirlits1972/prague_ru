import 'dart:math';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:prague_ru/dto_classes/req_res.dart';

class PoliceController extends GetxController {
  // Явно указываем тип ReqRes
  Rx<ReqRes<GeoJSONFeatureCollection>> rxReqRes =
      ReqRes<GeoJSONFeatureCollection>.empty().obs;

  ReqRes<GeoJSONFeatureCollection> get getPolice => rxReqRes.value;

  void setPolice(ReqRes<GeoJSONFeatureCollection> newModel) {
    rxReqRes.value = newModel;
  }

  GeoJSONFeatureCollection filterByDistricts(Set<String?> districts) {
    // Проверка на null и пустую модель
    if (rxReqRes.value.model == null ||
        rxReqRes.value.model!.features.isEmpty) {
      return GeoJSONFeatureCollection([]);
    }

    // Если нет активных фильтров (выбраны все районы)
    if (shouldReturnAllDistricts(districts)) {
      return rxReqRes.value.model!;
    }

    // Фильтрация и преобразование в List<GeoJSONFeature>
    final filteredFeatures = rxReqRes.value.model!.features
        .where(
            (feature) => feature != null && matchesDistrict(feature, districts))
        .cast<GeoJSONFeature>()
        .toList();

    return GeoJSONFeatureCollection(filteredFeatures);
  }

  bool shouldReturnAllDistricts(Set<String?> districts) {
    return districts.isEmpty || districts.contains(null);
  }

  bool matchesDistrict(GeoJSONFeature feature, Set<String?> districts) {
    final district = feature.properties?['district'] as String?;
    return district != null && districts.contains(district);
  }

  final int itemsPerPage = 50;
  var currentPage = 0.obs;

  List<GeoJSONFeature?> getPaginatedData(GeoJSONFeatureCollection data) {
    if (data.features.isEmpty) return [];

    // Вычисляем максимально возможную страницу
    final maxPage = max(0, (data.features.length - 1) ~/ itemsPerPage);

    // Корректируем текущую страницу, если она вышла за пределы
    if (currentPage.value > maxPage) {
      currentPage.value = maxPage;
    }

    final start = currentPage.value * itemsPerPage;
    final end = min(start + itemsPerPage, data.features.length);
    return data.features.sublist(start, end);
  }

  void changePage(int page) {
    currentPage.value = page;
    update();
  }

  // При фильтрации сбрасываем на первую страницу
  void resetPagination() {
    currentPage.value = 0;
    update();
  }
}
