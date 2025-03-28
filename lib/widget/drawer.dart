import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:prague_ru/form/municipal_authority_form.dart';
import 'package:prague_ru/form/police_form.dart';
import 'package:prague_ru/localization/localization.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(AppLocale.menu.getString(context)),
          ),

          ListTile(
            title: Text(AppLocale.praga_district.getString(context)),
            onTap: () {
              Navigator.pushNamed(context, '/CityDistrictsForm');
            },
          ),

          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          ListTile(
            title: Text(AppLocale.municipai_authority.getString(context)),
            onTap: () {
              Navigator.pushNamed(context, MunicipalAuthorityForm.route);
            },
          ),

          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
//
          //MedicalForm
          ListTile(
            title: Text(AppLocale.medical_institurions.getString(context)),
            onTap: () {
              Navigator.pushNamed(context, '/MedicalForm');
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          //  PoliceForm
          ListTile(
            title: Text(AppLocale.police_stations.getString(context)),
            onTap: () {
              Navigator.pushNamed(context, PoliceForm.route);
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          ListTile(
            title: Text(AppLocale.setting.getString(context)),
            onTap: () {
              Navigator.pushNamed(context, '/SettingsPage');
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          ListTile(
            title: Text(AppLocale.cancel.getString(context)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
