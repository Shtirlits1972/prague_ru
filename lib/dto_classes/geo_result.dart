import 'package:geolocator/geolocator.dart';

class GeoResult {
  Position? position = null;
  String message = '';
  bool success = false;

  GeoResult(this.position, this.message, this.success);
  GeoResult.empty() {
    position = null;
    message = '';
    success = false;
  }

  @override
  String toString() {
    return 'position = $position, message = $message, success = $success';
  }
}
