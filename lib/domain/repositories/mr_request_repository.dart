import '../../data/models/mr_request_response_model.dart';

abstract class MrRequestRepository {
  Future<MrRequestResponseModel> getMrRequests({
    int page,
  });
}