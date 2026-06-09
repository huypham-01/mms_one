import '../../domain/repositories/permission_repository.dart';
import '../datasources/permission_remote_datasource.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionRemoteDataSource remoteDataSource;

  PermissionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Set<String>> getMyPermissions() async {
    return await remoteDataSource.getMyPermissions();
  }
}
