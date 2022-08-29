import 'package:flutter/material.dart';
import 'package:tmdb_q/httpConfig.dart';
import 'package:tmdb_q/models/genre.dart';
import 'package:tmdb_q/models/movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'The Movie Database Task'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print('Main >> initState');
    try {
      fetchGenres().then((List<Genre>? genres) {
        print('Main >> genresLength:${genres!.length}***');
        for (Genre genre in genres) {
          print('Main >> genre:${genre.name}***');
        }
      });
      fetchPopularMovies().then((List<Movie>? movies) {
        print('Main >> moviesLength:${movies!.length}***');
        for (Movie movie in movies) {
          print('Main >> movie:${movie.title}***');
        }
      });
    } catch (e) {
      print('Main >> initState error:'
          '${e != null ? e.toString() : 'NULL'}***');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(),
      ),
    );
  }
}
