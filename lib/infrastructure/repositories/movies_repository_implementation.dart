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
}
