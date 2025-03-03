import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:prague_ru/dto_classes/features/properties.dart';
import 'package:prague_ru/dto_classes/medical_type.dart';
import 'package:prague_ru/dto_classes/req_res.dart';

class MedicalController extends GetxController {
  // Явно указываем тип ReqRes<List<CityDistricts>>
  Rx<ReqRes<GeoJSONFeatureCollection>> rxReqRes =
      ReqRes<GeoJSONFeatureCollection>.empty().obs;

  // типы медучереждений
  Rx<ReqRes<Set<String>>> rxMedicalType = ReqRes<Set<String>>.empty().obs;

  var rxSelected = <String>{}.obs;

  void setMedicalType(ReqRes<Set<String>> newModel) {
    rxMedicalType.value = newModel;
  }

  void setMedicalTypeSelected(Set<String> models) {
    rxSelected.value = models;
  }

  void setMedical(ReqRes<GeoJSONFeatureCollection> newModel) {
    rxReqRes.value = newModel;
  }

  ReqRes<GeoJSONFeatureCollection?> getFiltered(
      Set<String?> district, Set<String> medicalType) {
    var features = rxReqRes.value.model!.features;

    List<GeoJSONFeature?> filtered = features.where((feature) {
      int g3 = 0;
      return district.contains(feature?.properties!['district']);
    }).toList();

    List<GeoJSONFeature?> filtered2 = filtered.where((feature) {
      return medicalType.contains(feature?.properties!['type']['description']);
    }).toList();

    List<GeoJSONFeature> f2 = [];

    filtered2.forEach((feature) {
      if (feature != null) {
        f2.add(feature);
      }
    });

    GeoJSONFeatureCollection collect = GeoJSONFeatureCollection(f2);

    ReqRes<GeoJSONFeatureCollection> newRx =
        ReqRes<GeoJSONFeatureCollection>(200, 'OK', collect);

    return newRx;
  }
}
