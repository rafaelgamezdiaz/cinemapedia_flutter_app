import 'package:cinemapedia/infrastructure/datasource/videos_datasource_implementation.dart';
import 'package:cinemapedia/infrastructure/repositories/videos_repository_implementation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'videos_repository_provider.g.dart';

// Este repositorio es inmutable
@riverpod
class VideosRepository extends _$VideosRepository {
  @override
  VideosRepositoryImplementation build() => VideosRepositoryImplementation(
    videosDatasource: VideosDatasourceImplementation(),
  );
}
