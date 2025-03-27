import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/providers/search/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    ref.watch(searchQueryProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              const SizedBox(width: 5),
              Text('Cinemapedia', style: titleStyle),
              Spacer(),

              // Search Icon Button
              IconButton(
                onPressed: () {
                  final moviesRepositoryNotifier = ref.read(
                    moviesRepositoryNotifierProvider,
                  );

                  // Lee el ÚLTIMO query guardado desde el provider JUSTO ANTES de mostrar
                  // Es mejor usar ref.read aquí porque solo necesitas el valor actual al presionar
                  final lastSearchQuery = ref.read(searchQueryProvider);

                  // Crea el delegate, pasando la función y el query inicial
                  // Es bueno pasar initialQuery al delegate por si lo usas internamente,
                  // aunque el parámetro 'query' de showSearch controlará el texto inicial.
                  final searchDelegate = SearchMovieDelegate(
                    searchMovie: moviesRepositoryNotifier.searchMovies,
                    initialQuery: lastSearchQuery,
                  );

                  showSearch<Movie?>(
                    context: context,
                    delegate: searchDelegate,
                    query:
                        lastSearchQuery, // Pasamos el último query guardado para que aparezca en el campo de texto
                  ).then((movie) {
                    // Verificar si el widget sigue montado
                    if (!context.mounted) return;

                    // Guardamos el último término de búsqueda escrito
                    ref
                        .read(searchQueryProvider.notifier)
                        .updateSearchQuery(searchDelegate.query);

                    // Verifica si se seleccionó una película
                    if (movie == null) return;

                    context.push('/movie/${movie.id}');
                  });
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
