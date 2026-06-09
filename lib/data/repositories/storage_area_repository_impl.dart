import '../../domain/entities/storage_area_entity.dart';
import '../../domain/repositories/storage_area_repository.dart';
import '../datasources/storage_area_remote_datasource.dart';

class StorageAreaRepositoryImpl implements StorageAreaRepository {
  final StorageAreaRemoteDataSource remoteDataSource;

  StorageAreaRepositoryImpl(this.remoteDataSource);

  @override
  Future<StorageAreaEntity> getStorageAreas({
    int page = 1,
  }) async {
    return remoteDataSource.getStorageAreas(page: page);
  }
}
