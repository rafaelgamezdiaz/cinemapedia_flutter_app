import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/providers/videos/videos_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'videos_provider.g.dart';

@riverpod
class Videos extends _$Videos {
  @override
  Future<List<Video>> build(String movieId) async {
    final videosRepository = ref.watch(videosRepositoryProvider);

    final List<Video> videos = await videosRepository.getMovieVideos(movieId);

    return videos;
  }
}
