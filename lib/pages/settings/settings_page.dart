import 'package:flutter/material.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Page',
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        drawer: DrawerPage(),
        body: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            SwitchListTile(
                title: Text('Recommended'),
                value: true,
                onChanged: (bool value) {}),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                
              },
            ),
          ]).toList(),
        ));
  }
}
