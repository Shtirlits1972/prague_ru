import 'package:prague_ru/dto_classes/geometry.dart';
import 'package:geojson_vi/geojson_vi.dart';

class CityDistricts {
  int id;
  String name;
  String? slug;
  String? updated_at;
  GeoJSON? geometry; // Теперь geometry не может быть null

  CityDistricts({
    required this.id,
    required this.name,
    required this.slug,
    this.updated_at,
    this.geometry, // geometry теперь обязательное поле
  });

  factory CityDistricts.fromJson(Map<String, dynamic> json) {
    return CityDistricts(
      id: json['properties']['id'],
      name: json['properties']['name'],
      slug: json['properties']['slug'],
      updated_at: json['properties']['updated_at'],
      geometry: GeoJSON.fromMap(
          json['geometry']), // geometry всегда должно быть в JSON
    );
  }

  @override
  String toString() {
    return 'id = $id, name = $name, slug = $slug, updated_at = $updated_at, geometry = ${geometry.toString()}';
  }
}
