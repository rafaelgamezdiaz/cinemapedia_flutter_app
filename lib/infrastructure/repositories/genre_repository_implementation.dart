import 'package:cinemapedia/domain/datasources/genres_datasource.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/repositories/genres_repository.dart';

class GenreRepositoryImplementation extends GenresRepository {
  final GenresDatasource genresDatasource;

  GenreRepositoryImplementation({required this.genresDatasource});

  @override
  Future<List<Genre>> getGenres() {
    return genresDatasource.getGenres();
  }
}
