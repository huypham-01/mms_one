import '../../data/models/mr_request_response_model.dart';
import '../repositories/mr_request_repository.dart';

class GetMrRequestsUseCase {
  final MrRequestRepository repository;

  GetMrRequestsUseCase(this.repository);

  Future<MrRequestResponseModel> call({
    int page = 1,
  }) async {
    return await repository.getMrRequests(page: page);
  }
}