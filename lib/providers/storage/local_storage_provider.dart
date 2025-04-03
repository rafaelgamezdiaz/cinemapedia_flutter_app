import 'package:cinemapedia/infrastructure/datasource/local_storage_isar_datasource_implementation.dart';
import 'package:cinemapedia/infrastructure/repositories/local_storage_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_storage_provider.g.dart';

// Este provider simplemente expone la instancia del repositorio.
// El estado de este provider *es* el repositorio mismo.
@Riverpod(keepAlive: true)
LocalStorageRepositoryImplementation localStorageRepository(Ref ref) {
  // Devuelve la implementación concreta de tu repositorio.
  // Riverpod se encargará de instanciarla una vez y proporcionarla donde se necesite.
  return LocalStorageRepositoryImplementation(
    localStorageDataSource: LocalStorageIsarDatasourceImplementation(),
  );
}
