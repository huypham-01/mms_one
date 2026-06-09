import '../../domain/repositories/mr_request_repository.dart';
import '../datasources/mr_request_remote_datasource.dart';
import '../models/mr_request_response_model.dart';

class MrRequestRepositoryImpl implements MrRequestRepository {
  final MrRequestRemoteDataSource remoteDataSource;

  MrRequestRepositoryImpl(this.remoteDataSource);

  @override
  Future<MrRequestResponseModel> getMrRequests({
    int page = 1,
  }) async {
    return await remoteDataSource.getMrRequests(page: page);
  }
}