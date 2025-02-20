import 'package:geolocator/geolocator.dart';
import 'package:prague_ru/dto_classes/geo_result.dart';

class Geo {
  static Future<GeoResult> getCoordinates() async {
    GeoResult geo = GeoResult.empty();
    bool serviceEnabled;
    LocationPermission permission;

    // Проверяем, включена ли геолокация
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Геолокация отключена");
      geo.message = "Геолокация отключена";
      geo.success = false;
      return geo;
    }

    // Запрашиваем разрешение
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Разрешение на геолокацию отклонено");
        geo.message = "Разрешение на геолокацию отклонено";
        geo.success = false;
        return geo;
      }
    }
    //---------------------------------------

    if (permission == LocationPermission.deniedForever) {
      print("Разрешение навсегда отклонено");
      geo.message = "Разрешение навсегда отклонено";
      geo.success = false;
      return geo;
    }

    try {
      // Получаем текущие координаты
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Широта: ${position.latitude}, Долгота: ${position.longitude}");

      //-----------------------------------------------------------------------
      geo.message = "${position.toString()}";
      geo.success = true;
      geo.position = position;
      return geo;
    } catch (e) {
      geo.message = e.toString();
      geo.success = false;
      return geo;
    }
  }
}
