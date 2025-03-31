import 'package:cinemapedia/infrastructure/datasource/local_storage_isar_datasource_implementation.dart';
import 'package:cinemapedia/infrastructure/repositories/local_storage_implementation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_storage_provider.g.dart';

// Este repositorio es inmutable
@riverpod
class LocalStorageNotifier extends _$LocalStorageNotifier {
  @override
  LocalStorageRepositoryImplementation build() =>
      LocalStorageRepositoryImplementation(
        localStorageDataSource: LocalStorageIsarDatasourceImplementation(),
      );
}
