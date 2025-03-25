import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviesDatasourceImplementation extends MoviesDatasource {
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
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/now_playing',
        queryParameters: {'page': page},
      );
      return _jsonToMovies(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );
      return _jsonToMovies(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/top_rated',
        queryParameters: {'page': page},
      );
      return _jsonToMovies(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/upcoming',
        queryParameters: {'page': page},
      );
      return _jsonToMovies(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Movie> getMovieDetail(String movieId) async {
    final response = await dio.get('/movie/$movieId');
    if (response.statusCode != 200) {
      throw Exception('Movie with id: $movieId not found');
    }
    final movieDB = MovieDetails.fromJson(response.data);
    final movie = MovieMapper.movieDbDetailToEntity(movieDB);
    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      return _jsonToMovies(response.data);
    } catch (e) {
      return [];
    }
  }
}
