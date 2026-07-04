import '../../core/mock/mock_mode_provider.dart';
import '../../domain/entities/storage_area_entity.dart';
import '../../domain/repositories/storage_area_repository.dart';
import '../datasources/storage_area_remote_datasource.dart';
import '../mock/storage_area/mock_storage_area_datasource.dart';

class StorageAreaRepositoryImpl implements StorageAreaRepository {
  final StorageAreaRemoteDataSource remoteDataSource;
  final MockStorageAreaDataSource mockDataSource;
  final MockModeProvider mockModeProvider;

  StorageAreaRepositoryImpl(
    this.remoteDataSource,
    this.mockDataSource,
    this.mockModeProvider,
  );

  @override
  Future<StorageAreaEntity> getStorageAreas({int page = 1, String? status}) async {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.getStorageAreas(page: page, status: status);
    }
    return remoteDataSource.getStorageAreas(page: page, status: status);
  }
}
