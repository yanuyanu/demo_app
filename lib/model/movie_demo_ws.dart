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
  final bool isExistingFavorite;

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
    this.isExistingFavorite,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      "id": imdbID,
      "label": label,
      "priority": int.parse(priority),
      "viewed": viewed,
      "rating": (double.parse(rating)).round(),
      "timestamp": timestamp,
      "title": title,
      "year": year,
      "poster": poster,
    };
    return result;
  }

  factory MovieDemoWs.fromJson(Map<String, dynamic> json, bool isExistingFavorite) {
    
    if (isExistingFavorite) {
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
          viewed: json['viewed'],
          isExistingFavorite: isExistingFavorite,
      );
    }
    return MovieDemoWs(
      title: json['Title'],
      year: json['Year'],
      imdbID: json['imdbID'],
      type: json['Type'],
      poster: json['Poster'],
      rating: json['imdbRating'],
      label: "",
      priority: "0",
      timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).round(),
      viewed: false,
      isExistingFavorite: isExistingFavorite,
    );
  }
}
