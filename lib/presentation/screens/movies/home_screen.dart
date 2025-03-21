import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
    ref.read(moviesNotifierProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(moviesNotifierProvider);
    final moviesSlideShow = ref.watch(slideshowMoviesProvider);

    if (moviesSlideShow.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        CustomAppbar(),
        MoviesSlideshow(movies: moviesSlideShow),
        MoviesHorizontalListview(
          movies: nowPlayingMovies,
          title: 'En Cines',
          subtitle: 'Lunes 24',
        ),
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
  }
}
