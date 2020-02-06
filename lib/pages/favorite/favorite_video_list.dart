import 'package:flutter/material.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';

class FavoriteVideoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Page',
      home: FavoriteVideoListPage(),
    );
  }
}

class FavoriteVideoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Video'),
      ),
      drawer: DrawerPage(),
    );
  }
}