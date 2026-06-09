import '../entities/overtime_entity.dart';

abstract class OvertimeRepository {
  Future<OvertimePageEntity> getOvertimes({int page = 1});
}
