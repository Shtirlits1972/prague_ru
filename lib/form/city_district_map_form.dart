import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:prague_ru/services/geo.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CityDistrictMapForm extends StatefulWidget {
  CityDistrictMapForm({Key? key, required this.cityDistricts})
      : super(key: key);

  CityDistricts cityDistricts;

  @override
  _CityDistrictMapFormState createState() => _CityDistrictMapFormState();
}

class _CityDistrictMapFormState extends State<CityDistrictMapForm> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  // LatLng? point = null;

  LatLng _centerPoint = LatLng(50.124935, 14.457204); // Прага

  // Полигон
  final Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();

    if (widget.cityDistricts.geometry is GeoJSONPolygon) {
      // Извлекаем координаты из GeoJSON
      final polygon = widget.cityDistricts.geometry as GeoJSONPolygon;
      final coordinates = polygon.coordinates;

      _centerPoint = LatLng(polygon.centroid[1], polygon.centroid[0]);

      // Преобразуем координаты в List<LatLng>
      final List<LatLng> polygonPoints = coordinates[0]
          .map((point) => LatLng(
              point[1], point[0])) // GeoJSON использует [долгота, широта]
          .toList();

      // Добавляем полигон на карту
      setState(() {
        // Добавляем маркер на карту
        markers.add(
          Marker(
            markerId: MarkerId(widget.cityDistricts.id.toString()),
            position: _centerPoint,
            infoWindow: InfoWindow(title: widget.cityDistricts.name),
          ),
        );

        _polygons.add(
          Polygon(
            polygonId: PolygonId(widget.cityDistricts.name),
            points: polygonPoints,
            strokeWidth: 2,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.15),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityDistricts.name),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: _centerPoint,
            zoom: 13.0,
          ),
          polygons: _polygons,
          markers: markers,
        ),
      ),
    );
  }
}
