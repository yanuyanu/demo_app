import 'package:flutter/material.dart';

class FavoriteDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Editor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save), 
            onPressed: () {}),
          SizedBox(
            width: 30,
          ),
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
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: ListView(
            children: <Widget>[
              Container(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: NetworkImage(
                            'https://m.media-amazon.com/images/M/MV5BMTg1NjQwNTI3N15BMl5BanBnXkFtZTcwNDIyNTY1Mw@@._V1_SX300.jpg'),
                      ),ListTile(
                        leading: Icon(Icons.movie),
                        title: Text('Rak haeng Siam'),
                        subtitle: Text('2007'),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Label',
                    ),
                  ),
              ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Priority',
                    ),
                  ),
                ),
                SwitchListTile(
                  title: Text('Viewed'),
                  value: false, 
                onChanged: (bool value){

                }),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Rating',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Modified Date',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
