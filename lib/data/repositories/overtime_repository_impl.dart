import '../../domain/entities/overtime_entity.dart';
import '../../domain/repositories/overtime_repository.dart';
import '../datasources/overtime_remote_datasource.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  final OvertimeRemoteDataSource remoteDataSource;

  OvertimeRepositoryImpl(this.remoteDataSource);

  @override
  Future<OvertimePageEntity> getOvertimes({int page = 1}) {
    return remoteDataSource.getOvertimes(page: page);
  }
}
