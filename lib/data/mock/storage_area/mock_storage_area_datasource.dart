import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../models/storage_area_model.dart';

class MockStorageAreaDataSource {
  static final List<StorageAreaMrModel> _mockMrs = _generateMockMrs(72);

  Future<StorageAreaModel> getStorageAreas({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    debugPrint('[Mock] MockStorageAreaDataSource getStorageAreas page=$page status=$status');
    await Future.delayed(const Duration(milliseconds: 500));

    // Filter by status when requested (e.g. 'closed')
    final source = (status == 'closed')
        ? _mockMrs.where((mr) => mr.requestStatus == 'CLOSE').toList()
        : _mockMrs;
    final startIndex = (page - 1) * pageSize;
    final endIndex = min(startIndex + pageSize, source.length);
    final pageItems = startIndex >= source.length
        ? <StorageAreaMrModel>[]
        : source.sublist(startIndex, endIndex);

    final groupsByPcn = <String, List<StorageAreaMrModel>>{};
    for (final item in pageItems) {
      groupsByPcn.putIfAbsent(item.pcn, () => []).add(item);
    }

    final groups = groupsByPcn.entries
        .map(
          (entry) => StorageAreaGroupModel(
            pcn: entry.key,
            mrCount: entry.value.length,
            mrs: entry.value,
          ),
        )
        .toList();

    return StorageAreaModel(
      currentPage: page,
      total: source.length,
      perPage: pageSize,
      lastPage: (source.length / pageSize).ceil().clamp(1, 9999),
      groups: groups,
    );
  }

  static List<StorageAreaMrModel> _generateMockMrs(int count) {
    final random = Random(20260610);
    final materials = [
      ('PBT Resin Natural', 'PBT-NAT'),
      ('ABS Resin Black', 'ABS-BLK'),
      ('RPET Film Sheet', 'RPET-FILM'),
      ('OPP Packing Bag', 'OPP-BAG'),
      ('Carton Label Set', 'LBL-CTN'),
      ('Outer Carton', 'CTN-OUT'),
    ];
    final units = ['PCS', 'KG', 'ROLL', 'BOX'];
    final statuses = ['In Use', 'Pending Confirm', 'Open', 'Close'];
    final locations = ['PD-A1', 'PD-A2', 'PD-B1', 'PD-B2', 'LINE-01'];

    return List.generate(count, (index) {
      final material = materials[index % materials.length];
      final pcn = 'PCN-${(30000 + (index ~/ 8)).toString()}';
      final unit = units[index % units.length];
      final received = 120 + random.nextInt(900);
      final consumed = random.nextInt(received);
      final balance = received - consumed;
      final createdAt = DateTime.now().subtract(
        Duration(days: random.nextInt(18), hours: random.nextInt(24)),
      );
      final lastConsumeAt = createdAt.add(
        Duration(hours: 2 + random.nextInt(60)),
      );
      final isRejected = index % 17 == 0;
      final isBlocked = index % 19 == 0;
      final isOvertime = index % 11 == 0;

      return StorageAreaMrModel(
        mrId: 'mock-storage-mr-${index + 1}',
        requestNumber:
            'MR-${createdAt.year}${createdAt.month.toString().padLeft(2, '0')}-${(index + 1).toString().padLeft(4, '0')}',
        materialPn: '${material.$2}-${(1000 + index).toString()}',
        materialName: material.$1,
        unit: unit,
        pcn: pcn,
        locker: 'L-${locations[index % locations.length]}-${index + 10}',
        preparedMaterialReceived: received.toString(),
        totalToProduction: consumed.toString(),
        currentMaterialBalance: balance.toString(),
        location: locations[index % locations.length],
        lastConsumeToWhere: 'WO-${24000 + index}',
        lastConsumeAt: _formatDateTime(lastConsumeAt),
        consumeEventCount: (1 + random.nextInt(8)).toString(),
        currentStatus: statuses[index % statuses.length],
        requestStatus: index % 4 == 3 ? 'CLOSE' : 'OPEN',
        enteredPendingConfirmAt: _formatDateTime(createdAt),
        isRejected: isRejected,
        rejectReason: isRejected ? 'Mock rejected for verification review' : '',
        completedAt: index % 4 == 3 ? _formatDateTime(lastConsumeAt) : '',
        updatedAt: _formatDateTime(lastConsumeAt),
        requestDate: _formatDateTime(createdAt),
        createdAt: _formatDateTime(createdAt),
        verificationMethod: index.isEven ? 'scan' : 'picture',
        verificationCode: 'VERIFY-${100000 + index}',
        isBlockedMissingMaster: isBlocked,
        blockReason: isBlocked ? 'Missing material master data' : '',
        productionStepStatusOpenClose: index % 4 == 3 ? 'Close' : 'Open',
        autoConfirmAt: _formatDateTime(createdAt.add(const Duration(hours: 8))),
        isOvertime: isOvertime,
        daysSinceOpen: (random.nextDouble() * 6).toStringAsFixed(1),
        overtimeAt: isOvertime ? _formatDateTime(lastConsumeAt) : '',
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
