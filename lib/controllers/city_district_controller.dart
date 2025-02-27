import 'package:get/get.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/dto_classes/req_res.dart';

class CityDistrictsController extends GetxController {
  // Явно указываем тип ReqRes<List<CityDistricts>>
  var rxDistricts = ReqRes<List<CityDistricts>>.empty().obs;

  var rxSelected = ReqRes<List<CityDistricts>>.empty().obs;

  void setCityDistricts(ReqRes<List<CityDistricts>> newModel) {
    rxDistricts.value = newModel;
  }

  void setCityDistrictsSelected(ReqRes<List<CityDistricts>> newModel) {
    rxSelected.value = newModel;
  }

  Set<String?> getSelectDistrictSlug() {
    Set<String?> set = {};

    rxSelected.value.model!.forEach((model) {
      set.add(model.slug!.toString().trim());
    });

    return set;
  }
}
