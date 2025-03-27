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

  // Utilizamos un StreamController ya que queremos implementar un StreamBuilder, pues con un FutureBuilder
  // se estarían lanzado peticiones por cada letra que se presiones y queremos reducir el numero de peticiones a la API
  StreamController<List<Movie>> debouncedMovies =
      StreamController.broadcast(); // Se utiliza broadcast para que varios widgets puedan escuchar el stream
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovie, this.initialQuery = ''}) {
    query = initialQuery;

    // Lanza la primera búsqueda si initialQuery no está vacío
    // Esto poblará el stream inicial si es necesario.
    // Nota: _onQueryChanged ya maneja el caso de query vacío.
    _onQueryChanged(query);
  }

  void clearStreams() {
    debouncedMovies.close();
  }

  void _onQueryChanged(String query) {
    // Si el texto está vacío, cancelamos la búsqueda y limpiamos la lista
    if (query.isEmpty) {
      debouncedMovies.add([]);
      _debounceTimer?.cancel();
      return;
    }

    _debounceTimer
        ?.cancel(); // Cada vez que la persona escribe el Timer se reinicia

    // Cuando la persona deja de escribir es que se lanza la petición a la API
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovie(query);
      debouncedMovies.add(movies);
    });
  }

  @override
  get searchFieldLabel => 'Buscar película';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            // 1. Limpia el query interno del delegate
            query = '';

            // 2. Actualiza el provider global (opcional pero bueno si quieres que se borre globalmente)
            ProviderScope.containerOf(
              context,
              listen: false,
            ).read(searchQueryProvider.notifier).updateSearchQuery('');

            // 3. Llama a _onQueryChanged con el query vacío.
            //    Esto asegurará que el stream reciba una lista vacía
            //    y el debounce se maneje correctamente si el usuario
            //    vuelve a escribir rápido.
            _onQueryChanged('');
          },
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        clearStreams();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Llama a _onQueryChanged siempre que se reconstruyan las sugerencias.
    // El debounce interno se encargará de gestionar las llamadas API.
    _onQueryChanged(query);

    // El StreamBuilder se encarga de mostrar los resultados actuales del stream
    return StreamBuilder(
      // Mejor que un FutureBuilder, ya que un FutureBuilder lanza peticiones por cada tecla pulsada
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        // Si el query está vacío y no hay datos (o están vacíos), mostramos un contenedor vacio.
        if (query.isEmpty && (!snapshot.hasData || snapshot.data!.isEmpty)) {
          return Container();
        }

        // Muestra el indicador solo si estamos esperando y hay una búsqueda activa
        if (snapshot.connectionState == ConnectionState.waiting &&
            query.isNotEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Si no hay datos o la lista está vacía (y el query no está vacío), ndica que no hay resultados.
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          if (query.isEmpty) return Container(); // Ya manejado arriba
          return Center(
            child: Text('No se encontraron resultados para "$query"'),
          );
        }

        final List<Movie> movies = snapshot.data as List<Movie>;

        return ListView.separated(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                // Guardamos el query actual ANTES de cerrar
                // Es buena idea hacerlo aquí también por si acaso.
                final container = ProviderScope.containerOf(
                  context,
                  listen: false,
                );
                container
                    .read(searchQueryProvider.notifier)
                    .updateSearchQuery(query);
                clearStreams();
                close(context, movie);
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey[300], // Color gris claro
              thickness: 1.0, // Grosor de la línea
              height: 1.0, // Espaciado vertical alrededor del separador
            );
          },
        );
      },
    );
  }
}

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
                    borderRadius: BorderRadius.circular(20),
                    child:
                        movie.posterPath == 'no-poster'
                            ? Image.asset(
                              'assets/images/no_poster.jpg',
                              fit: BoxFit.cover,
                            )
                            : Image.network(
                              movie.posterPath,
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      FadeIn(child: child),
                            ),
                  ),

                  // Release Date
                  Text(
                    '${movie.releaseDate?.year ?? "No disponible"}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Descrition
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium),

                  // Overview
                  (movie.overview.length > 100)
                      ? Text(
                        '${movie.overview.substring(0, 100)}...',
                        style: textStyle.titleSmall,
                      )
                      : Text(movie.overview, style: textStyle.titleSmall),

                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      Text(
                        HumanFormats.humanReadbleNumber(
                          movie.voteAverage,
                          decimalDigits: 1,
                        ),
                        style: textStyle.bodyMedium!.copyWith(
                          color: Colors.yellow.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
