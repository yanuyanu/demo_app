class MovieDemoWs {
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

  MovieDemoWs({
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

  factory MovieDemoWs.fromJson(Map<String, dynamic> json, bool isFromApi) {
    if(isFromApi){
      return MovieDemoWs(
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
      return MovieDemoWs(
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