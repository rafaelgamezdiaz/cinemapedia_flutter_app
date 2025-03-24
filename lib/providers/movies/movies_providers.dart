import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/movies/movies_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_providers.g.dart';

@riverpod
class NowPlayingMoviesNotifier extends _$NowPlayingMoviesNotifier {
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
    final fetchMoreMovies =
        ref.watch(moviesRepositoryNotifierProvider).getNowPlayingMovies;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}

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

@riverpod
class TopRatedMoviesNotifier extends _$TopRatedMoviesNotifier {
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
    final fetchTopRatedMoreMovies =
        ref.watch(moviesRepositoryNotifierProvider).getTopRatedMovies;
    final List<Movie> movies = await fetchTopRatedMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}

@riverpod
class UpcomingMoviesNotifier extends _$UpcomingMoviesNotifier {
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
    final fetchUpcomingMoreMovies =
        ref.watch(moviesRepositoryNotifierProvider).getUpComingMovies;
    final List<Movie> movies = await fetchUpcomingMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}
