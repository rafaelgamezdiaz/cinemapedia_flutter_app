import 'package:cinemapedia/providers/movies/movies_providers.dart';
import 'package:cinemapedia/providers/movies/movies_slideshow_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'initial_loading_provider.g.dart';

@riverpod
bool initialLoading(ref) {
  final moviesSlideShow = ref.watch(slideshowMoviesProvider).isEmpty;
  final nowPlayingMoviesLoaded =
      ref.watch(nowPlayingMoviesNotifierProvider).isEmpty;
  final popularMoviesLoaded = ref.watch(popularMoviesNotifierProvider).isEmpty;
  final topRatedMoviesLoaded =
      ref.watch(topRatedMoviesNotifierProvider).isEmpty;
  final upcomingMoviesLoaded =
      ref.watch(upcomingMoviesNotifierProvider).isEmpty;

  return moviesSlideShow ||
      nowPlayingMoviesLoaded ||
      popularMoviesLoaded ||
      topRatedMoviesLoaded ||
      upcomingMoviesLoaded;
}
