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
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Video'),
        bottom: PreferredSize(
            child: Container(
              padding:
                  EdgeInsets.only(left: 25, right: 15, bottom: 10, top: 10),
              height: 65,
              child: Center(
                child: Row(
                  children: <Widget>[
                    _buildFilterTextField(3, 'Title'),
                    SizedBox(
                      width: 5,
                    ),
                    _buildFilterTextField(1, 'YYYY'),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: IconButton(
                          icon: Icon(Icons.search), onPressed: () {}),
                    ),
                  ],
                ),
              ),
            ),
            preferredSize: const Size.fromHeight(40)),
      ),
      drawer: DrawerPage(),
      body: SearchPageState(),
    );
  }

  Expanded _buildFilterTextField(int flex, String hintText) {
    return Expanded(
        flex: flex,
        child: TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 5, left: 15),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black26)),
          onChanged: (value) {},
        ));
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