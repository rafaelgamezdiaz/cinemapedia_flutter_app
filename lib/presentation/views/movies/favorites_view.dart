import 'package:cinemapedia/providers/favorites/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    super.initState();

    // Cargamos los favoritos
    // ref.read(favoritesMoviesNotifierProvider.notifier).loadInitialFavorites();
    // ref.read(favoritesMoviesNotifierProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = ref.watch(favoritesMoviesNotifierProvider);
    return Scaffold(
      body:
          favoritos.isEmpty
              ? Center(child: Text('No hay favoritos'))
              : ListView.builder(
                itemCount: favoritos.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = favoritos[index];
                  return ListTile(
                    title: Text(movie.title),
                    leading: Image.network(movie.posterPath ?? ''),
                  );
                },
              ),
    );
  }
}
