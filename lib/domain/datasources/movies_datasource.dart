import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlayingMovies({int page = 1});

  Future<List<Movie>> getPopularMovies({int page = 1});

  Future<List<Movie>> getTopRatedMovies({int page = 1});

  Future<List<Movie>> getUpcomingMovies({int page = 1});

  Future<Movie> getMovieDetail(String movieId);

  Future<List<Movie>> searchMovies(String query, String orderBy);

  Future<List<Video>> getMovieVideo(String movieId);
}
