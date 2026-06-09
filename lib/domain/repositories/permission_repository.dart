import '../entities/permission_entity.dart';

abstract class PermissionRepository {
  Future<Set<String>> getMyPermissions();
}
