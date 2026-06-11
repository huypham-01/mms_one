import '../../core/mock/mock_mode_provider.dart';
import '../../domain/entities/overtime_entity.dart';
import '../../domain/repositories/overtime_repository.dart';
import '../datasources/overtime_remote_datasource.dart';
import '../mock/overtime/mock_overtime_datasource.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  final OvertimeRemoteDataSource remoteDataSource;
  final MockOvertimeDataSource mockDataSource;
  final MockModeProvider mockModeProvider;

  OvertimeRepositoryImpl(
    this.remoteDataSource,
    this.mockDataSource,
    this.mockModeProvider,
  );

  @override
  Future<OvertimePageEntity> getOvertimes({int page = 1}) {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.getOvertimes(page: page);
    }
    return remoteDataSource.getOvertimes(page: page);
  }
}
