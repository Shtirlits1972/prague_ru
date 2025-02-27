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
  Rx<ReqRes<MedicalType>> rxReqResType = ReqRes<MedicalType>.empty().obs;

  Rx<ReqRes<MedicalType>> rxReqResTypeSelected =
      ReqRes<MedicalType>.empty().obs;

  void setTypeSelected(ReqRes<MedicalType> models) {
    rxReqResTypeSelected.value = models;
  }

  void setMedical(ReqRes<GeoJSONFeatureCollection> newModel) {
    rxReqRes.value = newModel;
  }

  ReqRes<GeoJSONFeatureCollection?> getFiltered(Set<String?> district) {
    var features = rxReqRes.value.model!.features;

    List<GeoJSONFeature?> filtered = features.where((feature) {
      int g3 = 0;
      return district.contains(feature?.properties!['district']);
    }).toList();

    List<GeoJSONFeature> f2 = [];

    filtered.forEach((feature) {
      if (feature != null) {
        f2.add(feature);
      }
    });

    GeoJSONFeatureCollection collect = GeoJSONFeatureCollection(f2);

    ReqRes<GeoJSONFeatureCollection> newRx =
        ReqRes<GeoJSONFeatureCollection>(200, 'OK', collect);

    // Rx<ReqRes<GeoJSONFeatureCollection>> rx = ReqRes<GeoJSONFeatureCollection>.empty().obs;

    // rx.value.model!.features = filtered;

    return newRx;
  }

  void setMedicalType(ReqRes<MedicalType> newModel) {
    rxReqResType.value = newModel;
  }
}
