import 'package:cinemapedia/domain/datasources/genres_datasource.dart';
import 'package:cinemapedia/domain/repositories/genres_repository.dart';
import 'package:cinemapedia/infrastructure/datasource/genres_datasource_implementation.dart';
import 'package:cinemapedia/infrastructure/repositories/genre_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'genres_repository_provider.g.dart';

// Provider que crea la instancia del Datasource
@riverpod
GenresDatasource genresDatasource(Ref ref) {
  return GenresDatasourceImplementation();
}

// Provider que crea la instancia del Repository, inyectando el Datasource
@riverpod
GenresRepository genresRepository(Ref ref) {
  // Obtiene la instancia del datasource usando el provider anterior
  final genresDatasource = ref.watch(genresDatasourceProvider);
  return GenreRepositoryImplementation(genresDatasource: genresDatasource);
}
