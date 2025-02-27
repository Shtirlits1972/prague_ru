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

  Rx<ReqRes<GeoJSONFeatureCollection>> getFiltered(Set<String?> district) {
    var features = rxReqRes.value.model!.features;

    int h = 0;
    // var filtered = features.where((feature) {
    //   return feature!.properties!["type"]["description"] != null &&
    //       ((rxReqResTypeSelected.value.model!.health_care
    //               .contains(feature.properties!["type"]["description"])) ||
    //           (rxReqResTypeSelected.value.model!.pharmacies
    //               .contains(feature.properties!["type"]["description"])));
    // }).toList();

    // for (int i = 0; i < features.length; i++) {
    //   if (!district
    //       .contains(features[i]!.properties!['district'].toString().trim())) {
    //     print(features[i]!.properties!['district'].toString().trim());
    //     int h = 0;
    //   }
    // }

    var filtered = features.where((feature) {
      return feature!.properties!['district'] != null &&
          (district
              .contains(feature!.properties!['district'].toString().trim()));
    }).toList();

    Rx<ReqRes<GeoJSONFeatureCollection>> rx = rxReqRes;

    rx.value.model!.features = filtered;

    return rx;
  }

  void setMedicalType(ReqRes<MedicalType> newModel) {
    rxReqResType.value = newModel;
  }
}
