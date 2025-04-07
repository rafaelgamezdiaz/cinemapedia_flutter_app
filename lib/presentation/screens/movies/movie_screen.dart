import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_videos.dart';
import 'package:cinemapedia/providers/movies/movie_detail_provider.dart';
import 'package:cinemapedia/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const String name = 'movie-screen';

  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  Widget build(BuildContext context) {
    final movieAsync = ref.watch(movieDetailProvider(widget.movieId));

    return Scaffold(
      body: movieAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data:
            (movie) => CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                _CustomSliverAppBar(movie: movie),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _MovieDetails(movie: movie),
                    childCount: 1,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    return SliverAppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.pop();
          },
        ),
        IconButton(
          onPressed: () async {
            // Llama al método toggleFavorite del notifier de la *lista*
            // Este método se encarga de:
            // 1. Llamar al repositorio para guardar/borrar en la BD.
            // 2. Actualizar el estado (la lista) del FavoritesMoviesNotifier.
            // 3. Invalidar isFavoriteProvider(movie.id) para actualizar el icono aquí.
            await ref
                .read(favoritesMoviesNotifierProvider.notifier)
                .toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            loading: () => CircularProgressIndicator(strokeWidth: 2),
            data:
                (isFavorite) =>
                    isFavorite
                        ? const Icon(Icons.favorite_rounded, color: Colors.red)
                        : const Icon(Icons.favorite_border),
            error:
                (_, __) => const Icon(Icons.error_outline, color: Colors.red),
          ),
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          context.pop();
        },
      ),
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child:
                  (movie.posterPath != null)
                      ? Image.network(
                        movie.posterPath!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return FadeIn(child: child);
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                      : SizedBox.expand(),
            ),

            _CustomGradient(
              beginPosition: Alignment.topCenter,
              endPosition: Alignment.bottomCenter,
              stops: [0.9, 1.0],
              colors: [Colors.transparent, Colors.black45],
            ),
            _CustomGradient(
              beginPosition: Alignment.topRight,
              endPosition: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [Colors.black87, Colors.transparent],
            ),
            _CustomGradient(
              beginPosition: Alignment.topLeft,
              endPosition: Alignment.bottomRight,
              stops: [0.0, 0.2],
              colors: [Colors.black87, Colors.transparent],
            ),
          ],
        ),
        // background: Image.network(movie.backdropPath, fit: BoxFit.cover),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titulo, Descripcion, Rating
        _TitleAndOverview(movie: movie, size: size, textStyle: textStyle),

        // Mostrar Géneros
        _Genres(movie: movie),

        // Mostrar Actores
        _ActorsByMovie(movieId: movie.id),

        MovieVideos(movieId: movie.id),

        SizedBox(height: 140),
      ],
    );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({
    required this.movie,
    required this.size,
    required this.textStyle,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                (movie.posterPath != null)
                    ? Image.network(
                      movie.posterPath!,
                      width: size.width * 0.3,
                      height: size.height * 0.3,
                      fit: BoxFit.cover,
                    )
                    : SizedBox.expand(),
          ),
          const SizedBox(width: 10),

          // Description
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyle.titleLarge),
                Text("(${movie.originalTitle})", style: textStyle.bodySmall),
                const SizedBox(height: 10),
                Text(movie.overview),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 10,
        children:
            movie.genreIds
                .map(
                  (genre) => Chip(
                    label: Text(genre),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final int movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsAsync = ref.watch(actorsProvider(movieId.toString()));

    return actorsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (actors) {
        if (actors.isEmpty) {
          return const SizedBox.shrink(); // No ocupa espacio si no hay actores
        } else {
          return SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: actors.length,
              itemBuilder: (context, index) {
                final actor = actors[index];
                return Container(
                  padding: const EdgeInsets.all(8),
                  width: 135,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Actor photo
                      FadeInRight(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child:
                              (actor.profilePath != 'no-photo')
                                  ? Image.network(
                                    actor.profilePath,
                                    height: 180,
                                    width: 135,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.asset(
                                    'assets/images/user.png',
                                    height: 180,
                                    width: 135,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Actor name
                      Text(actor.name, maxLines: 2),
                      Text(
                        actor.character ?? '',
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry beginPosition;
  final AlignmentGeometry endPosition;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.beginPosition,
    required this.endPosition,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: beginPosition,
            end: endPosition,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
