import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
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
                  final searchedMovies = ref.read(searchedMoviesProvider);
                  final lastSearchQuery = ref.read(searchQueryProvider);
                  final searchDelegate = SearchMovieDelegate(
                    searchMovie:
                        ref
                            .read(searchedMoviesProvider.notifier)
                            .searchMoviesByQuery,
                    initialQuery: lastSearchQuery,
                    initialMovies: searchedMovies,
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
