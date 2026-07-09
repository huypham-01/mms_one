import '../../core/network/api_client.dart';
import '../models/mr_request_response_model.dart';

class MrRequestRemoteDataSource {
  final ApiClient _apiClient;

  MrRequestRemoteDataSource(this._apiClient);

  Future<MrRequestResponseModel> getMrRequests({
    int page = 1,
    String? date,
    String? dateFrom,
    String? dateTo,
  }) async {
    final buffer = StringBuffer('?c=MrRequest&m=index&page=$page');

    if (date != null && date.isNotEmpty) {
      buffer.write('&date=$date');
    } else {
      if (dateFrom != null && dateFrom.isNotEmpty) {
        buffer.write('&date_from=$dateFrom');
      }
      if (dateTo != null && dateTo.isNotEmpty) {
        buffer.write('&date_to=$dateTo');
      }
    }

    final response = await _apiClient.get(buffer.toString());
    return MrRequestResponseModel.fromJson(response.data);
  }
}