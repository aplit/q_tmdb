import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_q/models/movie.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({Key? key, required this.movie}) : super(key: key);

  static const String ROUTE = '/movieDetails';

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return MovieDetailsPage(movie: movie);
  }
}

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Movie movie;

  @override
  void initState() {
    super.initState();
    movie = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, top: 44, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              movie.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Vote average: ',
                  ),
                  TextSpan(
                    text: '${movie.vote_average}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Popularity: ',
                  ),
                  TextSpan(
                    text: '${movie.popularity}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              movie.overview,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
