import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/movies/movies_genre_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_genre_provider.g.dart';

@riverpod
class MoviesGenreNotifier extends _$MoviesGenreNotifier {
  int currentPage = 0;
  bool isLoading = false;

  late String genreId;

  @override
  List<Movie> build(String genreId) {
    this.genreId = genreId;
    return [];
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final fetchMoreMovies =
        ref.watch(moviesGenreRepositoryNotifierProvider).getMoviesByGenre;
    // final List<Movie> movies = await fetchMoreMovies(
    //   page: currentPage,
    //   genreId: '37',
    // );

    try {
      final List<Movie> movies = await fetchMoreMovies(
        page: currentPage,
        // Usa el genreId específico de esta instancia del provider
        genreId: genreId,
      );

      // Actualiza el estado de *esta* instancia específica
      state = [...state, ...movies];
    } catch (e) {
      // Podrías resetear la página o reintentar, etc.
      currentPage--; // Revierte el incremento de página si hubo error
    } finally {
      // Asegúrate de que isLoading se ponga en false incluso si hay un error
      // Espera un poco antes de permitir la siguiente carga (opcional)
      await Future.delayed(const Duration(milliseconds: 300));
      isLoading = false;
    }

    // state = [...state, ...movies];
    // await Future.delayed(const Duration(milliseconds: 300));
    // isLoading = false;
  }
}
