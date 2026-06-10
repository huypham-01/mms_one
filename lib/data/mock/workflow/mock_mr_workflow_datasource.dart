import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../data/models/mr_workflow_item_model.dart';
import '../../../data/models/mr_workflow_response_model.dart';
import '../../../data/models/workflow_report_model.dart';

class MockMrWorkflowDataSource {
  static final Map<String, List<MrWorkflowItemModel>> _mockDataByStep = {};
  static final Map<String, WorkflowReportModel> _mockReportDetails = {};

  Future<MrWorkflowResponseModel> getByStep({
    required String step,
    int page = 1,
    int pageSize = 20,
  }) async {
    debugPrint('[Mock] MockMrWorkflowDataSource getByStep called (step: $step, page: $page)');

    // Giả lập delay mạng
    await Future.delayed(const Duration(milliseconds: 600));

    if (!_mockDataByStep.containsKey(step)) {
      _mockDataByStep[step] = _generateMockData(step, 45);
    }

    final data = _mockDataByStep[step]!;
    final int startIndex = (page - 1) * pageSize;
    int endIndex = startIndex + pageSize;

    if (startIndex >= data.length) {
      return MrWorkflowResponseModel(
        success: true,
        step: step,
        currentPage: page,
        lastPage: (data.length / pageSize).ceil(),
        total: data.length,
        perPage: pageSize,
        data: [],
      );
    }

    if (endIndex > data.length) {
      endIndex = data.length;
    }

    final paginatedData = data.sublist(startIndex, endIndex);

    return MrWorkflowResponseModel(
      success: true,
      step: step,
      currentPage: page,
      lastPage: (data.length / pageSize).ceil(),
      total: data.length,
      perPage: pageSize,
      data: paginatedData,
    );
  }

  Future<WorkflowReportModel?> getReportDetail(String id, String step) async {
    debugPrint('[Mock] MockMrWorkflowDataSource getReportDetail called (id: $id, step: $step)');

    await Future.delayed(const Duration(milliseconds: 500));

    final cacheKey = '${id}_$step';
    if (!_mockReportDetails.containsKey(cacheKey)) {
      _mockReportDetails[cacheKey] = _generateMockReportDetail(id, step);
    }

    return _mockReportDetails[cacheKey];
  }

  static List<MrWorkflowItemModel> _generateMockData(String step, int count) {
    final random = Random();
    final materials = ['PBT毛', 'OPP袋', 'RPET膠片', '外箱', '標貼', 'ABS Resin'];
    final units = ['PCS', 'KG', 'ROLL', 'BOX'];
    
    // Status depends on the step roughly
    final statuses = ['PENDING CONFIRM', 'IN PROGRESS', 'COMPLETED'];

    return List.generate(count, (index) {
      final now = DateTime.now().subtract(Duration(hours: random.nextInt(48)));
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      
      final reqNumber = 'MR-${DateTime.now().year}${now.month.toString().padLeft(2, '0')}-${(index + 100).toString().padLeft(4, '0')}';

      return MrWorkflowItemModel(
        id: 'mock-workflow-id-$step-$index',
        batchId: 'BCH-${1000 + index}',
        requestStatus: 'OPEN',
        requestDate: formattedDate,
        requestNumber: reqNumber,
        workOrder: 'WO-${20000 + index}',
        demandWk: 'WK${now.year.toString().substring(2)}${random.nextInt(52).toString().padLeft(2, '0')}',
        pcn: 'PCN-${30000 + index}',
        finishGoodCtn: (random.nextInt(100) + 1).toString(),
        materialPn: 'PN-${40000 + random.nextInt(1000)}',
        materialName: materials[random.nextInt(materials.length)],
        requestQuantity: (random.nextInt(1000) + 50).toString(),
        unit: units[random.nextInt(units.length)],
        isBlockedMissingMaster: random.nextDouble() > 0.9,
        currentStep: step,
        currentStatus: statuses[random.nextInt(statuses.length)],
        isOvertime: random.nextDouble() > 0.8,
        daysSinceOpen: random.nextDouble() * 5,
        isRejected: false,
      );
    });
  }

  static WorkflowReportModel _generateMockReportDetail(String id, String step) {
    final random = Random();
    final materials = ['PBT毛', 'OPP袋', 'RPET膠片', '外箱', '標貼'];
    final reqNumber = 'MR-MOCK-2026';
    
    return WorkflowReportModel(
      requestId: id,
      batchId: 'BCH-MOCK-1',
      requestNumber: reqNumber,
      requestDate: '2026-06-10 08:00:00',
      workOrder: 'WO-MOCK',
      demandWk: 'WK2624',
      pcn: 'PCN-MOCK',
      finishGoodCtn: '100',
      materialPn: 'PN-MOCK-123',
      materialName: materials[random.nextInt(materials.length)],
      requestQuantity: '500',
      unit: 'PCS',
      requestStatus: 'OPEN',
      stepId: 'step-id-mock',
      stepName: step,
      stepStatus: 'PENDING CONFIRM',
      specCheck: 'OK',
      quantityCheck: 'OK',
      locker: 'Locker A1',
      specPictures: [],
      preparedQuantity: 500,
      difference: 0,
      lots: [
        LotInformationModel(lotName: 'LOT-A-1', quantity: 200),
        LotInformationModel(lotName: 'LOT-A-2', quantity: 300),
      ],
    );
  }
}
