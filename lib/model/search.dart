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
      imdbID: json['imdbID'],
      type: json['Type'],
      poster: json['Poster'],
    );
  }
}