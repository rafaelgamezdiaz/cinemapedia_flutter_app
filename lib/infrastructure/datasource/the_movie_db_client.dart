import 'package:cinemapedia/config/constants/environment.dart';
import 'package:dio/dio.dart';

class TheMovieDbClient {
  final Dio dio;

  TheMovieDbClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          queryParameters: {
            'api_key': Environment.theMovieDBKey,
            'language': 'es-MX',
          },
        ),
      );
}
