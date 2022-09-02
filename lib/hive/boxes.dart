import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:tmdb_q/models/genre.dart';
import 'package:tmdb_q/models/movie.dart';
import 'package:tmdb_q/utilities.dart';

const String DATABASE_NAME = 'tmdb_local';
const String MOVIES_POPULAR = 'moviesPopular';
const String MOVIE_GENRES = 'movieGenres';

Future<BoxCollection> getBoxCollection() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory? directory = await getCacheDir();
  Hive.init(directory.path);
  String path = '${directory.path}/tmdb_collection';
  print('Boxes >> getPopularMoviesBox path:$path***');
  return await BoxCollection.open(DATABASE_NAME, {MOVIES_POPULAR, MOVIE_GENRES},
      path: path);
}

Future<CollectionBox> getMoviesBox() async {
  final boxCollection = await getBoxCollection();
  return boxCollection.openBox<Map>(MOVIES_POPULAR);
}

void savePopularMovie(Movie movie) async {
  CollectionBox collectionBox = await getMoviesBox();
  print('Boxes >> savePopularMovie movie:${movie.title}'
      '|favorited:${movie.favorited}***');
  await collectionBox.put('${movie.id}', movie.toJson());
}

void savePopularMovies(List<Movie> movies) async {
  print('Boxes >> savePopularMovies movies:'
      '${movies != null ? movies.length : 'NULL'}***');
  if (movies != null) {
    for (Movie movie in movies) {
      savePopularMovie(movie);
    }
  }
}

Future<Movie> getPopularMovie(int id) async {
  CollectionBox collectionBox = await getMoviesBox();
  print('Boxes >> getPopularMovie id:$id***');
  Movie movie = await collectionBox.get('$id');
  print('Boxes >> getPopularMovie movie:${movie.title}***');
  return movie;
}

Future<Map<String, dynamic>> getPopularMovies() async {
  print('Boxes >> getPopularMovies');
  CollectionBox collectionBox = await getMoviesBox();
  return collectionBox.getAllValues();
}

Future<List<Movie>> getFavoritedPopularMovies() async {
  print('Boxes >> getFavoritedPopularMovies');
  Map<String, dynamic> map = await getPopularMovies();
  List<Movie> movies = [];
  map.forEach((key, value) {
    Movie movie = Movie.fromJson(value);
    print('Boxes >> favoritedMovieKey:$key|title:${movie.title}'
        '|favorited:${movie.favorited}'
        '***');
    if (movie.favorited) {
      movies.add(movie);
    }
  });
  return movies;
}

void deletePopularMovie(int id) async {
  CollectionBox collectionBox = await getMoviesBox();
  print('Boxes >> deletePopularMovie id:$id***');
  await collectionBox.delete('$id');
}

void deletePopularMovies(List<int> ids) async {
  List<String> idsString = ids.map((e) => e.toString()).toList();
  print('Boxes >> deletePopularMovies idsString:$idsString***');
  CollectionBox collectionBox = await getMoviesBox();
  await collectionBox.deleteAll(idsString);
}

void deleteAllPopularMovies() async {
  print('Boxes >> deleteAllPopularMovies');
  CollectionBox collectionBox = await getMoviesBox();
  await collectionBox.clear();
}

Future<CollectionBox> getGenreBox() async {
  final boxCollection = await getBoxCollection();
  return boxCollection.openBox<Map>(MOVIE_GENRES);
}

void saveGenre(Genre genre) async {
  CollectionBox collectionBox = await getGenreBox();
  print('Boxes >> saveGenre genre:${genre.name}***');
  await collectionBox.put('${genre.id}', genre.toJson());
}

void saveGenres(List<Genre> genres) async {
  CollectionBox collectionBox = await getGenreBox();
  for (Genre genre in genres) {
    print('Boxes >> saveGenres genre:${genre.name}***');
    await collectionBox.put('${genre.id}', genre.toJson());
  }
}

Future<Genre> getGenre(int id) async {
  CollectionBox collectionBox = await getGenreBox();
  print('Boxes >> getGenre id:$id***');
  Genre genre = await collectionBox.get('$id');
  print('Boxes >> getGenre genre:${genre.name}***');
  return genre;
}

Future<Map<String, dynamic>> getGenres() async {
  print('Boxes >> getGenres');
  CollectionBox collectionBox = await getGenreBox();
  return collectionBox.getAllValues();
}

void deleteGenre(int id) async {
  CollectionBox collectionBox = await getGenreBox();
  print('Boxes >> deleteGenre id:$id***');
  await collectionBox.delete('$id');
}

void deleteGenres(List<int> ids) async {
  List<String> idsString = ids.map((e) => e.toString()).toList();
  print('Boxes >> deleteGenres idsString:$idsString***');
  CollectionBox collectionBox = await getGenreBox();
  await collectionBox.deleteAll(idsString);
}

void deleteAllGenres() async {
  print('Boxes >> deleteAllGenres');
  CollectionBox collectionBox = await getGenreBox();
  await collectionBox.clear();
}
