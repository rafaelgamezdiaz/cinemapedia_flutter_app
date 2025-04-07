import 'package:cinemapedia/domain/entities/video.dart';

abstract class VideosRepository {
  Future<List<Video>> getMovieVideos(String movieId);
}
