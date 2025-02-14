import 'package:flutter/material.dart';

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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),

          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          ListTile(
            title: const Text('Setting'),
            onTap: () {
              Navigator.pushNamed(context, '/SettingsPage');
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          //

          ListTile(
            title: const Text('Cancel'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
