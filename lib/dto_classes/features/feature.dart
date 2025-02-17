// import 'package:prague_ru/dto_classes/geometry.dart';
// import 'package:prague_ru/dto_classes/features/properties.dart';

// class Feature {
//   final Geometry geometry;
//   final Properties properties;
//   final String type;

//   Feature({
//     required this.geometry,
//     required this.properties,
//     required this.type,
//   });

//   // Десериализация JSON в объект Feature
//   factory Feature.fromJson(Map<String, dynamic> json) {
//     return Feature(
//       geometry: Geometry.fromJson(json['geometry']),
//       properties: Properties.fromJson(json['properties']),
//       type: json['type'],
//     );
//   }

//   // Сериализация объекта Feature в JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'geometry': geometry.toJson(),
//       'properties': properties.toJson(),
//       'type': type,
//     };
//   }
// }
