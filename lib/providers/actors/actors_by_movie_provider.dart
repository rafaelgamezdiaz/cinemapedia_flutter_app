import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/providers/actors/actors_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'actors_by_movie_provider.g.dart';

typedef ActorCallback = Future<List<Actor>> Function(String movieId);

@riverpod
class ActorsMapNotifier extends _$ActorsMapNotifier {
  late final ActorCallback getActors;

  // Constructor por defecto
  ActorsMapNotifier();

  // Método para inicializar el callback
  void initialize(ActorCallback callback) {
    getActors = callback;
  }

  @override
  Map<String, List<Actor>> build() {
    return <String, List<Actor>>{};
  }

  Future<void> loadActors(String movieId) async {
    if (state.containsKey(movieId)) return;

    final List<Actor> actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}

@riverpod
Future<List<Actor>> actors(ref, String movieId) async {
  // Obtener el notifier del ActorMapNotifier
  final actorsMapNotifier = ref.read(actorsMapNotifierProvider.notifier);

  // Obtener el repositorio para hacer la petición HTTP
  final actorsRepository = ref.read(actorsRepositoryNotifierProvider);

  // Intentar obtener la lista de actores del mapa
  if (actorsMapNotifier.state.containsKey(movieId)) {
    return actorsMapNotifier.state[movieId]!;
  }

  // Si no está en el mapa, cargarla usando el repositorio
  final List<Actor> actors = await actorsRepository.getActorsByMovie(movieId);

  // Actualizar el mapa con la lista de actores cargada
  actorsMapNotifier.state = Map<String, List<Actor>>.from(
    actorsMapNotifier.state,
  )..[movieId] = actors;

  // Devolver la lista de actores
  return actors;
}
