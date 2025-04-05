import 'package:cinemapedia/domain/entities/genre.dart';

abstract class GenresRepository {
  Future<List<Genre>> getGenres();
}
