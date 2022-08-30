import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:tmdb_q/fileUtilities.dart';
import 'package:tmdb_q/models/movie.dart';

const String DATABASE_NAME = 'tmdb_local';
const String MOVIES_POPULAR = 'moviesPopular';
const String MOVIE_GENRES = 'movieGenres';

Future<CollectionBox> getPopularMoviesBox() async {
  await WidgetsFlutterBinding.ensureInitialized();
  Directory? directory = await getCacheDir();
  Hive.init(directory.path);
  String path = '${directory?.path}/tmdb_collection';
  print('Boxes >> getPopularMoviesBox path:$path***');

  final boxCollection = await BoxCollection.open(
      DATABASE_NAME, {MOVIES_POPULAR, MOVIE_GENRES},
      path: path);
  return boxCollection.openBox<Map>(MOVIES_POPULAR);
}

void savePopularMovie(Movie movie) async {
  CollectionBox popularMoviesBox = await getPopularMoviesBox();
  print('Boxes >> savePopularMovie movie:${movie.title}***');
  await popularMoviesBox.put('${movie.id}', movie.toJson());
}

void savePopularMovies(List<Movie> movies) async {
  CollectionBox popularMoviesBox = await getPopularMoviesBox();
  for (Movie movie in movies) {
    print('Boxes >> savePopularMovies movie:${movie.title}***');
    await popularMoviesBox.put('${movie.id}', movie.toJson());
  }
}

Future<Movie> getPopularMovie(int id) async {
  CollectionBox popularMoviesBox = await getPopularMoviesBox();
  print('Boxes >> getPopularMovie id:$id***');
  Movie movie = await popularMoviesBox.get('$id');
  print('Boxes >> getPopularMovie movie:${movie.title}***');
  return movie;
}

Future<Map<String, dynamic>> getPopularMovies() async {
  print('Boxes >> getPopularMovies');
  CollectionBox popularMoviesBox = await getPopularMoviesBox();
  return popularMoviesBox.getAllValues();
}

void deletePopularMovie(int id) async {
  CollectionBox popularMoviesBox = await getPopularMoviesBox();
  print('Boxes >> deletePopularMovie id:$id***');
  await popularMoviesBox.delete('$id');
}

void deletePopularMovies(List<int> ids) async {
  List<String> idsString = ids.map((e) => e.toString()).toList();
  print('Boxes >> deletePopularMovies idsString:$idsString***');
  CollectionBox popularMoviesBox = await getPopularMoviesBox();
  await popularMoviesBox.deleteAll(idsString);
}

void deleteAllPopularMovies() async {
  print('Boxes >> deleteAllPopularMovies');
  CollectionBox popularMoviesBox = await getPopularMoviesBox();
  await popularMoviesBox.clear();
}
