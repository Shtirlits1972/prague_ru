import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

class WebGoogleMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String address;

  const WebGoogleMap({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(child: Text('Карта доступна только в веб-версии'));
    }

    ui_web.platformViewRegistry.registerViewFactory(
      'google-map-iframe',
      (int viewId) {
        final iframe = html.IFrameElement()
          ..width = '100%'
          ..height = '100%'
          ..style.border = 'none'
          ..srcdoc = _buildMapHtml();

        return iframe;
      },
    );

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: HtmlElementView(viewType: 'google-map-iframe'),
    );
  }

  String _buildMapHtml() {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <title>Google Map with Marker</title>
          <style>
            body { margin: 0; padding: 0; }
            #map-container { height: 100vh; width: 100%; }
            .custom-marker { 
              background-color: #4CAF50;
              width: 24px;
              height: 24px;
              border-radius: 50%;
              border: 2px solid white;
              box-shadow: 0 2px 5px rgba(0,0,0,0.3);
              display: flex;
              justify-content: center;
              align-items: center;
              color: white;
              font-weight: bold;
            }
          </style>
        </head>
        <body>
          <div id="map-container">
            <gmp-map
              center="$latitude,$longitude"
              zoom="15"
              map-id="DEMO_MAP_ID"
              style="height: 100%; width: 100%"
            >
              <gmp-advanced-marker
                position="$latitude,$longitude"
                title="$title"
                gmp-icon="data:image/svg+xml;charset=UTF-8,${Uri.encodeComponent('''
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="10" fill="#4CAF50"/>
                    <text x="12" y="16" text-anchor="middle" fill="white" font-size="12">!</text>
                  </svg>
                ''')}"
              ></gmp-advanced-marker>
            </gmp-map>
          </div>

          <script async
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBspHZF6ESeSBqxW5EiQVaGbLNiQWMRFT4&libraries=maps,marker&v=beta&callback=initMap">
          </script>

          <script>
            function initMap() {
              // Получаем элемент маркера после загрузки карты
              const marker = document.querySelector('gmp-advanced-marker');
              
              // Обработчик клика
              marker.addEventListener('click', () => {
                console.log('Маркер кликнут:', '$title');
                alert('$title\\n$address');
              });
              
              // Кастомное поведение при наведении
              marker.addEventListener('mouseover', () => {
                marker.style.transform = 'scale(1.2)';
              });
              
              marker.addEventListener('mouseout', () => {
                marker.style.transform = 'scale(1)';
              });
            }
          </script>
        </body>
      </html>
    ''';
  }
}
