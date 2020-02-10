import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:demo_app/pages/menus/drawer_page.dart';
import 'package:demo_app/pages/favorite/favorite_video_detail_page.dart';
import 'package:http/http.dart' as http;

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
  Future<Movie> _resultMovie;

  void _searchMovie(String title, String year) {
    searchMovie(title, year).then((val) => setState(() {
      _resultMovie = searchMovie(title, year);
      print(_resultMovie);
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
            contentPadding: EdgeInsets.only(top: 5, left: 15),
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

  Future<Movie> searchMovie(String title, String year) async {
    var queryParameters = {
      'y': year,
      's': title,
      'apikey': '25867ddb',
    };

    var uri = Uri.http('www.omdbapi.com', '/', queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      Movie result = Movie.fromJson(json.decode(response.body));
      return result;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Widget cardMovie(Search movie){
    return Card(
                  margin:
                      EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: NetworkImage(
                            movie.poster),
                      ),
                      ListTile(
                        leading: Icon(Icons.movie),
                        title: Text(movie.title),
                        subtitle: Text(movie.year),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavoriteDetail()),
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
          if ((projectSnap.connectionState == ConnectionState.none &&
            !projectSnap.hasData) || (projectSnap.hasData && projectSnap.data.response == 'False')) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          return ListView.builder(
        itemCount: projectSnap.data.search.length,
        itemBuilder: (context, index) {
          Search project = projectSnap.data.search[index];
          return cardMovie(project);
        },
      );
        }),
    );
  }
}

class Movie {
  final List<Search> search;
  final String totalResults;
  final String response;

  Movie(this.totalResults, this.response, [this.search]);

  factory Movie.fromJson(dynamic json) {
    if (json['Search'] != null) {
      var tagObjsJson = json['Search'] as List;
      List<Search> _search =
          tagObjsJson.map((tagJson) => Search.fromJson(tagJson)).toList();
      return Movie(
        json['totalResults'],
        json['Response'],
        _search,
      );
    } else {
      return Movie(
        json['totalResults'],
        json['Response'],
      );
    }
  }
}

class Search {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  Search({
    this.title,
    this.year,
    this.imdbID,
    this.type,
    this.poster,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      year: json['Year'],
      title: json['Title'],
      imdbID: json['titleID'],
      type: json['type'],
      poster: json['Poster'],
    );
  }
}
