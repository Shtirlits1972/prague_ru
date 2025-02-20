import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:prague_ru/dto_classes/req_res.dart';

class MedicalController extends GetxController {
  // Явно указываем тип ReqRes<List<CityDistricts>>
  Rx<ReqRes<GeoJSONFeatureCollection>> rxReqRes =
      ReqRes<GeoJSONFeatureCollection>.empty().obs;

  void setMedical(ReqRes<GeoJSONFeatureCollection> newModel) {
    rxReqRes.value = newModel;
  }
}
