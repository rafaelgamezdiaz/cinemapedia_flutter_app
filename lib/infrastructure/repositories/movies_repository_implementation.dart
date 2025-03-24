import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MoviesRepositoryImplementation extends MoviesRepository {
  final MoviesDatasource moviesDatasource;

  MoviesRepositoryImplementation({required this.moviesDatasource});

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) {
    return moviesDatasource.getNowPlayingMovies(page: page);
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) {
    return moviesDatasource.getPopularMovies(page: page);
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) {
    return moviesDatasource.getTopRatedMovies(page: page);
  }

  @override
  Future<List<Movie>> getUpComingMovies({int page = 1}) {
    return moviesDatasource.getUpcomingMovies(page: page);
  }

  @override
  Future<Movie> getMovieDetail(String movieId) {
    return moviesDatasource.getMovieDetail(movieId);
  }
}
