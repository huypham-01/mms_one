import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../models/overtime_model.dart';

class MockOvertimeDataSource {
  static final List<OvertimeMrModel> _mockItems = _generateMockItems(58);

  Future<OvertimePageModel> getOvertimes({
    int page = 1,
    int pageSize = 20,
  }) async {
    debugPrint('[Mock] MockOvertimeDataSource getOvertimes page=$page');
    await Future.delayed(const Duration(milliseconds: 500));

    final startIndex = (page - 1) * pageSize;
    final endIndex = min(startIndex + pageSize, _mockItems.length);
    final pageItems = startIndex >= _mockItems.length
        ? <OvertimeMrModel>[]
        : _mockItems.sublist(startIndex, endIndex);

    return OvertimePageModel(
      currentPage: page,
      lastPage: (_mockItems.length / pageSize).ceil(),
      total: _mockItems.length,
      perPage: pageSize,
      items: pageItems,
    );
  }

  static List<OvertimeMrModel> _generateMockItems(int count) {
    final random = Random(260610);
    final materials = [
      ('PBT Resin Natural', 'PBT-NAT'),
      ('ABS Resin Black', 'ABS-BLK'),
      ('RPET Film Sheet', 'RPET-FILM'),
      ('OPP Packing Bag', 'OPP-BAG'),
      ('Outer Carton', 'CTN-OUT'),
      ('Carton Label Set', 'LBL-CTN'),
    ];
    final units = ['PCS', 'KG', 'ROLL', 'BOX'];
    final steps = ['preparer', 'warehouse', 'receiver', 'line_leader'];
    final statuses = ['PENDING CONFIRM', 'IN PROGRESS', 'OPEN'];

    return List.generate(count, (index) {
      final material = materials[index % materials.length];
      final overdueDays = 3 + random.nextInt(9);
      final requestDate = DateTime.now().subtract(
        Duration(days: overdueDays + 3, hours: random.nextInt(18)),
      );
      final overtimeAt = requestDate.add(const Duration(days: 3));
      final isRejected = index % 13 == 0;
      final isBlocked = index % 17 == 0;
      final receivedQty = 80 + random.nextInt(700);
      final consumedQty = random.nextInt(receivedQty);

      return OvertimeMrModel(
        id: 'mock-overtime-id-${index + 1}',
        batchId: 'BCH-OT-${(1000 + index).toString()}',
        requestStatus: 'OPEN',
        requestDate: _formatDateTime(requestDate),
        requestNumber:
            'MR-OT-${requestDate.year}${requestDate.month.toString().padLeft(2, '0')}-${(index + 1).toString().padLeft(4, '0')}',
        workOrder: 'WO-${25000 + index}',
        demandWk:
            'WK${requestDate.year.toString().substring(2)}${(index % 52 + 1).toString().padLeft(2, '0')}',
        pcn: 'PCN-${31000 + (index ~/ 5)}',
        finishGoodCtn: (20 + random.nextInt(180)).toString(),
        materialPn: '${material.$2}-${5000 + index}',
        materialName: material.$1,
        requestQuantity: (receivedQty + random.nextInt(400)).toString(),
        unit: units[index % units.length],
        verificationMethod: index.isEven ? 'scan' : 'picture',
        verificationCode: 'OT-${100000 + index}',
        isBlockedMissingMaster: isBlocked,
        blockReason: isBlocked ? 'Missing material master data' : null,
        planner: 'Planner ${index % 4 + 1}',
        preparer: 'Preparer ${index % 5 + 1}',
        warehouse: 'Warehouse ${index % 3 + 1}',
        receiver: 'Receiver ${index % 4 + 1}',
        leader: 'Leader ${index % 3 + 1}',
        production: 'Production ${index % 2 + 1}',
        locker: 'L-OT-${index + 10}',
        location: 'PD-${index % 4 + 1}',
        preparedMaterialReceived: receivedQty.toString(),
        totalToProduction: consumedQty.toString(),
        currentMaterialBalance: (receivedQty - consumedQty).toString(),
        createdAt: _formatDateTime(requestDate),
        updatedAt: _formatDateTime(
          overtimeAt.add(Duration(hours: random.nextInt(24))),
        ),
        currentStep: steps[index % steps.length],
        currentStatus: statuses[index % statuses.length],
        startedAt: _formatDateTime(requestDate.add(const Duration(hours: 2))),
        completedAt: null,
        enteredPendingConfirmAt: _formatDateTime(
          requestDate.add(const Duration(hours: 1)),
        ),
        isRejected: isRejected,
        rejectedFromStep: isRejected ? steps[index % steps.length] : null,
        rejectReason: isRejected
            ? 'Mock reject reason for overtime item'
            : null,
        rejectedAt: isRejected ? _formatDateTime(overtimeAt) : null,
        isOvertime: true,
        daysSinceOpen: overdueDays.toDouble(),
        overtimeAt: _formatDateTime(overtimeAt),
      );
    });
  }

  static String _formatDateTime(DateTime value) {
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')} '
        '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}:'
        '${value.second.toString().padLeft(2, '0')}';
  }
}
