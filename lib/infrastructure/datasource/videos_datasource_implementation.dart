import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/videos_datasource.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/mappers/video_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/videos_response.dart';
import 'package:dio/dio.dart';

class VideosDatasourceImplementation extends VideosDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.theMovieDBKey},
    ),
  );

  @override
  Future<List<Video>> getMovieVideos(String movieId) async {
    try {
      final response = await dio.get('/movie/$movieId/videos');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load videos for movie: $movieId. Status Code: ${response.statusCode}',
        );
      }
      final videoResponse = VideosResponse.fromJson(response.data);

      // Filtrar por YouTube y Trailer
      final filteredByTypeAndSite =
          videoResponse.results
              .where(
                (videoResult) =>
                    (videoResult.site == 'YouTube' &&
                        videoResult.type == 'Trailer'),
              )
              .toList(); // Convertir a lista para poder imprimir count

      // Filtrar por clave no nula/vacía (aunque el mapper ya podría manejar nulls)
      final filteredByKey =
          filteredByTypeAndSite
              .where(
                (videoResult) =>
                    (videoResult.key != null && videoResult.key!.isNotEmpty),
              )
              .toList();

      // Mapear a la entidad Video
      final List<Video> videos =
          filteredByKey
              .map(
                (videoResult) => VideoMapper.videoMovieDbToEntity(videoResult),
              )
              .toList();

      return videos;
    } catch (e) {
      return []; // Devuelve lista vacía en caso de error
    }
  }
}
