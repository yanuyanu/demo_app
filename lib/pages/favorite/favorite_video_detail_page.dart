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
          Movie movie = projectSnap.data;
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
                  initialValue: movie.label,
                  decoration: InputDecoration(
                    hoverColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.blue[50],
                    labelText: 'Label',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  initialValue: movie.priority,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.blue[50],
                    labelText: 'Priority',
                  ),
                ),
              ),
              SwitchListTile(
                  title: Text('Viewed'),
                  value: movie.viewed,
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
                    fillColor: Colors.blue[50],
                    labelText: 'Rating',
                  ),
                  initialValue: movie.rating?.toString(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  initialValue: DateTime.fromMillisecondsSinceEpoch(movie.timestamp * 1000).toString(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.blue[50],
                    labelText: 'Timestamp',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
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
  final String label;
  final String year;
  final String imdbID;
  final String type;
  final String poster;
  final String rating;
  final String priority;
  final int timestamp;
  final bool viewed;

  Movie({
    this.title,
    this.year,
    this.imdbID,
    this.type,
    this.poster,
    this.rating,
    this.label,
    this.priority,
    this.timestamp,
    this.viewed,
  }
  );

  factory Movie.fromJson(Map<String, dynamic> json, bool isFromApi) {
    if(isFromApi){
      return Movie(
        title: json['title'],
        year: json['year'],
        imdbID: json['id'],
        type: json['type'],
        poster: json['poster'],
        rating: json['rating']?.toString(),
        label: json['label'],
        priority: json['priority']?.toString(),
        timestamp: json['timestamp'],
        viewed: json['viewed']
      );
    }
      return Movie(
        title: json['Title'],
        year: json['Year'],
        imdbID: json['imdbID'],
        type: json['Type'],
        poster: json['Poster'],
        rating: json['imdbRating'],
        label: null,
        priority: null,
        timestamp: (DateTime.now().millisecondsSinceEpoch/1000).round(),
        viewed: false,
      );
  }
}
