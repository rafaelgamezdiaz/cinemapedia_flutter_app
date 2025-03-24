import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      //  backgroundColor: const Color.fromARGB(255, 75, 83, 156),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
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
    final loadingMovies = ref.watch(initialLoadingProvider);
    if (loadingMovies) return FullScreenLoader();

    // Obtener listas separadas
    final nowPlayingMovies = ref.watch(nowPlayingMoviesNotifierProvider);
    final popularMovies = ref.watch(popularMoviesNotifierProvider);
    final topRatedMovies = ref.watch(topRatedMoviesNotifierProvider);
    final upcomingMovies = ref.watch(upcomingMoviesNotifierProvider);
    final moviesSlideShow = ref.watch(slideshowMoviesProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
          backgroundColor: Colors.white,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                SizedBox(height: 10),
                // Movies Slideshow
                MoviesSlideshow(movies: moviesSlideShow),

                // Now Playing Movies
                MoviesHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En Cines',
                  subtitle: 'Lunes 24',
                  loadNextPage:
                      () =>
                          ref
                              .read(nowPlayingMoviesNotifierProvider.notifier)
                              .loadNextPage(),
                ),

                // Popular Movies
                MoviesHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  // subtitle: 'Este mes',
                  loadNextPage:
                      () =>
                          ref
                              .read(popularMoviesNotifierProvider.notifier)
                              .loadNextPage(),
                ),

                // Top Rated Movies
                MoviesHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Top Rated',
                  subtitle: 'Eternamente',
                  loadNextPage:
                      () =>
                          ref
                              .read(topRatedMoviesNotifierProvider.notifier)
                              .loadNextPage(),
                ),

                // Upcoming Movies
                MoviesHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Próximamente',
                  subtitle: 'En semanas',
                  loadNextPage:
                      () =>
                          ref
                              .read(upcomingMoviesNotifierProvider.notifier)
                              .loadNextPage(),
                ),

                SizedBox(height: 20),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: nowPlayingMovies.length,
                //     itemBuilder: (context, index) {
                //       final movie = nowPlayingMovies[index];

                //       // Mostrar la película correspondiente
                //       return ListTile(title: Text(movie.title));
                //     },
                //   ),
                // ),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
