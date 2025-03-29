import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/search/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovie;
  final String initialQuery;
  final List<Movie> initialMovies;

  final StreamController<List<Movie>> debouncedMovies =
      StreamController.broadcast();
  Timer? _debounceTimer;
  final String _originalInitialQuery;

  // Flag para saber si el usuario ya ha modificado el query inicial
  bool _queryManuallyChanged = false;

  @override
  get searchFieldLabel => 'Buscar película';

  SearchMovieDelegate({
    required this.searchMovie,
    required this.initialMovies,
    this.initialQuery = '',
  }) : _originalInitialQuery = initialQuery {
    query = initialQuery;

    // ¡IMPORTANTE! Añade los datos iniciales al stream INMEDIATAMENTE.
    // Esto es crucial para que el StreamBuilder los tenga lo antes posible.
    if (initialQuery.isNotEmpty && initialMovies.isNotEmpty) {
      debouncedMovies.add(initialMovies);
    } else {
      // Si no hay datos válidos o el query es vacío, empieza con vacío.
      debouncedMovies.add([]);
    }
    // Al inicio, el query no ha sido cambiado manualmente.
    _queryManuallyChanged = false;
  }

  void clearStreams() {
    _debounceTimer?.cancel();
    debouncedMovies.close();
  }

  void _handleQueryChange(String currentQuery) {
    _debounceTimer?.cancel();
    if (debouncedMovies.isClosed) return;

    // Si el query se limpió
    if (currentQuery.isEmpty) {
      debouncedMovies.add([]);
      return;
    }

    // Inicia el debounce SOLO si el query se considera "activo" para búsqueda
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (debouncedMovies.isClosed) return;

      try {
        final movies = await searchMovie(currentQuery);
        if (!debouncedMovies.isClosed) debouncedMovies.add(movies);
      } catch (e) {
        if (!debouncedMovies.isClosed) debouncedMovies.addError(e);
      }
    });
  }

  // Sobrescribimos 'query' setter para detectar cambios manuales
  @override
  set query(String value) {
    // Si el valor nuevo es DIFERENTE del que teníamos antes de esta asignación
    // Y diferente del original, marcamos que el usuario cambió el texto.
    if (super.query != value && value != _originalInitialQuery) {
      _queryManuallyChanged = true;
    } else if (super.query != value &&
        value == _originalInitialQuery &&
        initialMovies.isEmpty) {
      // Si vuelve al query original pero no teníamos initialMovies, también cuenta como cambio activo
      _queryManuallyChanged = true;
    }
    super.query = value;
    // No llamamos a _handleQueryChange aquí directamente para evitar TANTAS llamadas, buildSuggestions se encargará.
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        FadeIn(
          animate: true,
          duration: const Duration(milliseconds: 200),
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              query =
                  ''; // Esto llamará al setter y actualizará _queryManuallyChanged si es necesario
              ProviderScope.containerOf(
                context,
                listen: false,
              ).read(searchQueryProvider.notifier).updateSearchQuery('');
              _handleQueryChange(''); // Limpia el stream explícitamente
              // Forzar rebuild de sugerencias
              showSuggestions(context);
            },
          ),
        )
      else
        const SizedBox.shrink(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        clearStreams();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Cuando se envían resultados, SIEMPRE queremos la búsqueda más reciente.
    _handleQueryChange(query);
    return _buildSearchResultsView();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // --- LÓGICA DE CONTROL PARA LA BÚSQUEDA ---
    // ¿Cuándo debemos iniciar el debounce/búsqueda?
    // 1. Si el query fue cambiado manualmente por el usuario.
    // 2. O si el query actual NO es el original con el que empezamos.
    // 3. O si es el original, PERO NO teníamos películas iniciales (forzando búsqueda inicial).
    final bool shouldTriggerSearch =
        _queryManuallyChanged ||
        query != _originalInitialQuery ||
        (query == _originalInitialQuery && initialMovies.isEmpty);

    if (shouldTriggerSearch && query.isNotEmpty) {
      // Solo llama a handleQueryChange si realmente necesitamos buscar/debounce.
      _handleQueryChange(query);
    } else if (query.isEmpty) {
      // Si el query está vacío, asegúrate de que el stream esté limpio.
      _handleQueryChange('');
    }
    // Si no se cumple shouldTriggerSearch (estamos en el query inicial con datos ya cargados),
    // NO llamamos a _handleQueryChange, permitiendo que el StreamBuilder muestre
    // los datos añadidos por el constructor o `initialData`.

    return _buildSearchResultsView();
  }

  Widget _buildSearchResultsView() {
    return StreamBuilder<List<Movie>>(
      stream: debouncedMovies.stream,
      initialData:
          (query == _originalInitialQuery && !_queryManuallyChanged)
              ? initialMovies
              : null,
      builder: (context, snapshot) {
        List<Movie> moviesToShow = [];
        if (snapshot.hasData) {
          moviesToShow = snapshot.data!;
        } else if (snapshot.connectionState != ConnectionState.waiting &&
            query == _originalInitialQuery &&
            initialMovies.isNotEmpty &&
            !_queryManuallyChanged) {
          moviesToShow = initialMovies;
        }

        // Query vacío
        if (query.isEmpty) {
          return const Center(
            child: Icon(
              Icons.movie_creation_outlined,
              size: 100,
              color: Colors.black38,
            ),
          );
        }

        final bool isInitialStateWithExpectedData =
            query == _originalInitialQuery &&
            initialMovies.isNotEmpty &&
            !_queryManuallyChanged;

        if (snapshot.connectionState == ConnectionState.waiting &&
            moviesToShow.isEmpty &&
            !isInitialStateWithExpectedData) {
          // Muestra spinner solo si estamos esperando, no hay datos AÚN, Y NO es el estado inicial manejado por initialData
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        // ... (Sin Resultados y Mostrar Lista igual que antes) ...
        if (moviesToShow.isEmpty &&
            snapshot.connectionState != ConnectionState.waiting) {
          return Center(
            child: Text('No se encontraron resultados para "$query"'),
          );
        }
        return _buildMovieList(moviesToShow);
      },
    );
  }

  // Helper para construir la lista (sin cambios)
  Widget _buildMovieList(List<Movie> movies) {
    return ListView.separated(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _MovieItem(
          movie: movie,
          onMovieSelected: (context, selectedMovie) {
            final container = ProviderScope.containerOf(context, listen: false);
            container
                .read(searchQueryProvider.notifier)
                .updateSearchQuery(query);
            clearStreams();
            close(context, selectedMovie);
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
    );
  }
}

// --- _MovieItem sin cambios ---
// ... (pega aquí tu widget _MovieItem)
class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: size.width * 0.2,
              child: Column(
                children: [
                  // Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Reducido un poco
                    child:
                        movie.posterPath == 'no-poster'
                            ? Image.asset(
                              'assets/images/no_poster.jpg',
                              fit: BoxFit.cover,
                              height: size.width * 0.2 * 1.5,
                            ) // Darle altura
                            : Image.network(
                              movie.posterPath,
                              height:
                                  size.width *
                                  0.2 *
                                  1.5, // Darle altura consistente
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return FadeIn(child: child);
                                }
                                return Container(
                                  height: size.width * 0.2 * 1.5,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image_outlined),
                                  ),
                                );
                              },
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    height: size.width * 0.2 * 1.5,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.broken_image_outlined),
                                    ),
                                  ),
                            ),
                  ),
                  const SizedBox(height: 3),
                  // Release Year (más conciso)
                  Text(
                    movie.releaseDate?.year.toString() ?? "N/A",
                    style: textStyle.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Description
            Expanded(
              // Usa Expanded para que ocupe el resto del espacio
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    // Overview
                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : 'Sin descripción disponible.',
                      maxLines: 3, // Limita las líneas de overview
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.bodySmall,
                    ),
                    const SizedBox(height: 5),
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.yellow.shade800,
                          size: 18,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          HumanFormats.humanReadbleNumber(
                            movie.voteAverage,
                            decimalDigits: 1,
                          ),
                          style: textStyle.bodyMedium!.copyWith(
                            color: Colors.yellow.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(), // Empuja el texto de popularidad a la derecha
                        Text(
                          'Pop: ${HumanFormats.humanReadbleNumber(movie.popularity)}',
                          style: textStyle.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
