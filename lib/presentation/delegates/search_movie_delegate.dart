import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovie;

  SearchMovieDelegate({
    // super.searchFieldLabel,
    // super.searchFieldStyle,
    // super.searchFieldDecorationTheme,
    // super.keyboardType,
    // super.textInputAction,
    // super.autocorrect,
    // super.enableSuggestions,
    required this.searchMovie,
  });

  @override
  get searchFieldLabel => 'Buscar película';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchMovie(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<Movie> movies = snapshot.data as List<Movie>;

        return ListView.separated(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(movie: movie, onMovieSelected: close);
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey[300], // Color gris claro
              thickness: 1.0, // Grosor de la línea
              height: 1.0, // Espaciado vertical alrededor del separador
            );
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: size.width * 0.2,
              child: Column(
                children: [
                  // Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        movie.posterPath == 'no-poster'
                            ? Image.asset(
                              'assets/images/no_poster.jpg',
                              fit: BoxFit.cover,
                            )
                            : Image.network(
                              movie.posterPath,
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      FadeIn(child: child),
                            ),
                  ),

                  // Release Date
                  Text(
                    '${movie.releaseDate?.year ?? "No disponible"}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Descrition
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium),

                  // Overview
                  (movie.overview.length > 100)
                      ? Text(
                        '${movie.overview.substring(0, 100)}...',
                        style: textStyle.titleSmall,
                      )
                      : Text(movie.overview, style: textStyle.titleSmall),

                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      Text(
                        HumanFormats.humanReadbleNumber(
                          movie.voteAverage,
                          decimalDigits: 1,
                        ),
                        style: textStyle.bodyMedium!.copyWith(
                          color: Colors.yellow.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
