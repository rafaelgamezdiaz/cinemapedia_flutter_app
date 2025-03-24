import 'package:cinemapedia/infrastructure/datasource/actor_datasource_implementation.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_implementation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'actors_repository_provider.g.dart';

// Este repositorio es inmutable
@riverpod
class ActorsRepositoryNotifier extends _$ActorsRepositoryNotifier {
  @override
  ActorRepositoryImplementation build() => ActorRepositoryImplementation(
    actorsDatasource: ActorDatasourceImplementation(),
  );
}
