import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/movies/movies_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'popular_movies_provider.g.dart';

@riverpod
class PopularMoviesNotifier extends _$PopularMoviesNotifier {
  int currentPage = 0;
  bool isLoading = false;

  @override
  List<Movie> build() {
    return [];
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final fetchPopularMoreMovies =
        ref.watch(moviesRepositoryNotifierProvider).getPopularMovies;
    final List<Movie> movies = await fetchPopularMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}
