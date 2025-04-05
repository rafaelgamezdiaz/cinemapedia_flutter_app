import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/genres_datasource.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/infrastructure/mappers/genre_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/genres_response.dart';
import 'package:dio/dio.dart';

class GenresDatasourceImplementation extends GenresDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'es-MX',
      },
    ),
  );

  List<Genre> _jsonToGenre(Map<String, dynamic> json) {
    final genresResponse = GenreResponse.fromJson(json);
    final genresResponseGenres = genresResponse.genres;

    final List<Genre> genres =
        genresResponseGenres
            .map((genre) => GenreMapper.genreMovieDbtoEntity(genre))
            .toList();

    return genres;
  }

  @override
  Future<List<Genre>> getGenres() async {
    try {
      final response = await dio.get('/genre/movie/list');
      if (response.statusCode == 200) {
        return _jsonToGenre(response.data);
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      throw Exception('Failed to load genres: $e');
    }
  }
}
