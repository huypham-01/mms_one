import '../entities/storage_area_entity.dart';
import '../repositories/storage_area_repository.dart';

class GetStorageAreasUseCase {
  final StorageAreaRepository repository;

  GetStorageAreasUseCase(this.repository);

  Future<StorageAreaEntity> call({
    int page = 1,
    String? status,
  }) async {
    return repository.getStorageAreas(page: page, status: status);
  }
}
