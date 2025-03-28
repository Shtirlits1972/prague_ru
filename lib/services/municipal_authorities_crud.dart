import 'package:geojson_vi/geojson_vi.dart';
import 'package:http/http.dart' as http;
import 'package:prague_ru/constants.dart';
import 'dart:convert';
import 'dart:async';

import 'package:prague_ru/dto_classes/req_res.dart';

class MunicipalAuthoritiesCrud {
  static Future<ReqRes<GeoJSONFeatureCollection>> getData() async {
    ReqRes<GeoJSONFeatureCollection> result =
        ReqRes<GeoJSONFeatureCollection>.empty();

    try {
      var headers = {
        'Accept': 'application/json; charset=utf-8',
        'X-Access-Token': x_token
      };

      var response = await http.get(Uri.https(host, '/v2/municipalauthorities'),
          headers: headers);

      result.status = response.statusCode;

      int h = 0;

      if (response.statusCode == 200) {
        GeoJSONFeatureCollection collect =
            GeoJSONFeatureCollection.fromJSON(response.body.toString());

        print(collect);

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
