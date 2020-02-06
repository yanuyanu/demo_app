import 'package:flutter/material.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Page',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Video'),
      ),
      drawer: DrawerPage(),
    );
  }
}