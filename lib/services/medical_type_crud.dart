import 'package:geojson_vi/geojson_vi.dart';
import 'package:prague_ru/constants.dart';
import 'package:prague_ru/dto_classes/medical_type.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:collection/collection.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MedicalTypeCrud {
  /*
  static Future<ReqRes<Set<String>>> getData() async {
    ReqRes<Set<String>> result = ReqRes<Set<String>>.empty();

    try {
      var headers = {
        'Accept': 'application/json; charset=utf-8',
        'X-Access-Token': x_token
      };

      var response = await http.get(
          Uri.https(host, '/v2/medicalinstitutions/types'),
          headers: headers);

      result.status = response.statusCode;

      //   print(response.statusCode);

      int h = 0;

      if (response.statusCode == 200) {
        MedicalType model = MedicalType.fromJson(json.decode(response.body));

        Set<String> medTypes = {};

        print(model);

        model.health_care.forEach((val) {
          medTypes.add(val);
        });

        model.pharmacies.forEach((val) {
          medTypes.add(val);
        });

        result.model = medTypes;
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
  */
}
