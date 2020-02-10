import 'package:flutter/material.dart';
import 'package:demo_app/pages/search/search_page.dart';
import 'package:demo_app/pages/favorite/favorite_video_list.dart';
import 'package:demo_app/pages/settings/settings_page.dart';
import 'package:demo_app/pages/dashboard/dashboard_page.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              _buildOnTapPage(context, Dashboard());
            },
          ),
          ListTile(
            title: Text('Search'),
            leading: Icon(Icons.search),
            onTap: () {
              _buildOnTapPage(context, SearchPage());
            },
          ),
          ListTile(
            title: Text('Favorite'),
            leading: Icon(Icons.favorite),
            onTap: () {
              _buildOnTapPage(context, FavoriteVideoList());
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              _buildOnTapPage(context, Settings());
            },
          ),
        ],
      ),
    );
  }

  void _buildOnTapPage(BuildContext context, Object object){
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, animation, secondaryAnimation) => object,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        }));
  }
}
