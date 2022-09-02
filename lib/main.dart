import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tmdb_q/hive/boxes.dart';
import 'package:tmdb_q/httpConfig.dart';
import 'package:tmdb_q/models/genre.dart';
import 'package:tmdb_q/models/movie.dart';
import 'package:tmdb_q/movieDetails.dart';
import 'package:tmdb_q/utilities.dart';

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
  List<Genre> genres = [];
  List<Movie> movies = [];
  HashMap<int, Image> photoList = HashMap();

  int selectedIndex = 0;

  void onItemTapped(int index) {
    print('Main >> onItemTapped:$index***');
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    print('Main >> initState');
    try {
      applyPopularMovies([]);
      fetchGenres().then((List<Genre>? genres) {
        print('Main >> genresLength:${genres!.length}***');
        for (Genre genre in genres) {
          print('Main >> genre:${genre.name}***');
        }
        setState(() {
          this.genres = genres;
        });
      });
      fetchPopularMovies().then((List<Movie>? movies) {
        print('Main >> fetchPopularMovies movies:'
            '${movies != null ? movies.length : 'NULL'}***');
        applyPopularMovies(movies);
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          selectedIndex == 0 ? getPopularMoviesList() : getGenresList(),
        ],
      ),
      bottomNavigationBar: getNavigationBar(selectedIndex, onItemTapped),
    );
  }

  void applyPopularMovies(List<Movie>? moviesToSave) async {
    print('Main >> applyPopularMovies moviesToSave:'
        '${moviesToSave != null ? moviesToSave.length : 'NULL'}');
    if (moviesToSave != null && moviesToSave.isNotEmpty) {
      CollectionBox collectionBox = await getMoviesBox();
      for (Movie movie in moviesToSave) {
        final movieData = await collectionBox.get('${movie.id}');
        if (movieData != null) {
          Movie movieToUpdate = Movie.fromJson(movieData);
          print('Main >> movieToUpdate movie:${movieToUpdate.title}'
              '|favorited:${movieToUpdate.favorited}***');
        } else {
          print('Main >> savePopularMovie movie:${movie.title}'
              '|favorited:${movie.favorited}***');
          await collectionBox.put('${movie.id}', movie.toJson());
        }
      }
    }
    Map<String, dynamic> map = await getPopularMovies();
    List<Movie> movies = [];
    map.forEach((key, value) {
      Movie movie = Movie.fromJson(value);
      print('Main >> movieKey:$key|title:${movie.title}'
          '|favorited:${movie.favorited}'
          '***');
      movies.add(movie);
    });
    setState(() {
      this.movies = movies;
    });
    //TODO downloadPosters(movies);
  }

  Widget getPopularMoviesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index >= movies.length) {
          return null;
        }
        Movie movie = movies[index];
        Image? poster =
            photoList.containsKey(movie.id) ? photoList[movie.id] : null;
        return Container(
          padding: const EdgeInsets.all(6),
          child: Card(
            elevation: 1,
            child: InkWell(
              onTap: () async {
                print('Main >> movieOnTap:${movie.title}***');
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(movie: movie),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                // decoration: const BoxDecoration(
                //   color: Colors.cyan,
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.white24,
                //       blurRadius: 0.0,
                //       spreadRadius: 0.0,
                //       offset: Offset(0.0, 2.0),
                //     )
                //   ],
                // ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          print('Main >> favoriteOnPressed');
                          setState(() {
                            movie.favorited = !movie.favorited;
                          });
                          savePopularMovie(movie);
                        },
                        icon: Image(
                          image: movie.favorited != null && movie.favorited
                              ? const AssetImage(
                                  'assets/icon_bookmark_yellow.png')
                              : const AssetImage(
                                  'assets/icon_bookmark_bordered.png'),
                          fit: BoxFit.contain,
                          width: 24,
                        ),
                      ),
                      //   InkWell(
                      //   onTap: () {
                      //     //TODO
                      //   },
                      //   child: const Image(
                      //     image: AssetImage('assets/icon_bookmark_yellow.png'),
                      //     fit: BoxFit.contain,
                      //     width: 24,
                      //   ),
                      // ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     // poster != null
                //     //     ? ClipRRect(
                //     //         borderRadius: BorderRadius.circular(2),
                //     //         child: poster,
                //     //       )
                //     //     : Container(),
                //     // const SizedBox(
                //     //   width: 8,
                //     // ),
                //   ],
                // ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget getGenresList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index >= genres.length) {
            return null;
          }
          Genre genre = genres[index];
          return Container(
            padding: const EdgeInsets.all(26),
            child: Text(
              genre.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  void downloadPosters(List<Movie> movies) async {
    if (movies.isNotEmpty) {
      for (Movie movie in movies) {
        downloadPoster(movie);
      }
    }
  }

  void downloadPoster(Movie movie) {
    String posterUrl = TMDB_BASE_URL + movie.poster_path;
    String filename =
        posterUrl.replaceAll(TMDB_BASE_URL, '').replaceAll('/', '');
    print('Main >> downloadPoster posterUrl:$posterUrl***');
    if (posterUrl.isNotEmpty) {
      downloadImageWithDimension(posterUrl, filename).then((Image? image) {
        if (image != null) {
          setState(() {
            photoList.putIfAbsent(movie.id, () {
              print('Main >> putIfAbsent imageNotNull:${image != null}' +
                  '|filename:$filename|posterUrl:$posterUrl***');
              return image;
            });
          });
        }
      });
    }
  }

  Future<Image?> downloadImageWithDimension(
      String photoUrl, String filename) async {
    print(
        'ImageUtilities >> downloadImageWithDimension filename:$filename|photoUrl:photoUrl***');
    File? destFile = await getTemporaryFile(filename);
    bool existing = await checkFileExists(destFile!);
    print('ImageUtilities >> downloadImageWithDimension existing:$existing***');
    if (existing) {
      return getImageWithDimension(destFile, 48, 48, BoxFit.fitHeight);
    } else {
      File? imageFile = await downloadFile(photoUrl, destFile);
      print('ImageUtilities >> downloadImageWithDimension imageFile:' +
          '${imageFile != null ? imageFile.path : 'NULL'}***');
      if (imageFile != null) {
        return getImageWithDimension(imageFile, 48, 48, BoxFit.fitHeight);
      } else {
        return await downloadPhoto(photoUrl);
      }
    }
  }
}
