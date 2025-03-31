import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;
import 'dart:math';

class WebMapForm extends StatefulWidget {
  final GeoJSONFeature feature;
  final String title;
  final String address;

  const WebMapForm({
    Key? key,
    required this.feature,
    required this.title,
    required this.address,
  }) : super(key: key);

  static const String route = '/MapExampleScreen';

  @override
  State<WebMapForm> createState() => _WebMapFormState();
}

class _WebMapFormState extends State<WebMapForm> {
  late final String _uniqueCacheKey;

  @override
  void initState() {
    super.initState();
    // Генерируем уникальный ключ для предотвращения кеширования
    _uniqueCacheKey = _generateCacheKey();
  }

  String _generateCacheKey() {
    final random = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(100000)}';
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(child: Text('Карта доступна только в веб-версии'));
    }

    final geometry = widget.feature.geometry!.toMap();
    final coords = geometry['coordinates'];
    final String mapHtml = _buildMapHtml(geometry['type'], coords);

    ui_web.platformViewRegistry.registerViewFactory(
      'google-map-iframe',
      (int viewId) => html.IFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..style.border = 'none'
        ..srcdoc = mapHtml,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: HtmlElementView(viewType: 'google-map-iframe'),
      ),
    );
  }

  String _buildMapHtml(String geometryType, dynamic coords) {
    final center = _getCenter(geometryType, coords);
    final markersJs = geometryType == 'Point'
        ? _createMarkerJs(center['lat']!, center['lng']!)
        : '';
    final polygonJs = geometryType == 'Polygon' ? _createPolygonJs(coords) : '';

    return '''
    <!DOCTYPE html>
    <html>
      <head>
        <title>${_escapeHtml(widget.title)}</title>
        <style>
          body { margin: 0; padding: 0; }
          #map { height: 100vh; width: 100%; }
        </style>
      </head>
      <body>
        <div id="map"></div>
        
        <script>
          let map;
          let infoWindow;
          
          async function initMap() {
            // Load required libraries
            const { Map } = await google.maps.importLibrary("maps");
            
            map = new Map(document.getElementById("map"), {
              center: { lat: ${center['lat']}, lng: ${center['lng']} },
              zoom: 14,
              gestureHandling: "greedy",
              mapId: "MAP_ID_${_uniqueCacheKey}",
            });
            
            infoWindow = new google.maps.InfoWindow();
            
            $markersJs
            $polygonJs
          }
          
          ${_getInfoWindowScript()}
          
          window.addEventListener('pageshow', function(event) {
            if (event.persisted) {
              window.location.reload();
            }
          });
        </script>
        
        <script async
          src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBspHZF6ESeSBqxW5EiQVaGbLNiQWMRFT4&callback=initMap&loading=async&_=${_uniqueCacheKey}&libraries=marker">
        </script>
      </body>
    </html>
  ''';
  }

//===============================================================================
  String _createMarkerJs(double lat, double lng) {
    return '''
    (async () => {
      // Request needed libraries
      const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
      
      // Create advanced marker
      const marker = new AdvancedMarkerElement({
        position: { lat: $lat, lng: $lng },
        map: map,
        title: "${_escapeJs(widget.title)}",
      });
      
      // Add click listener
      marker.addListener("click", () => {
        showInfoWindow(
          "${_escapeJs(widget.title)}", 
          "${_escapeJs(widget.address)}", 
          { lat: $lat, lng: $lng }
        );
      });
    })();
  ''';
  }

  String _createPolygonJs(dynamic coords) {
    // Для полигона coordinates содержит массив массивов
    final polygonCoords = (coords[0] as List).map((point) {
      return '{ lat: ${point[1]}, lng: ${point[0]} }';
    }).join(', ');

    return '''
    new google.maps.Polygon({
      paths: [$polygonCoords],
      strokeColor: "#FF0000",
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: "#FF0000",
      fillOpacity: 0.35,
      map: map
    });
    
    // Центральный маркер
    ${_createMarkerJs(_calculatePolygonCenter(coords[0])['lat']!, _calculatePolygonCenter(coords[0])['lng']!)}
  ''';
  }

  Map<String, double> _getCenter(String geometryType, dynamic coords) {
    if (geometryType == 'Point') {
      return {'lat': coords[1], 'lng': coords[0]};
    } else if (geometryType == 'Polygon') {
      return _calculatePolygonCenter(coords[0] as List);
    }
    return {'lat': 50.124935, 'lng': 14.457204};
  }

  Map<String, double> _calculatePolygonCenter(List<dynamic> polygonCoords) {
    double latSum = 0;
    double lngSum = 0;

    for (final point in polygonCoords) {
      latSum += point[1];
      lngSum += point[0];
    }

    return {
      'lat': latSum / polygonCoords.length,
      'lng': lngSum / polygonCoords.length
    };
  }

  static String _getInfoWindowScript() {
    return '''
      function showInfoWindow(title, content, position) {
        infoWindow.setContent(
          '<div style="padding: 10px;">' +
            '<h3 style="margin: 0 0 5px 0;">' + title + '</h3>' +
            '<p style="margin: 0;">' + content + '</p>' +
          '</div>'
        );
        infoWindow.setPosition(position);
        infoWindow.open(map);
      }
    ''';
  }

  // Добавьте эти вспомогательные методы для экранирования
  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  String _escapeJs(String text) {
    return text
        .replaceAll(r'$', r'\$')
        .replaceAll(r'"', r'\"')
        .replaceAll(r"'", r"\'")
        .replaceAll(r'\n', r'\\n')
        .replaceAll(r'\r', r'\\r');
  }
}
