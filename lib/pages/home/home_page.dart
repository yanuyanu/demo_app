import 'package:demo_app/repository/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';
import 'package:demo_app/common/session_enum.dart';

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

  Future<String> _getToken;

  @override
  void initState(){
    super.initState();
    
    _getToken = MovieRespository().getValue(SessionEnum.TOKEN.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: DrawerPage(),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder<String>(
              future: _getToken,
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
          ],
        ),
      ),
    );
  }
}
