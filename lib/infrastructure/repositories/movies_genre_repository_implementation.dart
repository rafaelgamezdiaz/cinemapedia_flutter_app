import 'package:cinemapedia/domain/datasources/movies_genre_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_genre_repository.dart';

class MoviesGenreRepositoryImplementation extends MoviesGenreRepository {
  final MoviesGenreDatasource moviesGenreDatasource;

  MoviesGenreRepositoryImplementation({required this.moviesGenreDatasource});

  @override
  Future<List<Movie>> getMoviesByGenre({
    int page = 1,
    required String genreId,
  }) {
    return moviesGenreDatasource.getMoviesByGenre(page: page, genreId: genreId);
  }
}
