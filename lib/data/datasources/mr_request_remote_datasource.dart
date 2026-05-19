import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/mr_request_response_model.dart';

class MrRequestRemoteDataSource {
  Future<MrRequestResponseModel> getMrRequests({
    int page = 1,
  }) async {
    final url =
        'http://192.168.110.2/web_develop/mms/backend/?c=MrRequest&m=index&page=$page';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return MrRequestResponseModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load material requests');
    }
  }
}