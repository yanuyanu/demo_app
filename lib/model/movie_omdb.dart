import 'package:demo_app/model/search.dart';

class MovieOmdb {
  final List<Search> search;
  final String totalResults;
  final String response;

  MovieOmdb(this.totalResults, this.response, [this.search]);

  factory MovieOmdb.fromJson(dynamic json) {
    if (json['Search'] != null) {
      var tagObjsJson = json['Search'] as List;
      List<Search> _search =
          tagObjsJson.map((tagJson) => Search.fromJson(tagJson)).toList();
      return MovieOmdb(
        json['totalResults'],
        json['Response'],
        _search,
      );
    } else {
      return MovieOmdb(
        json['totalResults'],
        json['Response'],
      );
    }
  }
}