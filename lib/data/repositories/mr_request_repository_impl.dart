import 'package:flutter/foundation.dart';
import '../../domain/repositories/mr_request_repository.dart';
import '../datasources/mr_request_remote_datasource.dart';
import '../mock/material_request/mock_material_request_datasource.dart';
import '../models/mr_request_response_model.dart';
import '../../core/mock/mock_mode_provider.dart';

class MrRequestRepositoryImpl implements MrRequestRepository {
  final MrRequestRemoteDataSource remoteDataSource;
  final MockMaterialRequestDataSource mockDataSource;
  final MockModeProvider mockModeProvider;

  MrRequestRepositoryImpl(
    this.remoteDataSource,
    this.mockDataSource,
    this.mockModeProvider,
  );

  @override
  Future<MrRequestResponseModel> getMrRequests({
    int page = 1,
  }) async {
    if (mockModeProvider.isMockMode) {
      debugPrint('[Mock] MaterialRequestRepository using MOCK source');
      return await mockDataSource.getMrRequests(page: page);
    }
    return await remoteDataSource.getMrRequests(page: page);
  }
}