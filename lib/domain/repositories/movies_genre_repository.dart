import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesGenreRepository {
  Future<List<Movie>> getMoviesByGenre({int page = 1, required String genreId});
}
