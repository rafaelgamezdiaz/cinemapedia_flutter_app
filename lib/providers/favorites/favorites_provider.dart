import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_provider.g.dart';

@riverpod
Future<bool> isFavorite(Ref ref, int movieID) async {
  // Nota: Aquí usas 'ref.read'. Si el estado de favorito cambia externamente
  // (muy improbable en este caso, pero posible), este provider no se actualizará
  // automáticamente. Considera 'ref.watch' si necesitas esa reactividad,
  // aunque puede ser menos eficiente si se reconstruye mucho. 'ref.read' suele
  // estar bien para una comprobación puntual.
  final localStorageRepository = ref.read(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieID);
}

const int FAVORITE_MOVIES_PER_PAGE = 15;

// Provider para gestionar la LISTA de películas favoritas con paginación
@riverpod
class FavoritesMoviesNotifier extends _$FavoritesMoviesNotifier {
  int _currentPage = 0; // Empezar en 0 para la carga inicial
  bool _isLoading = false;

  @override
  Future<List<Movie>> build() async {
    // Llama a _loadPage para cargar la primera página (página 0)
    // Riverpod manejará automáticamente el estado AsyncLoading inicial
    return await _loadPage(0);
  }

  // Método helper para cargar una página específica
  Future<List<Movie>> _loadPage(int page) async {
    // Lee la instancia del repositorio usando el provider simple
    final localStorageRepository = ref.read(localStorageRepositoryProvider);
    final List<Movie> favorites = await localStorageRepository.loadMovies(
      offset: page * FAVORITE_MOVIES_PER_PAGE,
      limit: FAVORITE_MOVIES_PER_PAGE,
    );
    return favorites;
  }

  // Carga la siguiente página de favoritos
  Future<bool> loadNextPage() async {
    if (_isLoading) return false; // Evita cargas concurrentes
    _isLoading = true;

    _currentPage++; // Incrementa el contador de página *antes* de cargar

    try {
      final newFavorites = await _loadPage(_currentPage);

      // Obtenemos el estado actual (la lista de películas ya cargadas).
      // state.value devuelve el List<Movie>? si el estado es AsyncData, o null si es AsyncLoading/AsyncError.
      final previousFavorites = state.value ?? [];

      // Actualiza el estado con un NUEVO AsyncData que contiene la lista combinada
      state = AsyncData([...previousFavorites, ...newFavorites]);

      _isLoading = false;

      // Devuelve true si se cargaron películas nuevas, false si la página estaba vacía
      return newFavorites.isNotEmpty;
    } catch (e, s) {
      // Captura el stacktrace también
      _isLoading = false;
      _currentPage--; // Revierte el incremento de página si hubo error

      // Actualiza el estado a AsyncError para que la UI pueda reaccionar
      state = AsyncError(e, s);
      return false; // Indica que no se cargaron nuevas películas (debido al error)
    }
  }

  Future<void> refreshFavorites() async {
    // No es necesario _isLoading check aquí porque vamos a sobreescribir el estado
    // con AsyncLoading de todas formas.
    _currentPage = 0; // Reinicia el contador de página
    state = const AsyncLoading(); // Muestra el indicador de carga

    try {
      // Vuelve a ejecutar la lógica de build para recargar
      state = AsyncData(await _loadPage(0));
    } catch (e, s) {
      state = AsyncError(e, s); // Maneja el error
    }
    // No necesitamos _isLoading = false aquí, AsyncValue maneja el estado.
  }

  // Añade o elimina una película de favoritos
  Future<void> toggleFavorite(Movie movie) async {
    // Leemos el repositorio
    final localStorageRepository = ref.read(localStorageRepositoryProvider);

    // Intentamos actualizar en la BD primero
    try {
      await localStorageRepository.togleFavorite(movie);
    } catch (e) {
      // Podrías decidir mostrar un error temporal o simplemente no actualizar el estado local
      // state = AsyncError(e, s); // Opcional: reflejar error en el estado
      return; // Salimos si falla la persistencia
    }

    // Actualiza el estado local (la lista en memoria) del provider
    // Solo procedemos si el estado actual tiene datos (no está en loading/error)
    final currentFavorites = state.valueOrNull;
    if (currentFavorites == null) {
      return; // No podemos actualizar una lista que no existe o está en error/loading
    }

    final bool isMovieInFavorites = currentFavorites.any(
      (m) => m.id == movie.id,
    );

    List<Movie> newStateList;
    if (isMovieInFavorites) {
      // Eliminar la película de la lista actual
      newStateList = currentFavorites.where((m) => m.id != movie.id).toList();
    } else {
      // Agregar la película al principio de la lista actual
      newStateList = [movie, ...currentFavorites];
    }
    // Actualizamos el estado con la nueva lista envuelta en AsyncData
    state = AsyncData(newStateList);

    // Invalidamos isFavoriteProvider para que el icono se actualice donde sea necesario.
    // Hacemos esto *después* de actualizar el estado local exitosamente.
    ref.invalidate(isFavoriteProvider(movie.id));
  }
}
