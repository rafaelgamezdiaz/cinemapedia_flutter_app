import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorDatasourceImplementation extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'es-MX',
      },
    ),
  );

  List<Actor> _jsonToActor(Map<String, dynamic> json) {
    final creditsResponse = CreditsResponse.fromJson(json);
    final creaditsResponseActor = creditsResponse.cast;

    // final actors = ActorMapper.castToEntity(creaditsResponseActor);
    final List<Actor> actors =
        creaditsResponseActor
            .map((actor) => ActorMapper.castToEntity(actor))
            .toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    try {
      final response = await dio.get('/movie/$movieId/credits');
      if (response.statusCode != 200) {
        throw Exception('Actos of movie with id: $movieId not found');
      }
      return _jsonToActor(response.data);
    } catch (e) {
      return [];
    }
  }
}
