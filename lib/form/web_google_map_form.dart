import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geojson_vi/geojson_vi.dart';

class WebMapForm extends StatefulWidget {
  final GeoJSONFeature feature;
  final String title;
  final String address;

  static const String route = '/WebMapForm';

  const WebMapForm({
    Key? key,
    required this.feature,
    required this.title,
    required this.address,
  }) : super(key: key);

  @override
  State<WebMapForm> createState() => _WebMapFormState();
}

class _WebMapFormState extends State<WebMapForm> {
  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};
  final Map<PolygonId, Polygon> _polygons = {};
  LatLng? _center;

  @override
  void initState() {
    super.initState();
    _initMapData();
  }

  void _initMapData() {
    final geometry = widget.feature.geometry!.toMap();
    final coords = geometry['coordinates'];
    _center = _getCenter(geometry['type'], coords);

    _loadMarkers();
    _loadPolygons();
  }

  void _loadMarkers() {
    if (_center == null) return;

    final marker = Marker(
      markerId: MarkerId(widget.title),
      position: _center!,
      infoWindow: InfoWindow(
        title: widget.title,
        snippet: widget.address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    setState(() {
      _markers[widget.title] = marker;
    });
  }

  void _loadPolygons() {
    final geometry = widget.feature.geometry!.toMap();
    if (geometry['type'] != 'Polygon') return;

    final coords = geometry['coordinates'][0]; // Берем первый контур полигона
    final polygonId = PolygonId(widget.title);

    final polygon = Polygon(
      polygonId: polygonId,
      points:
          coords.map<LatLng>((point) => LatLng(point[1], point[0])).toList(),
      strokeWidth: 2,
      strokeColor: Colors.red,
      fillColor: Colors.red.withOpacity(0.15),
    );

    setState(() {
      _polygons[polygonId] = polygon;
    });
  }

  LatLng _getCenter(String geometryType, dynamic coords) {
    if (geometryType == 'Point') {
      return LatLng(coords[1], coords[0]);
    } else if (geometryType == 'Polygon') {
      final List<dynamic> polygonCoords = coords[0]; // Внешний контур полигона
      double latSum = 0;
      double lngSum = 0;

      for (final point in polygonCoords) {
        latSum += point[1];
        lngSum += point[0];
      }

      return LatLng(
        latSum / polygonCoords.length,
        lngSum / polygonCoords.length,
      );
    }

    return const LatLng(50.124935, 14.457204); // По умолчанию
  }

  @override
  Widget build(BuildContext context) {
    if (_center == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: _center!,
          zoom: 14.0,
        ),
        markers: _markers.values.toSet(),
        polygons: _polygons.values.toSet(),
      ),
    );
  }
}
