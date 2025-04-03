import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/providers/favorites/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Cargamos los favoritos
    // ref.read(favoritesMoviesNotifierProvider.notifier).loadInitialFavorites();
    // ref.read(favoritesMoviesNotifierProvider.notifier).loadNextPage();

    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;
    final movies =
        await ref.read(favoritesMoviesNotifierProvider.notifier).loadNextPage();
    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = ref.watch(favoritesMoviesNotifierProvider);
    return Scaffold(
      body: MovieMasonry(loadNextPage: loadNextPage, movies: favoritos),
    );
  }
}
