import 'package:cinemapedia/domain/datasources/videos_datasource.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/repositories/videos_repository.dart';

class VideosRepositoryImplementation extends VideosRepository {
  final VideosDatasource videosDatasource;

  VideosRepositoryImplementation({required this.videosDatasource});

  @override
  Future<List<Video>> getMovieVideos(String movieId) {
    return videosDatasource.getMovieVideos(movieId);
  }
}
