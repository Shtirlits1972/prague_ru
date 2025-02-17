import 'package:get/get.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/dto_classes/req_res.dart';

class CityDistrictsController extends GetxController {
  // Явно указываем тип ReqRes<List<CityDistricts>>
  var rxReqRes = ReqRes<List<CityDistricts>>.empty().obs;

  void setCityDistricts(ReqRes<List<CityDistricts>> newModel) {
    rxReqRes.value = newModel;
  }
}
