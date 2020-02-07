import 'package:flutter/material.dart';

class FavoriteDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Editor'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () {

          }),
          SizedBox(width: 50,),
        ],
      ),
      body: FavoriteDetailPage(),
    );
  }
}

class FavoriteDetailPage extends StatefulWidget {
  @override
  _FavoriteDetailState createState() => _FavoriteDetailState();
}

class _FavoriteDetailState extends State<FavoriteDetailPage> {
  void processState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
