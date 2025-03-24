// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actors_by_movie_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$actorsHash() => r'846d79d77a0eb0e6e0ebc93141b70e603c3a3ea0';

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

/// See also [actors].
@ProviderFor(actors)
const actorsProvider = ActorsFamily();

/// See also [actors].
class ActorsFamily extends Family<AsyncValue<List<Actor>>> {
  /// See also [actors].
  const ActorsFamily();

  /// See also [actors].
  ActorsProvider call(String movieId) {
    return ActorsProvider(movieId);
  }

  @override
  ActorsProvider getProviderOverride(covariant ActorsProvider provider) {
    return call(provider.movieId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'actorsProvider';
}

/// See also [actors].
class ActorsProvider extends AutoDisposeFutureProvider<List<Actor>> {
  /// See also [actors].
  ActorsProvider(String movieId)
    : this._internal(
        (ref) => actors(ref as ActorsRef, movieId),
        from: actorsProvider,
        name: r'actorsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$actorsHash,
        dependencies: ActorsFamily._dependencies,
        allTransitiveDependencies: ActorsFamily._allTransitiveDependencies,
        movieId: movieId,
      );

  ActorsProvider._internal(
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
  Override overrideWith(
    FutureOr<List<Actor>> Function(ActorsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActorsProvider._internal(
        (ref) => create(ref as ActorsRef),
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
  AutoDisposeFutureProviderElement<List<Actor>> createElement() {
    return _ActorsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActorsProvider && other.movieId == movieId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movieId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActorsRef on AutoDisposeFutureProviderRef<List<Actor>> {
  /// The parameter `movieId` of this provider.
  String get movieId;
}

class _ActorsProviderElement
    extends AutoDisposeFutureProviderElement<List<Actor>>
    with ActorsRef {
  _ActorsProviderElement(super.provider);

  @override
  String get movieId => (origin as ActorsProvider).movieId;
}

String _$actorsMapNotifierHash() => r'f28ca3cf8b5369a9db584f93b2e00634636cd9d4';

/// See also [ActorsMapNotifier].
@ProviderFor(ActorsMapNotifier)
final actorsMapNotifierProvider = AutoDisposeNotifierProvider<
  ActorsMapNotifier,
  Map<String, List<Actor>>
>.internal(
  ActorsMapNotifier.new,
  name: r'actorsMapNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$actorsMapNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActorsMapNotifier = AutoDisposeNotifier<Map<String, List<Actor>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
