import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_genre_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviesGenreDatasourceImplementation extends MoviesGenreDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'es-MX',
      },
    ),
  );

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);
    final movieDbResponseMovies = movieDbResponse.results;
    final List<Movie> movies =
        movieDbResponseMovies
            .where((movie) => movie.posterPath != 'no-poster')
            .where(
              (movie) =>
                  (movie.backdropPath != 'no-backdrop') &&
                  (movie.backdropPath != null) &&
                  (movie.backdropPath!.trim().isNotEmpty),
            )
            .map((movie) => MovieMapper.movieDbToEntity(movie))
            .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getMoviesByGenre({
    int page = 1,
    required String genreId,
  }) async {
    try {
      final response = await dio.get(
        '/discover/movie',
        queryParameters: {'with_genres': genreId, 'page': page},
      );
      if (response.statusCode == 200) {
        return _jsonToMovies(response.data);
      } else {
        throw Exception('Failed to load the movies by genre');
      }
    } catch (e) {
      throw Exception('Failed to load movies by genre: $e');
    }
  }
}
