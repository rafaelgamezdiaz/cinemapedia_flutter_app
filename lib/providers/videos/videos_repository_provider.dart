import 'package:cinemapedia/infrastructure/datasource/movies_datasource_implementation.dart';
import 'package:cinemapedia/infrastructure/repositories/movies_repository_implementation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'videos_repository_provider.g.dart';

// Este repositorio es inmutable
@riverpod
class VideosRepositoryNotifier extends _$VideosRepositoryNotifier {
  @override
  MoviesRepositoryImplementation build() => MoviesRepositoryImplementation(
    moviesDatasource: MoviesDatasourceImplementation(),
  );
}
