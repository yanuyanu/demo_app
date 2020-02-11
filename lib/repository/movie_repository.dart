import 'package:demo_app/model/movie_omdb.dart';
import 'package:demo_app/model/movie_demo_ws.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MovieRespository {

  Future<String> getValue(String key) async{
    await Future.delayed(Duration(milliseconds: 200));//for debug mode only
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  Future<bool> setValue(String key,String value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  Future<MovieOmdb> findAllByTitleAndYear(String title, String year) async {
    var queryParameters = {
      'y': year,
      's': title,
      'apikey': '25867ddb',
    };

    var uri = Uri.http('www.omdbapi.com', '/', queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      MovieOmdb result = MovieOmdb.fromJson(json.decode(response.body));
      return result;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<MovieDemoWs> findById(String imdbID, String token) async {

    var uriApi = Uri.https('demo-video-ws-chfmsoli4q-ew.a.run.app', '/video-ws/videos/$imdbID');

    final response = await http.get(uriApi, headers: {
      'token': token,
    });

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      MovieDemoWs result = MovieDemoWs.fromJson(json.decode(response.body), true);
      return result;
    } else {

    var queryParameters = {
      'i': imdbID,
      'apikey': '25867ddb',
    };

    var uriOmdb = Uri.http('www.omdbapi.com', '/', queryParameters);

    final response = await http.get(uriOmdb);
    if (response.statusCode == 200) {
      MovieDemoWs result = MovieDemoWs.fromJson(json.decode(response.body), false);
      return result;
    }
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}