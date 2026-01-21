class Movie {
  final int id;
  final String title;
  final String overview;
  final String overviewEn;
  final String posterPath;
  final double rating;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.overviewEn,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
  });

  
  String get displayOverview {
    if (overview.isNotEmpty) return overview;
    if (overviewEn.isNotEmpty) return overviewEn;
    return 'Overview belum tersedia';
  }

  
  factory Movie.fromJson(
    Map<String, dynamic> json, {
    required Map<String, dynamic> enJson,
  }) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      overviewEn: enJson['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
    );
  }

  
  factory Movie.fromSearchJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      overviewEn: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
    );
  }
}
