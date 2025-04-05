import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/providers/movies/popular_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  const PopularView({super.key});

  @override
  PopularViewState createState() => PopularViewState();
}

class PopularViewState extends ConsumerState<PopularView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // Cargar Populares
    ref.read(popularMoviesNotifierProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final popularMovies = ref.watch(popularMoviesNotifierProvider);

    if (popularMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Scaffold(
      body: MovieMasonry(
        loadNextPage:
            () =>
                ref.read(popularMoviesNotifierProvider.notifier).loadNextPage(),
        movies: popularMovies,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
