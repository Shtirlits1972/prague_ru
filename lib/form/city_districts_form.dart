import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:prague_ru/controllers/city_district_controller.dart';
import 'package:prague_ru/crud/citydistricts_crud.dart';
import 'package:prague_ru/dto_classes/citydistricts.dart';
import 'package:prague_ru/dto_classes/req_res.dart';
import 'package:prague_ru/localization/localization.dart';
import 'package:prague_ru/widget/drawer.dart';

class CityDistrictsForm extends StatelessWidget {
  const CityDistrictsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CityDistrictsController citydistrictsGetX =
        Get.put(CityDistrictsController());

    return Scaffold(
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
        title: Text(AppLocale.praga_district.getString(context)),

        //   Obx(() => Text(
        //       'Message: ${citydistrictsGetX.rxReqRes.value.message} Status: ${citydistrictsGetX.rxReqRes.value.status}')),
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: Obx(() {
        //   final reqRes = citydistrictsGetX.rxReqRes.value;

        if (citydistrictsGetX.rxReqRes.value.status == 0) {
          // Загрузка данных при первом открытии формы
          CityDistrictsCrud.getData().then((value) {
            citydistrictsGetX.setCityDistricts(value);
          });

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else {
          return getCentral(citydistrictsGetX.rxReqRes.value, context);
        }
      }),
    );
  }

  Widget getCentral(ReqRes<List<CityDistricts>> reqRes, BuildContext context) {
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
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/CityDistrictMapForm',
                arguments: reqRes.model![index],
              );
            },
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '${reqRes.model![index].id}',
                  ),
                ),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                '${reqRes.model![index].name}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:prague_ru/controllers/city_district_controller.dart';
// import 'package:prague_ru/crud/citydistricts_crud.dart';
// import 'package:prague_ru/dto_classes/citydistricts.dart';
// import 'package:prague_ru/dto_classes/req_res.dart';
// import 'package:prague_ru/localization/localization.dart';
// import 'package:prague_ru/widget/drawer.dart';

// class CityDistrictsForm extends StatefulWidget {
//   const CityDistrictsForm({Key? key}) : super(key: key);

//   @override
//   _CityDistrictsFormState createState() => _CityDistrictsFormState();
// }

// class _CityDistrictsFormState extends State<CityDistrictsForm> {
//   final CityDistrictsController citydistrictsGetX =
//       Get.put(CityDistrictsController());
//   ReqRes<List<CityDistricts>> reqRes = ReqRes.empty();
//   @override
//   Widget build(BuildContext context) {
//     Widget central = (reqRes.status == 0)
//         ? CircularProgressIndicator(
//             color: Colors.blue,
//           )
//         : Center(
//             child: getCentral(reqRes),
//           );

//     if (reqRes.status == 0) {
//       CityDistrictsCrud.getData().then(
//         (value) {
//           //  print(value);
//           reqRes = value;

//           setState(() {
//             central = getCentral(reqRes);
//             citydistrictsGetX.update(reqRes.model);
//             print('GetX: ${citydistrictsGetX.reqRes.value.message}');
//           });
//         },
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         leading: Builder(
//           builder: (context) {
//             return IconButton(
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//               icon: Icon(Icons.menu_rounded),
//             );
//           },
//         ),
//         title: Obx(() => Text(
//             'Message: ${citydistrictsGetX.reqRes.value.message} Status: ${citydistrictsGetX.reqRes.value.status}')),

//         //   Text(AppLocale.praga_district.getString(context)),
//         centerTitle: true,
//       ),
//       drawer: DrawerMenu(),
//       body: Center(child: central),
//     );
//   }

//   Widget getCentral(ReqRes<List<CityDistricts>> reqRes) {
//     Widget central = Text('No Data');

//     if (reqRes.model!.isEmpty) {
//       if (reqRes.status == 200) {
//         central = Text('No Data');
//       } else {
//         central = Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('No Data'),
//             Text(reqRes.message),
//           ],
//         );
//       }
//     } else {
//       central = ListView.separated(
//         separatorBuilder: (context, index) => const Divider(
//           //color: Colors.black,
//           thickness: 1,
//         ),
//         itemCount: reqRes.model!.length,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               //-----------------------------------
//               Navigator.pushNamed(context, '/CityDistrictMapForm',
//                   arguments: reqRes.model![index]);
//             },
//             child: ListTile(
//               leading: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Theme.of(context).primaryColor,
//                   child: Text(
//                     '${reqRes.model![index].id}',
//                   ),
//                 ),
//               ),
//               contentPadding: EdgeInsets.zero,
//               dense: true,
//               title: Text(
//                 '${reqRes.model![index].name}',
//                 style: TextStyle(
//                   fontSize: 20,
//                 ),
//               ),
//               // trailing: IconButton(
//               //   color: Theme.of(context).primaryColor,
//               //   icon: Icon(Icons.arrow_circle_right_outlined),
//               //   onPressed: () {
//               //     print('hello');
//               //   },
//               // ),

//               // ElevatedButton(
//               //   onPressed: () {},
//               //   child: Text(
//               //     AppLocale.map.getString(context),
//               //   ),
//               // ),
//             ),
//           );
//         },
//       );
//     }
//     return central;
//   }
// }
