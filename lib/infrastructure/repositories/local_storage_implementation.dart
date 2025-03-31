import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImplementation extends LocalStorageRepository {
  final LocalStorageDataSource localStorageDataSource;

  LocalStorageRepositoryImplementation({required this.localStorageDataSource});

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return localStorageDataSource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    return localStorageDataSource.loadMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> togleFavorite(Movie movie) {
    return localStorageDataSource.togleFavorite(movie);
  }
}
