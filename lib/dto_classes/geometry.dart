// import 'dart:convert';

// import 'package:geojson_vi/geojson_vi.dart';

// class Geometry {
//   String type = ''; // Тип геометрии: "Point" или "Polygon"
//   GeoJSON coordinates ; // Координаты: List<double> для Point, List<List<double>> для Polygon

//   // Конструктор для создания Geometry с указанием типа и координат
//   Geometry({
//     required this.type,
//     required this.coordinates,
//   }) {
//     // Проверка на корректность типа и координат
//     if (type != 'Point' && type != 'Polygon') {
//       throw ArgumentError('Type must be either "Point" or "Polygon"');
//     }
//     if (type == 'Point' && coordinates is! List<double>) {
//       throw ArgumentError('Coordinates for Point must be List<double>');
//     }
//     if (type == 'Polygon' && coordinates is! List<List<double>>) {
//       throw ArgumentError('Coordinates for Polygon must be List<List<double>>');
//     }
//   }

//   // Конструктор empty() для создания пустой геометрии
//   Geometry.empty() {
//     type = 'Point';
//     coordinates = GeoJSON.;
//   }

//   // Переопределение метода toString()
//   @override
//   String toString() {
//     return 'Geometry(type: $type, coordinates: $coordinates)';
//   }

//   // Сериализация объекта Geometry в JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'coordinates': coordinates,
//     };
//   }

//   // Десериализация JSON в объект Geometry
//   factory Geometry.fromJson(Map<String, dynamic> json) {
//     final type = json['type'];
//     List<dynamic> coordinates = json['coordinates'] as List<dynamic>;

//     int y2 = 0;

//     if (type == 'Point') {
//       T lstDouble = [];

//       coordinates.forEach(
//         (element) {
//           double item = element as double;
//           lstDouble.add(item);
//         },
//       );

//       return Geometry(
//         type: type,
//         coordinates: lstDouble,
//       );
//     } else if (type == 'Polygon') {
//       List<List<double>> lstDouble = [];
//       coordinates.forEach(
//         (element) {},
//       );

//       return Geometry<T>(type: type, coordinates: lstDouble);
//     } else {
//       throw ArgumentError('Invalid type in JSON: $type');
//     }
//   }
// }
