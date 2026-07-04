import '../entities/storage_area_entity.dart';

abstract class StorageAreaRepository {
  Future<StorageAreaEntity> getStorageAreas({
    int page = 1,
    String? status,
  });
}
