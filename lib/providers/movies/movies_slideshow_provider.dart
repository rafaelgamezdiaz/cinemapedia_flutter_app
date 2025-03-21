import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/movies/movies_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_slideshow_provider.g.dart';

@riverpod
List<Movie> slideshowMovies(ref) {
  final nowPlayingMovies = ref.watch(moviesNotifierProvider);
  return (nowPlayingMovies.isEmpty) ? [] : nowPlayingMovies.sublist(0, 8);
}
