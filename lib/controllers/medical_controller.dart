import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/services/medical_crud.dart';

class MedicalController extends GetxController {
  final Rx<ReqRes<GeoJSONFeatureCollection>> rxReqRes =
      ReqRes<GeoJSONFeatureCollection>.empty().obs;

  final Rx<ReqRes<Set<String>>> rxMedicalType = ReqRes<Set<String>>.empty().obs;
  final rxSelected = <String>{}.obs;

  Future<void> loadMedicalData() async {
    try {
      final data = await MedicalCrud.getData();
      rxReqRes.value = data;
    } catch (e) {
      rxReqRes.value.message = 'Failed to load medical data: $e';
    }
  }

  Future<void> loadMedicalTypes() async {
    try {
      final types = await MedicalCrud.getMedicalTypes();
      rxMedicalType.value = types;
      if (types.model != null) {
        rxSelected.value = types.model!;
      }
    } catch (e) {
      rxMedicalType.value.message = 'Failed to load medical types: $e';
    }
  }

  void setMedicalTypeSelected(Set<String> models) {
    rxSelected.value = models;
  }

  ReqRes<GeoJSONFeatureCollection?> getFiltered(
      Set<String?> districts, Set<String> medicalTypes) {
    if (rxReqRes.value.model == null) {
      return ReqRes(0, 'Data not loaded yet', null);
    }

    final features = rxReqRes.value.model!.features.whereType<GeoJSONFeature>();

    final filtered = features.where((feature) {
      final district = feature.properties?['district'];
      final type = feature.properties?['type']?['description'];

      // Учитываем district == null, если districts содержит null
      final districtMatch = districts.isEmpty ||
          districts.contains(district) ||
          (districts.contains(null) && district == null);

      final typeMatch =
          medicalTypes.isEmpty || (type != null && medicalTypes.contains(type));

      return districtMatch && typeMatch;
    }).toList();

    return ReqRes(
      200,
      'OK',
      GeoJSONFeatureCollection(filtered),
    );
  }
}
