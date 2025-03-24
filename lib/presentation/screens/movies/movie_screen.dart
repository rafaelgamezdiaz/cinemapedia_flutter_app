import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
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

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ],
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(color: Colors.white, fontSize: 18),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return FadeIn(child: child);
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.8, 1.0],
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
            ),
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.0, 0.2],
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
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
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                  height: size.height * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),

              // Description
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleLarge),
                    const SizedBox(height: 10),
                    Text(movie.overview),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Mostrar Géneros
        Padding(
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
        ),

        // Mostrar Actores
        _ActorsByMovie(movieId: movie.id),

        SizedBox(height: 20),
      ],
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
