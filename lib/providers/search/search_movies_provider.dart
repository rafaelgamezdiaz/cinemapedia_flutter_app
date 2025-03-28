import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_movies_provider.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateSearchQuery(String query) {
    state = query;
  }
}

@riverpod
class SearchedMovies extends _$SearchedMovies {
  @override
  List<Movie> build() => [];

  void updateLastSearchedMovies(List<Movie> movies) {
    state = movies; // state = [...state, query];
  }
}
