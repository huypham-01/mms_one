import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../data/models/mr_request_model.dart';
import '../../../data/models/mr_request_response_model.dart';

class MockMaterialRequestDataSource {
  static final List<MrRequestModel> _mockData = _generateMockData(50);

  Future<MrRequestResponseModel> getMrRequests({
    int page = 1,
    int pageSize = 20,
  }) async {
    debugPrint('[Mock] MockMaterialRequestDataSource getMrRequests called (page: $page)');

    // Giả lập delay mạng
    await Future.delayed(const Duration(milliseconds: 800));

    final int startIndex = (page - 1) * pageSize;
    int endIndex = startIndex + pageSize;

    if (startIndex >= _mockData.length) {
      return MrRequestResponseModel(
        currentPage: page,
        lastPage: (_mockData.length / pageSize).ceil(),
        total: _mockData.length,
        data: [],
      );
    }

    if (endIndex > _mockData.length) {
      endIndex = _mockData.length;
    }

    final paginatedData = _mockData.sublist(startIndex, endIndex);

    return MrRequestResponseModel(
      currentPage: page,
      lastPage: (_mockData.length / pageSize).ceil(),
      total: _mockData.length,
      data: paginatedData,
    );
  }

  static List<MrRequestModel> _generateMockData(int count) {
    final random = Random();
    final statuses = ['OPEN', 'IN PROGRESS', 'PENDING CONFIRM', 'COMPLETED', 'REJECTED'];
    final steps = ['Planner', 'Preparer', 'Warehouse', 'Receiver', 'Leader', 'Production'];
    final materials = ['PBT毛', 'OPP袋', 'RPET膠片', '外箱', '標貼'];
    final units = ['PCS', 'KG', 'ROLL', 'BOX'];

    return List.generate(count, (index) {
      final now = DateTime.now().subtract(Duration(hours: random.nextInt(72)));
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      
      final reqNumber = 'MR-${DateTime.now().year}${now.month.toString().padLeft(2, '0')}-${(index + 1).toString().padLeft(4, '0')}';

      return MrRequestModel(
        id: 'mock-id-$index',
        requestNumber: reqNumber,
        requestStatus: statuses[random.nextInt(statuses.length)],
        requestDate: formattedDate,
        workOrder: 'WO-${10000 + index}',
        demandWk: 'WK${now.year.toString().substring(2)}${random.nextInt(52).toString().padLeft(2, '0')}',
        pcn: 'PCN-${20000 + index}',
        finishGoodCtn: (random.nextInt(50) + 1).toString(),
        materialPn: 'PN-${30000 + random.nextInt(1000)}',
        materialName: materials[random.nextInt(materials.length)],
        requestQuantity: (random.nextInt(500) + 10).toString(),
        unit: units[random.nextInt(units.length)],
        currentStatus: statuses[random.nextInt(statuses.length)],
        currentStep: steps[random.nextInt(steps.length)],
      );
    });
  }
}
