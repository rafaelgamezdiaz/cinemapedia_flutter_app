// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_movies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchQueryHash() => r'c38af781059d09952db3d222d4ccb555ffd9b4ca';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$searchedMoviesHash() => r'c32f9349ed6462ed2d25fb026729a60fe22851f8';

/// See also [SearchedMovies].
@ProviderFor(SearchedMovies)
final searchedMoviesProvider =
    AutoDisposeNotifierProvider<SearchedMovies, List<Movie>>.internal(
  SearchedMovies.new,
  name: r'searchedMoviesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchedMovies = AutoDisposeNotifier<List<Movie>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
