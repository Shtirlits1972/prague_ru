import 'package:get/get.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/dto_classes/req_res.dart';

class CityDistrictsController extends GetxController {
  // Явно указываем тип ReqRes<List<CityDistricts>>
  var rxDistricts = ReqRes<List<CityDistricts>>.empty().obs;

  // Rx<Set<String?>> rxSelected  = <Set<String?>>{}.obs;
  var rxSelected = <String?>{}.obs;

  void setCityDistricts(ReqRes<List<CityDistricts>> newModel) {
    rxDistricts.value = newModel;
  }

  void setCityDistrictsSelected(Set<String?> newModel) {
    rxSelected.value = newModel;
  }

  Set<String?> getDistrictSlug() {
    Set<String?> set = {};

    rxDistricts.value.model!.forEach((model) {
      set.add(model.slug!.toString().trim());
    });

    return set;
  }
}
