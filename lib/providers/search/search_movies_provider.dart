import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_movies_provider.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateSearchQuery(String query) {
    state = query;
    print("searchQuery actualizado a: $state");
  }
}
