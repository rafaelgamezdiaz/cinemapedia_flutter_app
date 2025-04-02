import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_provider.g.dart';

@riverpod
Future<bool> isFavorite(Ref ref, int movieID) async {
  final localStorageProvider = ref.read(localStorageNotifierProvider);
  return localStorageProvider.isMovieFavorite(movieID);
}

@riverpod
class FavoritesMoviesNotifier extends _$FavoritesMoviesNotifier {
  int currentPage = 0;
  bool isLoading = false;

  @override
  List<Movie> build() {
    ref.watch(localStorageNotifierProvider);
    _loadFavorites();
    return [];
  }

  Future<void> _loadFavorites() async {
    if (isLoading) return;
    isLoading = true;

    final localStorageProvider = ref.read(localStorageNotifierProvider);
    final List<Movie> favorites = await localStorageProvider.loadMovies(
      offset: 0, // Cargar desde el inicio
      limit: 20,
    );

    state = favorites; // Actualizar el estado con la lista completa
    currentPage = 1; // Preparar para la siguiente página
    isLoading = false;
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    final localStorageProvider = ref.read(localStorageNotifierProvider);
    final List<Movie> favorites = await localStorageProvider.loadMovies(
      offset: currentPage * 10,
      limit: 20,
    );
    currentPage++;

    state = [...state, ...favorites];
    isLoading = false;
  }

  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }
}
