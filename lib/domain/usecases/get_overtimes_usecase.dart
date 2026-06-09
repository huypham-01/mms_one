import '../entities/overtime_entity.dart';
import '../repositories/overtime_repository.dart';

class GetOvertimesUseCase {
  final OvertimeRepository repository;

  GetOvertimesUseCase(this.repository);

  Future<OvertimePageEntity> call({int page = 1}) {
    return repository.getOvertimes(page: page);
  }
}
