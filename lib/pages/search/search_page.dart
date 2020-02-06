import 'package:flutter/material.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';
import 'package:flutter/rendering.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Page',
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Video'),
        bottom: PreferredSize(
            child: Container(alignment: Alignment.center,
              height: 40,
              //color: Colors.red,
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(onPressed: null, child: Text('asdfs')),
                  SizedBox(width: 100, height: 40, child: TextField(decoration: InputDecoration(filled: true, fillColor: Colors.white),))
            
                ],
              ),
            ),
            preferredSize: const Size.fromHeight(40)),
      ),
      drawer: DrawerPage(),
      body: SearchPageState(),
    );
  }
}

class SearchPageState extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPageState> {
  void processState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
