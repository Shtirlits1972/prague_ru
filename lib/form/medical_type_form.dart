import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prague_ru/controllers/medical_controller.dart';
import 'package:prague_ru/dto_classes/medical_type.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/services/medical_crud.dart';

class MedicalTypeForm extends StatefulWidget {
  MedicalTypeForm({Key? key}) : super(key: key);

  static const String route = '/MedicalTypeForm';

  @override
  _MedicalTypeFormState createState() => _MedicalTypeFormState();
}

class _MedicalTypeFormState extends State<MedicalTypeForm> {
  MedicalController medicalController = Get.put(MedicalController());
  ReqRes<Set<String>> medTypeAll = ReqRes<Set<String>>.empty();
  Set<String> medTypeSelected = {};

  @override
  void initState() {
    medTypeAll = medicalController.rxMedicalType.value!;
    medTypeSelected.addAll(medicalController.rxSelected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Medical Type'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: Center(
              child: getCentral(medTypeAll, context),
            ),
          ),
          //================= ALL ==============
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2.0),
                ),
              ),
              child: SwitchListTile(
                title: Text('All'),
                value: medTypeSelected.length == medTypeAll.model!.length,
                onChanged: (value) {
                  if (value) {
                    print(value);
                    int h = 0;
                    setState(() {
                      medTypeSelected.addAll(medTypeAll.model!);
                    });
                  } else {
                    setState(() {
                      medTypeSelected.clear();
                    });
                  }
                },
              ),
            ),
          ),

          //================= ALL ==============
          //=======================   Button   ===================
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                //   color: Theme.of(context).primaryColor, // Фоновый цвет
                border: Border(
                  top: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2.0),
                ),
                //  borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
//==//==//==//=================================================
                            medicalController
                                .setMedicalTypeSelected(medTypeSelected);
                            Navigator.pop(context);
//==//==//==//=================================================
                          });
                        },
                        child: Text('OK'),
                      ),
                    ),
//   ==================   OK   ===================
// ===========   cancel ==============
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //=======================   Button   ===================
        ],
      ),
    );
  }

//  =================   GetCentral   =================================================
  Widget getCentral(ReqRes<Set<String>> reqRes, BuildContext context) {
    print(reqRes);
    var r = 0;

    if (reqRes.model == null || reqRes.model!.isEmpty) {
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
        itemCount: reqRes.model!.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            value: medTypeSelected.contains(reqRes.model!.toList()[index])
                ? true
                : false,
            onChanged: (bool? value) {
              print(value);

              if (value!) {
                setState(() {
                  medTypeSelected.add(reqRes.model!.toList()[index]);
                });
              } else {
                setState(() {
                  medTypeSelected.removeWhere(
                      (item) => item == reqRes.model!.toList()[index]);
                });
              }
            },
            title: Text(reqRes.model!.toList()[index]),
          );
        },
      );
    }
  }
}
