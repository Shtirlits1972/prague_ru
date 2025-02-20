import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:prague_ru/controllers/medical_controller.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/form/setting_form.dart';
import 'package:prague_ru/services/medical_crud.dart';
import 'package:prague_ru/widget/drawer.dart';

class MedicalForm extends StatefulWidget {
  const MedicalForm({Key? key}) : super(key: key);

  @override
  _MedicalFormState createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  final MedicalController medicalGetX = Get.put(MedicalController());

  @override
  Widget build(BuildContext context) {
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
        title: Text('MedicalForm'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (medicalGetX.rxReqRes.value.status == 0) {
          print('hello');
          MedicalCrud.getData().then((value) {
            setState(() {
              medicalGetX.rxReqRes.value = value;
            });
          });
        }
        Widget central = medicalGetX.rxReqRes.value.status == 0
            ? CircularProgressIndicator(
                color: Colors.blue,
              )
            : getCentral(medicalGetX.rxReqRes.value, context);

        return Center(child: central);
      }),
    );
  }

  // -------------------  getCentral  ----------------------------
  Widget getCentral(
      ReqRes<GeoJSONFeatureCollection> reqRes, BuildContext context) {
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
          var properties = reqRes.model!.features[index]!.properties!;

          String name = properties['name'];
          String adress = properties['address']['address_formatted'];
          String district = properties['district'];

          var phone_list = properties['telephone'] as List;

          List<ItemWidget> listPhones = [];

          Column phoneCol = Column();

          if (phone_list.isNotEmpty) {
            String phoneValue = '';
            for (int i = 0; i < phone_list.length; i++) {
              phoneValue += phone_list[i].toString() + '\n';
            }
            listPhones.add(ItemWidget(title: 'telephone', content: phoneValue));

            phoneCol = Column(
              children: listPhones,
            );
          }

          var opening_hours = properties['opening_hours'] as List;

          List<Widget> listHours = [];

          if (opening_hours.isNotEmpty) {
            listHours.add(Text('opening hours'));

            opening_hours.forEach(
              (element) {
                listHours.add(ItemWidget(
                    title: element['day_of_week'].toString(),
                    content:
                        '${element['opens'].toString()} - ${element['closes'].toString()}'));
              },
            );
          }

          Column colHours = Column(
            children: listHours,
          );

          return ExpansionTile(
            controlAffinity: ListTileControlAffinity.trailing,
            childrenPadding: EdgeInsets.all(16),
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
                Navigator.pushNamed(context, '/MedicalMapForm',
                    arguments: reqRes.model!.features[index]!);
                // print(reqRes.model!.features[index]!.properties!);
              },
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            children: [
              ItemWidget(title: 'adress', content: adress),
              phoneCol,
              ItemWidget(title: 'district', content: district),
              colHours
            ],
          );
        },
      );
    }
  }
}
