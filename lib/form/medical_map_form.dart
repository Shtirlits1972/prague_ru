import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MedicalMapForm extends StatelessWidget {
  MedicalMapForm({Key? key, required this.feature}) : super(key: key);

  GeoJSONFeature feature;

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;
    final Set<Marker> markers = {};
    // LatLng? point = null;
    Map<String, dynamic> geometry = feature.geometry!.toMap();

    List<double> lstDouble = geometry['coordinates'] as List<double>;

    LatLng _centerPoint = LatLng(50.124935, 14.457204); // Прага

    if (geometry['type'] == 'Point') {
      _centerPoint = LatLng(lstDouble[1], lstDouble[0]);
    }

    markers.add(
      Marker(
        markerId: MarkerId(feature.properties!['id']),
        position: _centerPoint,
        infoWindow:
            InfoWindow(title: feature.properties!['address']['street_address']),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(feature.properties!['name']),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _centerPoint,
          zoom: 13.0,
        ),
        //   polygons: _polygons,
        markers: markers,
      ),
    );
  }
}
