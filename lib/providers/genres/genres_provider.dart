import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/providers/genres/genres_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'genres_provider.g.dart';

@riverpod
class Genres extends _$Genres {
  @override
  Future<List<Genre>> build() async {
    // 1. Obtén la instancia del repositorio usando ref.read o ref.watch
    //    Necesitarás crear un provider para tu GenresRepositoryImplementation
    //    Asumamos que tienes un 'genresRepositoryProvider' en 'repositories_provider.dart'
    final repository = ref.watch(genresRepositoryProvider);

    // 2. Llama al método del repositorio para obtener los géneros
    final List<Genre> genres = await repository.getGenres();

    // 3. Devuelve los géneros. Riverpod manejará el estado (loading, data, error)
    return genres;
  }

  // Future<List<Genre>> loadGenres() async {
  //   final GenreRepositoryImplementation genreRepositoryImplementation =
  //       GenreRepositoryImplementation(
  //         genresDatasource: GenresDatasourceImplementation(),
  //       );

  //   final List<Genre> genres = await genreRepositoryImplementation.getGenres();

  //   state = genres;
  //   return genres;
  // }
}
