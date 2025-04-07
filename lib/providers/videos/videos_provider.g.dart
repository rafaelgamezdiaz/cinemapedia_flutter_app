// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videosHash() => r'823fe8f62fb9ca7c267ad0f0d7d57ab0ac3edf0e';

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

abstract class _$Videos extends BuildlessAutoDisposeAsyncNotifier<List<Video>> {
  late final String movieId;

  Future<List<Video>> build(
    String movieId,
  );
}

/// See also [Videos].
@ProviderFor(Videos)
const videosProvider = VideosFamily();

/// See also [Videos].
class VideosFamily extends Family<AsyncValue<List<Video>>> {
  /// See also [Videos].
  const VideosFamily();

  /// See also [Videos].
  VideosProvider call(
    String movieId,
  ) {
    return VideosProvider(
      movieId,
    );
  }

  @override
  VideosProvider getProviderOverride(
    covariant VideosProvider provider,
  ) {
    return call(
      provider.movieId,
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
  String? get name => r'videosProvider';
}

/// See also [Videos].
class VideosProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Videos, List<Video>> {
  /// See also [Videos].
  VideosProvider(
    String movieId,
  ) : this._internal(
          () => Videos()..movieId = movieId,
          from: videosProvider,
          name: r'videosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videosHash,
          dependencies: VideosFamily._dependencies,
          allTransitiveDependencies: VideosFamily._allTransitiveDependencies,
          movieId: movieId,
        );

  VideosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movieId,
  }) : super.internal();

  final String movieId;

  @override
  Future<List<Video>> runNotifierBuild(
    covariant Videos notifier,
  ) {
    return notifier.build(
      movieId,
    );
  }

  @override
  Override overrideWith(Videos Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideosProvider._internal(
        () => create()..movieId = movieId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movieId: movieId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Videos, List<Video>> createElement() {
    return _VideosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideosProvider && other.movieId == movieId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movieId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VideosRef on AutoDisposeAsyncNotifierProviderRef<List<Video>> {
  /// The parameter `movieId` of this provider.
  String get movieId;
}

class _VideosProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Videos, List<Video>>
    with VideosRef {
  _VideosProviderElement(super.provider);

  @override
  String get movieId => (origin as VideosProvider).movieId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
