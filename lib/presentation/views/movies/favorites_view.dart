import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/providers/favorites/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView>
    with AutomaticKeepAliveClientMixin {
  bool isLastPage = false;
  bool isLoading = false;

  bool _isLoadingMore = false; // Para la carga de la *siguiente* página
  bool _isLastPage = false; // Para saber si ya no hay más páginas

  @override
  void dispose() {
    super.dispose();
  }

  // Esta es la función que MovieMasonry llamará cuando detecte el scroll
  Future<void> loadNextPage() async {
    // Evita llamadas múltiples si ya está cargando o si ya se cargó la última página
    if (_isLoadingMore || _isLastPage) return;

    // Marca como cargando la *siguiente* página
    // Usamos mounted check por si el widget se desmonta durante la operación asíncrona
    if (mounted) {
      setState(() {
        _isLoadingMore = true;
      });
    }

    // Llama al método del notifier para cargar más películas
    final bool moviesLoaded =
        await ref.read(favoritesMoviesNotifierProvider.notifier).loadNextPage();

    // Si loadNextPage devolvió false, significa que no se cargaron más películas
    // (probablemente porque la última llamada devolvió una lista vacía)
    if (!moviesLoaded && mounted) {
      setState(() {
        _isLastPage = true;
      });
    }

    // Marca como que ya no está cargando (independientemente de si se cargaron nuevas o no)
    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observa el estado AsyncValue del provider de la lista de favoritos
    final favoritesState = ref.watch(favoritesMoviesNotifierProvider);

    return Scaffold(
      // Maneja los diferentes estados del AsyncValue que viene del provider
      body: favoritesState.when(
        // Estado de carga inicial (o durante refresh)
        loading:
            () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),

        // Estado de error (falló la carga inicial o un refresh)
        error:
            (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: () {
                      // Intenta recargar la primera página
                      _isLastPage = false; // Resetea por si acaso
                      ref
                          .read(favoritesMoviesNotifierProvider.notifier)
                          .refreshFavorites();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),

        // Estado con datos (lista de películas cargada correctamente)
        data: (favoritos) {
          if (favoritos.isEmpty) {
            // Muestra un mensaje si no hay favoritos después de cargar
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Aún no tienes películas favoritas'),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    // Botón para recargar por si acaso
                    onPressed: () {
                      _isLastPage = false; // Resetea
                      ref
                          .read(favoritesMoviesNotifierProvider.notifier)
                          .refreshFavorites();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Recargar'),
                  ),
                ],
              ),
            );
          }

          // Muestra el Masonry y añade un indicador de carga al final si es necesario
          return Column(
            children: [
              Expanded(
                // Pasa la lista y la función de callback a MovieMasonry
                child: MovieMasonry(
                  movies: favoritos,
                  loadNextPage: loadNextPage,
                ),
              ),
              // Muestra un indicador de carga en la parte inferior
              // mientras se está ejecutando loadNextPage()
              if (_isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
