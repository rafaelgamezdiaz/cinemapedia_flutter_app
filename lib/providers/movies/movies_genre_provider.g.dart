// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_genre_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$moviesGenreNotifierHash() =>
    r'09dcc8283cb3618e91d58ba7129507df8c2c3326';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MoviesGenreNotifier
    extends BuildlessAutoDisposeNotifier<List<Movie>> {
  late final String genreId;

  List<Movie> build(
    String genreId,
  );
}

/// See also [MoviesGenreNotifier].
@ProviderFor(MoviesGenreNotifier)
const moviesGenreNotifierProvider = MoviesGenreNotifierFamily();

/// See also [MoviesGenreNotifier].
class MoviesGenreNotifierFamily extends Family<List<Movie>> {
  /// See also [MoviesGenreNotifier].
  const MoviesGenreNotifierFamily();

  /// See also [MoviesGenreNotifier].
  MoviesGenreNotifierProvider call(
    String genreId,
  ) {
    return MoviesGenreNotifierProvider(
      genreId,
    );
  }

  @override
  MoviesGenreNotifierProvider getProviderOverride(
    covariant MoviesGenreNotifierProvider provider,
  ) {
    return call(
      provider.genreId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'moviesGenreNotifierProvider';
}

/// See also [MoviesGenreNotifier].
class MoviesGenreNotifierProvider
    extends AutoDisposeNotifierProviderImpl<MoviesGenreNotifier, List<Movie>> {
  /// See also [MoviesGenreNotifier].
  MoviesGenreNotifierProvider(
    String genreId,
  ) : this._internal(
          () => MoviesGenreNotifier()..genreId = genreId,
          from: moviesGenreNotifierProvider,
          name: r'moviesGenreNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$moviesGenreNotifierHash,
          dependencies: MoviesGenreNotifierFamily._dependencies,
          allTransitiveDependencies:
              MoviesGenreNotifierFamily._allTransitiveDependencies,
          genreId: genreId,
        );

  MoviesGenreNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genreId,
  }) : super.internal();

  final String genreId;

  @override
  List<Movie> runNotifierBuild(
    covariant MoviesGenreNotifier notifier,
  ) {
    return notifier.build(
      genreId,
    );
  }

  @override
  Override overrideWith(MoviesGenreNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MoviesGenreNotifierProvider._internal(
        () => create()..genreId = genreId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genreId: genreId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MoviesGenreNotifier, List<Movie>>
      createElement() {
    return _MoviesGenreNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MoviesGenreNotifierProvider && other.genreId == genreId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genreId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MoviesGenreNotifierRef on AutoDisposeNotifierProviderRef<List<Movie>> {
  /// The parameter `genreId` of this provider.
  String get genreId;
}

class _MoviesGenreNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<MoviesGenreNotifier, List<Movie>>
    with MoviesGenreNotifierRef {
  _MoviesGenreNotifierProviderElement(super.provider);

  @override
  String get genreId => (origin as MoviesGenreNotifierProvider).genreId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
