class Movie {
  Movie({
    required this.id,
    required this.adult,
    required this.backdrop_path,
    required this.genre_ids,
    required this.original_title,
    required this.overview,
    required this.popularity,
    required this.poster_path,
    required this.release_date,
    required this.title,
    required this.video,
    required this.vote_average,
    required this.vote_count,
  });

  // Required fields
  int id;
  bool adult;
  String backdrop_path;
  List<dynamic> genre_ids;
  String original_title;
  String overview;
  double popularity;
  String poster_path;
  String release_date;
  String title;
  bool video;
  double vote_average;
  int vote_count;

  Movie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        adult = json['adult'],
        backdrop_path = json['backdrop_path'],
        genre_ids = json['genre_ids'],
        original_title = json['original_title'],
        overview = json['overview'],
        popularity = json['popularity'],
        poster_path = json['poster_path'],
        release_date = json['release_date'],
        title = json['title'],
        video = json['video'],
        vote_average = 1.0 * json['vote_average'],
        vote_count = json['vote_count'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'adult': adult,
        'backdrop_path': backdrop_path,
        'genre_ids': genre_ids,
        'original_title': original_title,
        'overview': overview,
        'popularity': popularity,
        'poster_path': poster_path,
        'release_date': release_date,
        'title': title,
        'video': video,
        'vote_average': vote_average,
        'vote_count': vote_count,
      };
}
