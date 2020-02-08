import 'package:flutter/material.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void processState() {
    setState(() {});
  }

  Future<String> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: DrawerPage(),
      body: Center(
        child: FutureBuilder<String>(
          future: getToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){
            switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        'Token: ${snapshot.data}',
                      );
                    }
                }
          }),
      ),
    );
  }
}
