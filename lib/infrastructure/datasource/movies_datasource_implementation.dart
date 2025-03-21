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

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/now_playing',
        queryParameters: {'page': page},
      );

      final movieDbResponse = MovieDbResponse.fromJson(response.data);
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
    } catch (e) {
      return [];
      //throw Exception('Error fetching movies');
    }
  }
}
