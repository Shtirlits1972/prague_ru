// import 'package:flutter/material.dart';
// import 'package:geojson_vi/geojson_vi.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:ui_web' as ui_web;
// import 'dart:html' as html;
// import 'dart:math';

// class WebMapForm extends StatefulWidget {
//   final GeoJSONFeature feature;
//   final String title;
//   final String address;

//   const WebMapForm({
//     Key? key,
//     required this.feature,
//     required this.title,
//     required this.address,
//   }) : super(key: key);

//   static const String route = '/MapExampleScreen';

//   @override
//   State<WebMapForm> createState() => _WebMapFormState();
// }

// class _WebMapFormState extends State<WebMapForm> {
//   late final String _uniqueCacheKey;

//   @override
//   void initState() {
//     super.initState();
//     _uniqueCacheKey = _generateCacheKey();
//   }

//   String _generateCacheKey() {
//     final random = Random();
//     return '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(100000)}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!kIsWeb) {
//       return const Center(child: Text('Карта доступна только в веб-версии'));
//     }

//     final geometry = widget.feature.geometry!.toMap();
//     final coords = geometry['coordinates'];
//     final String mapHtml = _buildMapHtml(geometry['type'], coords);

//     ui_web.platformViewRegistry.registerViewFactory(
//       'google-map-iframe',
//       (int viewId) => html.IFrameElement()
//         ..style.width = '95%'
//         ..style.height = '95%'
//         ..style.border = 'none'
//         ..srcdoc = mapHtml,
//     );

//     print('key = ${_uniqueCacheKey}');
//     var r = 0;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         title: Text(widget.title),
//       ),
//       body: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: HtmlElementView(
//           key: ValueKey(_uniqueCacheKey),
//           viewType: 'google-map-iframe',
//         ),
//       ),
//     );
//   }

//   String _buildMapHtml(String geometryType, dynamic coords) {
//     final center = _getCenter(geometryType, coords);
//     final polygonJs = geometryType == 'Polygon' ? _createPolygonJs(coords) : '';

//     return '''
//     <!DOCTYPE html>
//     <html>
//       <head>
//         <title>${_escapeHtml(widget.title)}</title>
//         <style>
//           body { margin: 0; padding: 0; }
//           #map { height: 100vh; width: 100%; }
//         </style>
//       </head>
//       <body>
//         <div id="map"></div>
        
//         <script>
//           let map;
//           let infoWindow;
//           let marker;
//           let polygon;
//           const markers = [];

//           function getRandomInt(min, max) {
//             const minCeiled = Math.ceil(min);
//             const maxFloored = Math.floor(max);
//             return Math.floor(Math.random() * (maxFloored - minCeiled) + minCeiled); 
//           }


//           function clearMap() {

//             // Очищаем все маркеры
//             markers.forEach(m => m.map = null);
//             markers.length = 0;
            
//             // Очищаем полигон
//             if (polygon) {
//               polygon.setMap(null);
//               polygon = null;
//             }
            
//             // Очищаем инфоокно
//             if (infoWindow) {
//               infoWindow.close();
//               infoWindow = null;
//             }
            
//             // Очищаем карту
//             if (map) {
//               const mapDiv = document.getElementById('map');
//               mapDiv.innerHTML = '<div id="map"></div>';
//               map = null;
//             }

//           }
          
//           async function initMap() {
//             // Полная очистка перед инициализацией
//                clearMap();
            
//             try {

//               // Загружаем библиотеки
//               const { Map } = await google.maps.importLibrary("maps");
//               const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
//               const { Polygon } = await google.maps.importLibrary("core");

//               var map_id = getRandomInt(0, 100000);

//               console.log('map_id = ' + map_id );
              
              
//               // Создаем новую карту
//               map = new Map(document.getElementById("map"), {
//                 center: { lat: ${center['lat']}, lng: ${center['lng']} },
//                 zoom: 14,
//                 mapId: map_id.toString(),                             
//                 gestureHandling: "greedy"
//               });

//                map.setCenter(new google.maps.LatLng(${center['lat']}, ${center['lng']}));

//               console.dir(map);
              
//               infoWindow = new google.maps.InfoWindow();
              
//               // Создаем маркер
//               marker = new AdvancedMarkerElement({
//                 position: { lat: ${center['lat']}, lng: ${center['lng']} },
//                 map: map,
//                 title: "${_escapeJs(widget.address)}"
//               });
              
//               markers.push(marker);

              
              
//               marker.addListener("gmp-click", () => {
//                 showInfoWindow(
//                   "${_escapeJs(widget.title)}", 
//                   "${_escapeJs(widget.address)}", 
//                   { lat: ${center['lat']}, lng: ${center['lng']} }
//                 );
//               });


//               console.dir($center);
              
//               // Создаем полигон если нужно
//               ${geometryType == 'Polygon' ? polygonJs : ''}
              
//             } catch (error) {
//               console.error('Error initializing map:', error);
//             }
//           }
          
//           ${_getInfoWindowScript()}
          
//           // Инициализация при загрузке
//           window.addEventListener('load', initMap);
          
//          // // //   Переинициализация при возврате из кэша
//           window.addEventListener('pageshow', (event) => {
//             if (event.persisted) initMap()
//           });
//         </script>
        
//         <script async
//           src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBspHZF6ESeSBqxW5EiQVaGbLNiQWMRFT4&callback=initMap&loading=async&libraries=marker,core&_=${_uniqueCacheKey}"
//           defer
//           >
//         </script>
//       </body>
//     </html>
//   ''';
//   }

//   String _createPolygonJs(dynamic coords) {
//     final polygonCoords = (coords[0] as List).map((point) {
//       return '{ lat: ${point[1]}, lng: ${point[0]} }';
//     }).join(', ');

//     return '''
//     polygon = new google.maps.Polygon({
//       paths: [$polygonCoords],
//       strokeColor: "#FF0000",
//       strokeOpacity: 0.8,
//       strokeWeight: 2,
//       fillColor: "#FF0000",
//       fillOpacity: 0.35,
//       map: map
//     });
    
//     // Добавляем центральный маркер для полигона
//     const centerMarker = new AdvancedMarkerElement({
//       position: { 
//         lat: ${_calculatePolygonCenter(coords[0])['lat']}, 
//         lng: ${_calculatePolygonCenter(coords[0])['lng']} 
//       },
//       map: map,
//       title: "${_escapeJs(widget.title)}"
//     });
    
//     markers.push(centerMarker);
    
//     centerMarker.addListener("gmp-click", () => {
//       showInfoWindow(
//         "${_escapeJs(widget.title)}", 
//         "${_escapeJs(widget.address)}", 
//         { 
//           lat: ${_calculatePolygonCenter(coords[0])['lat']}, 
//           lng: ${_calculatePolygonCenter(coords[0])['lng']} 
//         }
//       );
//     });
//     ''';
//   }

//   Map<String, double> _getCenter(String geometryType, dynamic coords) {
//     if (geometryType == 'Point') {
//       return {'lat': coords[1], 'lng': coords[0]};
//     } else if (geometryType == 'Polygon') {
//       return _calculatePolygonCenter(coords[0] as List);
//     }
//     return {'lat': 50.124935, 'lng': 14.457204};
//   }

//   Map<String, double> _calculatePolygonCenter(List<dynamic> polygonCoords) {
//     double latSum = 0;
//     double lngSum = 0;

//     for (final point in polygonCoords) {
//       latSum += point[1];
//       lngSum += point[0];
//     }

//     return {
//       'lat': latSum / polygonCoords.length,
//       'lng': lngSum / polygonCoords.length
//     };
//   }

//   static String _getInfoWindowScript() {
//     return '''
//       function showInfoWindow(title, content, position) {
//         if (!infoWindow) return;
        
//         infoWindow.setContent(
//           '<div style="padding: 10px;">' +
//             '<h3 style="margin: 0 0 5px 0;">' + title + '</h3>' +
//             '<p style="margin: 0;">' + content + '</p>' +
//           '</div>'
//         );
//         infoWindow.setPosition(position);
//         infoWindow.open(map);
//       }
//     ''';
//   }

//   String _escapeHtml(String text) {
//     return text
//         .replaceAll('&', '&amp;')
//         .replaceAll('<', '&lt;')
//         .replaceAll('>', '&gt;')
//         .replaceAll('"', '&quot;')
//         .replaceAll("'", '&#39;');
//   }

//   String _escapeJs(String text) {
//     return text
//         .replaceAll(r'$', r'\$')
//         .replaceAll(r'"', r'\"')
//         .replaceAll(r"'", r"\'")
//         .replaceAll(r'\n', r'\\n')
//         .replaceAll(r'\r', r'\\r');
//   }
// }
