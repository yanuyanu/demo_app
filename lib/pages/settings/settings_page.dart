import 'package:demo_app/common/session_enum.dart';
import 'package:demo_app/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';
import 'package:demo_app/repository/movie_repository.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Page',
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        drawer: DrawerPage(),
        body: FutureBuilder<String>(
              future: MovieRespository().getValue(SessionEnum.RECOMMENDED.toString()),
              builder: (BuildContext context, AsyncSnapshot<String> recommendedSnapshot){
                bool recommended = false;
                  if(recommendedSnapshot.data == 'true'){
                    recommended = true;
                  }
                switch (recommendedSnapshot.connectionState) {
                      case ConnectionState.waiting:
                        if(recommendedSnapshot.data == null){
                          return Center(child: CircularProgressIndicator());
                        }
                        return showSettings(recommended);
                      default:
                        if (recommendedSnapshot.hasError) {
                          return Text('Error: ${recommendedSnapshot.error}');
                        } else {
                          return showSettings(recommended);
                        }
                    }
              })
    );
  }

  ListView showSettings(bool recommended){
    return ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            SwitchListTile(
                title: Text('Recommended'),
                value: recommended,

                onChanged: (bool value) {
                  setState(() {
                  MovieRespository().setValue(SessionEnum.RECOMMENDED.toString(), value.toString());
                  });
                }),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                MovieRespository().dispose();
                Navigator.of(context).pushReplacement(new PageRouteBuilder(
                      maintainState: true,
                      opaque: true,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Login(),
                      transitionDuration: const Duration(seconds: 2),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      }));
              },
            ),
          ]).toList(),
        );
  }
  
}
