import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../models/transaction_log_model.dart';

class MockTransactionLogDataSource {
  Future<List<TransactionLogItemModel>> getTransactionLogs(String mrId) async {
    debugPrint(
      '[Mock] MockTransactionLogDataSource getTransactionLogs id=$mrId',
    );
    await Future.delayed(const Duration(milliseconds: 450));

    final seed = mrId.codeUnits.fold<int>(0, (sum, code) => sum + code);
    final random = Random(seed);
    final count = 4 + random.nextInt(8);
    final startDate = DateTime.now().subtract(
      Duration(days: 5 + random.nextInt(10), hours: random.nextInt(12)),
    );

    var remaining = 600 + random.nextInt(500);
    return List.generate(count, (index) {
      final quantity = min(remaining, 20 + random.nextInt(120));
      remaining = max(0, remaining - quantity);
      final createdAt = startDate.add(Duration(hours: index * 6 + 1));

      return TransactionLogItemModel(
        id: 'mock-transaction-log-$mrId-${index + 1}',
        mrRequestId: mrId,
        eventSeq: index + 1,
        personName: _names[index % _names.length],
        note: 'Mock consume event ${index + 1}',
        otpVerifiedAt: _formatDateTime(
          createdAt.subtract(const Duration(minutes: 2)),
        ),
        toProductionNow: quantity.toDouble(),
        toWhere: _locations[index % _locations.length],
        toWho: _receivers[index % _receivers.length],
        createdAt: _formatDateTime(createdAt),
        updatedAt: _formatDateTime(createdAt.add(const Duration(minutes: 3))),
      );
    });
  }

  static const _names = [
    'Mock User',
    'Line Leader A',
    'Production MR',
    'Warehouse Staff',
  ];

  static const _locations = [
    'LINE-01',
    'LINE-02',
    'PD-A1',
    'PD-B2',
    'Assembly-03',
  ];

  static const _receivers = [
    'Nguyen Van A',
    'Tran Thi B',
    'Production Team 1',
    'Material Receiver',
  ];

  static String _formatDateTime(DateTime value) {
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')} '
        '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}:'
        '${value.second.toString().padLeft(2, '0')}';
  }
}
