import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/providers/genres/genres_provider.dart'; // Asegúrate que la importación sea correcta (ahora es 'genresProvider')
import 'package:cinemapedia/providers/movies/initial_loading_provider.dart';
import 'package:cinemapedia/providers/movies/movies_genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesView extends ConsumerStatefulWidget {
  const CategoriesView({super.key});

  @override
  CategoriesViewState createState() => CategoriesViewState();
}

class CategoriesViewState extends ConsumerState<CategoriesView> {
  @override
  void initState() {
    super.initState();
    ref.read(genresProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final loadingMovies = ref.watch(initialLoadingProvider);
    if (loadingMovies) return FullScreenLoader();

    // Observa el estado asíncrono del provider 'genresProvider'
    final asyncGenres = ref.watch(genresProvider);

    return Scaffold(
      body: asyncGenres.when(
        data: (genres) {
          if (genres.isEmpty) {
            return const Center(child: Text('No hay géneros disponibles'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final genre = genres[index];
                  final genreIdString = genre.id.toString();
                  return Column(
                    children: [
                      SizedBox(height: 2),
                      _GenreMoviesList(
                        key: ValueKey(
                          genre.id,
                        ), // Key para mejor performance de rebuilds
                        genre: genre,
                        genreIdString: genreIdString,
                      ),

                      SizedBox(height: 5),
                    ],
                  );
                }, childCount: genres.length),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// Widget auxiliar para encapsular la lógica de cada fila (Título + Lista Horizontal)
class _GenreMoviesList extends ConsumerWidget {
  final Genre genre;
  final String genreIdString;

  const _GenreMoviesList({
    super.key,
    required this.genre,
    required this.genreIdString,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa la instancia específica del provider para este género
    // El provider se creará (o reutilizará) aquí con el genreIdString específico
    final moviesByGenre = ref.watch(moviesGenreNotifierProvider(genreIdString));

    // Llama a loadNextPage solo si la lista está vacía y no se está cargando aún
    // Esto asegura que la primera página se cargue cuando el widget es visible
    // y evita llamadas repetidas en rebuilds innecesarios.
    // Usamos addPostFrameCallback para hacerlo después de que el build inicial termine.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Verifica si la lista está vacía y si el notifier no está ya en proceso de carga
      // (Necesitarías exponer el estado isLoading del notifier si quieres esta comprobación)
      // Por ahora, una comprobación simple: si está vacío, intenta cargar.
      // El `isLoading` dentro del notifier previene cargas múltiples.
      if (moviesByGenre.isEmpty && mounted(ref)) {
        // mounted(ref) verifica si el widget sigue en el árbol
        ref
            .read(moviesGenreNotifierProvider(genreIdString).notifier)
            .loadNextPage();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Muestra el MoviesHorizontalListview para este género
        MoviesHorizontalListview(
          movies: moviesByGenre,
          title: genre.name,
          loadNextPage: () {
            // Llama a loadNextPage en el notifier específico de este género
            ref
                .read(moviesGenreNotifierProvider(genreIdString).notifier)
                .loadNextPage();
          },
        ),

        const SizedBox(height: 5), // Espacio entre géneros
      ],
    );
  }

  // Helper para comprobar si el widget sigue montado antes de llamar a read/load
  bool mounted(WidgetRef ref) {
    try {
      // Intentar acceder a context de forma segura
      ModalRoute.of(ref.context);
      return true;
    } catch (e) {
      return false;
    }
  }
}
