import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteDetail extends StatelessWidget {
  final String imdbID;

  FavoriteDetail({Key key, @required this.imdbID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FavoriteDetailPage(
        imdbID: imdbID,
      ),
    );
  }
}

class FavoriteDetailPage extends StatefulWidget {
  final String imdbID;

  FavoriteDetailPage({Key key, @required this.imdbID}) : super(key: key);

  @override
  _FavoriteDetailState createState() => _FavoriteDetailState();
}

class _FavoriteDetailState extends State<FavoriteDetailPage> {

  Future<Movie> _resultMovieDetail;

  void processState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _resultMovieDetail = searchMovieFromApiById(widget.imdbID);
  }

  resultMovieDetail(Movie movie){
    return Center(
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
                            movie.poster),
                      ),
                      ListTile(
                        leading: Icon(Icons.movie),
                        title: Text(movie.title),
                        subtitle: Text(movie.year),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    hoverColor: Colors.black,
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
                child: TextFormField(
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
                  onChanged: (bool value) {}),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'Rating',
                  ),
                  initialValue: movie.rating?.toString(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
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
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Editor'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () {}),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _resultMovieDetail,
        builder: (context, projectSnap) {
          if(projectSnap.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator()
              );
          }
          if ((projectSnap.connectionState == ConnectionState.none &&
            !projectSnap.hasData)) {
            return Container();
          }
          Movie movieDetail = projectSnap.data;
          return resultMovieDetail(movieDetail);
        }),
    );
  }
}

  Future<Movie> searchMovieFromApiById(String imdbID) async {

    var uriApi = Uri.https('demo-video-ws-chfmsoli4q-ew.a.run.app', '/video-ws/videos/$imdbID');

    final response = await http.get(uriApi, headers: {
      'token':'userTest',
    });

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      Movie result = Movie.fromJson(json.decode(response.body), true);
      return result;
    } else {

    var queryParameters = {
      'i': imdbID,
      'apikey': '25867ddb',
    };

    var uriOmdb = Uri.http('www.omdbapi.com', '/', queryParameters);

    final response = await http.get(uriOmdb);
    if (response.statusCode == 200) {
      Movie result = Movie.fromJson(json.decode(response.body), false);
      return result;
    }
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;
  final String rating;
  final List<Rating> ratings;

  Movie(
    this.title,
    this.year,
    this.imdbID,
    this.type,
    this.poster,
    this.rating,
    [this.ratings]
  );

  factory Movie.fromJson(Map<String, dynamic> json, bool isFromApi) {
    if(isFromApi){
      return Movie(
        json['title'],
        json['year'],
        json['id'],
        json['type'],
        json['poster'],
        json['rating'].toString(),
      );
    }
    if (json['Ratings'] != null) {
      var tagObjsJson = json['Ratings'] as List;
      List<Rating> _ratings =
          tagObjsJson.map((tagJson) => Rating.fromJson(tagJson)).toList();
      return Movie(
        json['Title'],
        json['Year'],
        json['imdbID'],
        json['Type'],
        json['Poster'],
        _ratings[0].value,
        _ratings
      );
    }else{
      return Movie(
        json['Title'],
        json['Year'],
        json['imdbID'],
        json['Type'],
        json['Poster'],
        null,
      );
    }
  }
}

class Rating {
  final String source;
  final String value;
  Rating({this.source, this.value});

  factory Rating.fromJson(Map<String, dynamic> json){
    return Rating(
      source: json['Source'],
      value: json['Value'],
    );
  }
}
