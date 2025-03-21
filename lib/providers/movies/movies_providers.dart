import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/movies/movies_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_providers.g.dart';

@riverpod
class MoviesNotifier extends _$MoviesNotifier {
  int currentPage = 0;

  @override
  List<Movie> build() {
    return [];
  }

  Future<void> loadNextPage() async {
    currentPage++;
    final fetchMoreMovies =
        ref.watch(moviesRepositoryNotifierProvider).getNowPlayingMovies;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }
}

// @riverpod
// class NowPlayingMovies extends _$NowPlayingMovies {
//   @override
//   MoviesNotifier build() {
//     final fetchMoreMovies =
//         ref.watch(moviesRepositoryNotifierProvider).getNowPlayingMovies;
//     return MoviesNotifier(fetchMoreMovies);
//   }
// }
