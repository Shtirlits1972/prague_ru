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
}
