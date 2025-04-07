import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    // Cargar Now Playing
    ref.read(nowPlayingMoviesNotifierProvider.notifier).loadNextPage();
    // Cargar Populares
    ref.read(popularMoviesNotifierProvider.notifier).loadNextPage();
    // Cargar Populares
    ref.read(topRatedMoviesNotifierProvider.notifier).loadNextPage();
    // Cargar Proximos Estrenos
    ref.read(upcomingMoviesNotifierProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final loadingMovies = ref.watch(initialLoadingProvider);
    if (loadingMovies) return const FullScreenLoader();

    // Obtener listas separadas
    final nowPlayingMovies = ref.watch(nowPlayingMoviesNotifierProvider);
    final topRatedMovies = ref.watch(topRatedMoviesNotifierProvider);
    final upcomingMovies = ref.watch(upcomingMoviesNotifierProvider);
    final moviesSlideShow = ref.watch(slideshowMoviesProvider);
    final popularMovies = ref.watch(popularMoviesNotifierProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                SizedBox(height: 15),
                // Movies Slideshow
                MoviesSlideshow(movies: moviesSlideShow),

                SizedBox(height: 10),

                // Now Playing Movies
                MoviesHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En Cines',
                  loadNextPage:
                      () =>
                          ref
                              .read(nowPlayingMoviesNotifierProvider.notifier)
                              .loadNextPage(),
                ),
                SizedBox(height: 20),

                // Now Playing Movies
                MoviesHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  loadNextPage:
                      () =>
                          ref
                              .read(popularMoviesNotifierProvider.notifier)
                              .loadNextPage(),
                ),
                SizedBox(height: 20),

                // Top Rated Movies
                MoviesHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Top Rated',
                  // subtitle: 'Eternamente',
                  loadNextPage:
                      () =>
                          ref
                              .read(topRatedMoviesNotifierProvider.notifier)
                              .loadNextPage(),
                ),
                SizedBox(height: 20),

                // Upcoming Movies
                MoviesHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Próximamente',
                  loadNextPage:
                      () =>
                          ref
                              .read(upcomingMoviesNotifierProvider.notifier)
                              .loadNextPage(),
                ),

                SizedBox(height: 20),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
