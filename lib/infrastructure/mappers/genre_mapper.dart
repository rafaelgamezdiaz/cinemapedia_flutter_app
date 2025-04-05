import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/genres_response.dart';

class GenreMapper {
  static Genre genreMovieDbtoEntity(GenreFormMovieDb genreMovieDb) {
    return Genre(id: genreMovieDb.id, name: genreMovieDb.name);
  }
}
