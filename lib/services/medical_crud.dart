import 'package:geojson_vi/geojson_vi.dart';
import 'package:prague_ru/constants.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:collection/collection.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MedicalCrud {
  static Future<ReqRes<GeoJSONFeatureCollection>> getData() async {
    ReqRes<GeoJSONFeatureCollection> result =
        ReqRes<GeoJSONFeatureCollection>.empty();

    try {
      var headers = {
        'Accept': 'application/json; charset=utf-8',
        'X-Access-Token': x_token
      };

      var response = await http.get(
          Uri.https(host, '/v2/medicalinstitutions',
              {'limit': '1000', 'offset': '0'}),
          headers: headers);

      result.status = response.statusCode;

      //   print(response.statusCode);

      int h = 0;

      if (response.statusCode == 200) {
        GeoJSONFeatureCollection collect =
            GeoJSONFeatureCollection.fromJSON(response.body.toString());

        print(collect);

        var properties = collect.features[0]!.properties!;

        properties.keys.forEach((key) {
          print('Type = ${properties[key].runtimeType}');
          print('$key = ${properties[key]}');

          if (properties[key].runtimeType == List<dynamic>) {
            List<dynamic> list = properties[key] as List<dynamic>;

            list.forEach((val) {
              print('Type = ${val.runtimeType}');
              print(val);
              print('........................................');
            });
          }
          print(
              '--------------------------------------------------------------------------------');
        });

        result.model = collect;
        result.message = 'OK';

        if (result.model == null) {
          result.message = 'No Data';
        }

        return result;
      } else {
        print(response.statusCode);
        result.message = 'statusCode ${response.statusCode}';
        return result;
      }
    } on Exception catch (exception) {
      print('exception: $exception');
      result.message = 'exception: $exception';
      return result;
    } catch (error) {
      print('error: $error');
      result.message = 'error: $error';
      return result;
    }
  }
}
