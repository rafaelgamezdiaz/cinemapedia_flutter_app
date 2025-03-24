import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_detail_provider.g.dart';

typedef MovieDetaiCallback = Future<Movie> Function(String movieId);

@riverpod
class MovieMapNotifier extends _$MovieMapNotifier {
  late final MovieDetaiCallback getMovieDetail;

  // Constructor por defecto
  MovieMapNotifier();

  // Método para inicializar el callback
  void initialize(MovieDetaiCallback callback) {
    getMovieDetail = callback;
  }

  @override
  Map<String, Movie> build() {
    return <String, Movie>{};
  }

  Future<void> loadMovieDetail(String movieId) async {
    if (state.containsKey(movieId)) return;

    final Movie movie = await getMovieDetail(movieId);
    state = {...state, movieId: movie};
  }
}

@riverpod
Future<Movie> movieDetail(ref, String movieId) async {
  // Obtener el notifier del MovieMapNotifier
  final movieMapNotifier = ref.read(movieMapNotifierProvider.notifier);

  // Obtener el repositorio para hacer la petición HTTP
  final moviesRepository = ref.read(moviesRepositoryNotifierProvider);

  // Intentar obtener la película del mapa
  if (movieMapNotifier.state.containsKey(movieId)) {
    return movieMapNotifier.state[movieId]!;
  }

  // Si no está en el mapa, cargarla usando el repositorio
  final Movie movie = await moviesRepository.getMovieDetail(movieId);

  // Actualizar el mapa con la película cargada
  movieMapNotifier.state = Map<String, Movie>.from(movieMapNotifier.state)
    ..[movieId] = movie;

  // Devolver la película
  return movie;
}
