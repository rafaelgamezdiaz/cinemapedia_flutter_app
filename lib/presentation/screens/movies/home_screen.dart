import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/providers/movies/movies_providers.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _HomeView());
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

    if (nowPlayingMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        CustomAppbar(),
        MoviesSlideshow(movies: nowPlayingMovies),
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
