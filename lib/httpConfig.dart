import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdb_q/models/genre.dart';

const String TMDB_BASE_URL = 'https://api.themoviedb.org/3';
const String TMDB_API_KEY = 'e47781bc43a8daae5784be78c8a00306';

Future<List<Genre>?> fetchGenres() async {
  String url =
      TMDB_BASE_URL + '/genre/movie/list?language=en&api_key=' + TMDB_API_KEY;
  print('httpConfig >> fetchGenres url:$url***');
  final response = await http.get(Uri.parse(url));
  print('httpConfig >> fetchGenres statusCode:${response.statusCode}***');
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = json.decode(response.body);
    print('httpConfig >> fetchGenres responseBody:$responseBody***');
    List<dynamic> list = responseBody['genres'];
    print('httpConfig >> fetchGenres listSize:${list.length}***');
    List<Genre> genres = [];
    for (int i = 0; i < list.length; i += 1) {
      Genre genre = Genre.fromJson(list[i]);
      genres.add(genre);
    }
    return genres;
  }
  return null;
}
