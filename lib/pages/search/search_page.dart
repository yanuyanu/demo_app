import 'package:flutter/material.dart';
import 'dart:async';
import 'package:demo_app/pages/menus/drawer_page.dart';
import 'package:demo_app/pages/favorite/favorite_video_detail_page.dart';
import 'package:demo_app/model/movie_omdb.dart';
import 'package:demo_app/model/search.dart';
import 'package:demo_app/repository/movie_repository.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Page',
      home: SearchPageState(),
    );
  }
}

class SearchPageState extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPageState> {
  final titleFilterTextField = TextEditingController();
  final yearFilterTextField = TextEditingController();
  Future<MovieOmdb> _resultMovie;

  @override
  void dispose() {
    titleFilterTextField.dispose();
    yearFilterTextField.dispose();
    super.dispose();
  }

  void _searchMovie(String title, String year) {
    MovieRespository().findAllByTitleAndYear(title, year).then((val) => setState(() {
      _resultMovie = MovieRespository().findAllByTitleAndYear(title, year);
    }));
  }

  Expanded _buildFilterTextField(
      int flex, String hintText, TextEditingController textEditingController) {
    return Expanded(
      flex: flex,
      child: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 5, left: 15,),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black26)),
      ),
    );
  }

  Widget cardMovie(Search movie){
    return Card(
      margin:
          EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: <Widget>[
          Image(
            image: NetworkImage(
                movie.poster == 'N/A' ? 'https://www.archute.com/wp-content/themes/fox/images/placeholder.jpg' : movie.poster),
          ),
          ListTile(
            leading: Icon(Icons.movie),
            title: Text(movie.title),
            subtitle: Text(movie.year),
          ),
          ButtonBar(
            children: <Widget>[
              FloatingActionButton(
                heroTag: movie.imdbID,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteDetail(imdbID: movie.imdbID,)),
                  );
                },
              ),
            ],
          )
        ],
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: Text('Search Movie'),
          bottom: PreferredSize(
              child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 15, bottom: 10, top: 10),
                height: 65,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      _buildFilterTextField(3, 'Title', titleFilterTextField),
                      SizedBox(
                        width: 5,
                      ),
                      _buildFilterTextField(1, 'YYYY', yearFilterTextField),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              _searchMovie(titleFilterTextField.text,
                                  yearFilterTextField.text);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              preferredSize: const Size.fromHeight(40)),
        ),
      ),
      drawer: DrawerPage(),
      body: FutureBuilder(
        future: _resultMovie,
        builder: (context, projectSnap) {
          if(projectSnap.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator());
          }
          if ((projectSnap.connectionState == ConnectionState.none &&
            !projectSnap.hasData) || (projectSnap.hasData && projectSnap.data.response == 'False')) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container(
              child: Center(
                child: Text('no data found'),
              ),
            );
          }
          return ListView.builder(
        itemCount: projectSnap.data.search.length,
        itemBuilder: (context, index) {
          Search searchList = projectSnap.data.search[index];
          return cardMovie(searchList);
        },
      );
        }),
    );
  }
}
