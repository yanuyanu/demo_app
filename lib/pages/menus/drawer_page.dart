import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget{
  @override Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menus',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Dashboard'),
              leading: Icon(Icons.dashboard),
            ),
            ListTile(
              title: Text('Search'),
              leading: Icon(Icons.search),
            ),
            ListTile(
              title: Text('Favorite'),
              leading: Icon(Icons.favorite),
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
            ),
          ],
        ),
      );
  }
}