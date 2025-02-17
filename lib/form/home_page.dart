import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:prague_ru/crud/geo.dart';
import 'package:prague_ru/dto_classes/geo_result.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/widget/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  GeoResult geoResult = GeoResult.empty();
  // Маркер для отображения точки
  final Set<Marker> markers = {};
  LatLng? point = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu_rounded),
            );
          },
        ),
        title: Text(AppLocale.home.getString(context)),
        // title: Obx(() => Text('home_title'.tr)),
        centerTitle: true,
      ),
      drawer: DrawerMenu(),
      body: geoResult.message.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Center(
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(
                    () {
                      mapController = controller;
                    },
                  );
                },
                initialCameraPosition: CameraPosition(
                  target: point!, // Центр карты на точке
                  zoom: 16.0, // Уровень масштабирования
                ),
                markers: markers, // Добавляем маркеры
              ),
            ),
      // : Center(
      //     child: Text(geoResult.message),
      //   ),
    );
  }

  @override
  void initState() {
    Geo.getCoordinates().then(
      (value) {
        geoResult = value;
        //  if (value.success) {
        point = LatLng(value.position!.latitude, value.position!.longitude);
        markers.add(
          Marker(
            markerId: MarkerId('point'),
            position: point!,
            infoWindow: InfoWindow(title: 'Точка на карте'),
          ),
        );
        int h = 0;
        setState(() {});
        // } else {
        //   int h2 = 0;
        //   setState(() {});
        // }
      },
    );
    super.initState();
  }
}
