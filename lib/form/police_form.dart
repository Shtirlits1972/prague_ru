import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:prague_ru/controllers/police_controller.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/form/police_map.dart';
import 'package:prague_ru/form/setting_form.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/services/police_crud.dart';
import 'package:prague_ru/widget/drawer.dart';

class PoliceForm extends StatefulWidget {
  const PoliceForm({Key? key}) : super(key: key);

  static const String route = '/PoliceForm';

  @override
  _PoliceFormState createState() => _PoliceFormState();
}

class _PoliceFormState extends State<PoliceForm> {
  final PoliceController policeGetX = Get.put(PoliceController());
  @override
  Widget build(BuildContext context) {
    Widget central = Center(
      child: Text('Ops...'),
    );

    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        title: Text(AppLocale.police_stations.getString(context)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (policeGetX.rxReqRes.value.status == 0) {
          print('hello');
          PoliceCrud.getData().then((value) {
            setState(() {
              policeGetX.rxReqRes.value = value;
            });
          });
        }
        //==//===========//===============//=====================//==============
        if (policeGetX.getPolice.status == 0) {
          PoliceCrud.getData().then((value) {
            policeGetX.setPolice(value);
          });
        }

        central = policeGetX.rxReqRes.value.status == 0
            ? CircularProgressIndicator(
                color: Colors.blue,
              )
            : getCentral(policeGetX.getPolice, context);

        return Center(child: central);
      }),
    );
  }

  // -------------------  getCentral  ----------------------------
  Widget getCentral(
      ReqRes<GeoJSONFeatureCollection?> reqRes, BuildContext context) {
    if (reqRes.model == null && reqRes.model!.features.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No Data'),
            Text(reqRes.message),
          ],
        ),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
        ),
        itemCount: reqRes.model!.features.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  '${index + 1}',
                ),
              ),
            ),
            dense: true,
            title: InkWell(
              onTap: () {
                Navigator.pushNamed(context, PoliceMap.route,
                    arguments: reqRes.model!.features[index]!);
                print(reqRes.model!.features[index]!.properties!);
              },
              child: Text(
                reqRes.model!.features[index]!.properties!['address']
                    ['street_address'],
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            subtitle:
                Text(reqRes.model!.features[index]!.properties!['district']),
          );
        },
      );
    }
  }
}
