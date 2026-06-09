import '../../core/network/api_client.dart';
import '../models/mr_request_response_model.dart';

class MrRequestRemoteDataSource {
  final ApiClient _apiClient;

  MrRequestRemoteDataSource(this._apiClient);

  Future<MrRequestResponseModel> getMrRequests({int page = 1}) async {
    final response = await _apiClient.get(
      '?c=MrRequest&m=index&page=$page',
    );
    
    return MrRequestResponseModel.fromJson(response.data);
  }
}