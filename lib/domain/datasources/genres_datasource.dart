import 'package:cinemapedia/domain/entities/genre.dart';

abstract class GenresDatasource {
  Future<List<Genre>> getGenres();
}
