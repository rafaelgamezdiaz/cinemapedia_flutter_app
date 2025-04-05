import 'package:cinemapedia/infrastructure/datasource/movies_genre_datasource_implementation.dart';
import 'package:cinemapedia/infrastructure/repositories/movies_genre_repository_implementation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_genre_repository_provider.g.dart';

@riverpod
class MoviesGenreRepositoryNotifier extends _$MoviesGenreRepositoryNotifier {
  @override
  MoviesGenreRepositoryImplementation build() =>
      MoviesGenreRepositoryImplementation(
        moviesGenreDatasource: MoviesGenreDatasourceImplementation(),
      );
}
