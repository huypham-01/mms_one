import '../repositories/permission_repository.dart';

class GetMyPermissionsUseCase {
  final PermissionRepository repository;

  GetMyPermissionsUseCase(this.repository);

  Future<Set<String>> call() async {
    return await repository.getMyPermissions();
  }
}
