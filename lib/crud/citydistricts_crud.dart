import 'package:prague_ru/constants.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/dto_classes/features/feature.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:collection/collection.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class CityDistrictsCrud {
  static Future<ReqRes<List<CityDistricts>>> getData() async {
    ReqRes<List<CityDistricts>> result = ReqRes.empty();

    try {
      var headers = {
        'Accept': 'application/json; charset=utf-8',
        'X-Access-Token': x_token
      };

      var response = await http.get(
          Uri.https(
              host, '/v2/citydistricts', {'limit': '1000', 'offset': '0'}),
          headers: headers);

      result.status = response.statusCode;

      print(response.statusCode);

      int h = 0;

      if (response.statusCode == 200) {
        dynamic body = (json.decode(response.body) as dynamic);
        //    print(body);
        int h1 = 0;
        List<dynamic> listMakes = body['features'] as List<dynamic>;
        int h2 = 0;
        List<CityDistricts> list = [];

        listMakes.forEach((dynamic map) {
          CityDistricts item_obj = CityDistricts.fromJson(map);
          list.add(item_obj);
        });
        int h3 = 0;
        list.sort((a, b) => a.id.compareTo(b.id));
        result.model = list;
        result.message = 'OK';

        if (result.model!.isEmpty) {
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
