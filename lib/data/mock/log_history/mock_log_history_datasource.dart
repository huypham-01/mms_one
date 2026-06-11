import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../models/log_history_model.dart';

class MockLogHistoryDataSource {
  Future<List<LogHistoryItemModel>> getLogHistory(String mrId) async {
    debugPrint('[Mock] MockLogHistoryDataSource getLogHistory id=$mrId');
    await Future.delayed(const Duration(milliseconds: 450));

    final seed = mrId.codeUnits.fold<int>(0, (sum, code) => sum + code);
    final random = Random(seed);
    final startedAt = DateTime.now().subtract(
      Duration(days: 4 + random.nextInt(4), hours: random.nextInt(8)),
    );
    final hasRejected = random.nextInt(5) == 0;

    final rows = [
      _LogSeed(
        stepName: 'planner',
        action: 'created',
        actorRole: 'planner',
        actorName: 'Mock Planner',
        fromStatus: null,
        toStatus: 'OPEN',
        note: 'Material request created in mock mode.',
      ),
      _LogSeed(
        stepName: 'preparer',
        action: 'submitted',
        actorRole: 'preparer',
        actorName: 'Mock Preparer',
        fromStatus: 'PENDING CONFIRM',
        toStatus: 'COMPLETED',
        note: null,
      ),
      _LogSeed(
        stepName: 'warehouse',
        action: random.nextBool() ? 'submitted' : 'verification_warning',
        actorRole: 'warehouse',
        actorName: 'Mock Warehouse',
        fromStatus: 'PENDING CONFIRM',
        toStatus: random.nextBool() ? 'COMPLETED' : 'IN PROGRESS',
        note: random.nextBool()
            ? 'Mock verification passed with quantity difference reviewed.'
            : 'Mock barcode mismatch warning for review.',
      ),
      _LogSeed(
        stepName: 'receiver',
        action: 'submitted',
        actorRole: 'receiver',
        actorName: 'Mock Receiver',
        fromStatus: 'PENDING CONFIRM',
        toStatus: 'COMPLETED',
        note: null,
      ),
      _LogSeed(
        stepName: 'line_leader',
        action: hasRejected ? 'rejected' : 'submitted',
        actorRole: 'line_leader',
        actorName: 'Mock Line Leader',
        fromStatus: 'PENDING CONFIRM',
        toStatus: hasRejected ? 'REJECTED' : 'COMPLETED',
        note: hasRejected
            ? 'Mock reject reason: quantity needs reconfirmation.'
            : null,
      ),
      _LogSeed(
        stepName: 'production',
        action: 'auto_completed',
        actorRole: null,
        actorName: 'System',
        fromStatus: 'IN PROGRESS',
        toStatus: 'COMPLETED',
        note: 'Mock auto confirmation completed.',
      ),
    ];

    return List.generate(rows.length, (index) {
      final row = rows[index];
      final createdAt = startedAt.add(Duration(hours: index * 8 + 1));
      return LogHistoryItemModel(
        id: 'mock-log-history-$mrId-${index + 1}',
        mrRequestId: mrId,
        stepName: row.stepName,
        action: row.action,
        actorId: row.actorRole == null ? null : 'mock-${row.actorRole}-$index',
        actorRole: row.actorRole,
        actorName: row.actorName,
        fromStatus: row.fromStatus,
        toStatus: row.toStatus,
        ipAddress: '127.0.0.${index + 1}',
        payload: _buildPayload(row, index, random),
        note: row.note,
        createdAt: _formatDateTime(createdAt),
        updatedAt: _formatDateTime(createdAt.add(const Duration(minutes: 3))),
      );
    }).reversed.toList();
  }

  Map<String, Object?> _buildPayload(_LogSeed row, int index, Random random) {
    return {
      'step': row.stepName,
      'action': row.action,
      'otp_verified': row.actorRole != null,
      'quantity_check': index == 0 ? null : random.nextBool(),
      'spec_check': index == 0 ? null : random.nextBool(),
      'locker': index == 0 ? null : 'L-MOCK-${index + 10}',
      'extra_data': {
        'prepared_quantity': 100 + random.nextInt(500),
        'difference': random.nextInt(8),
        'scan_result': random.nextBool() ? 'correct' : 'reviewed',
      },
    };
  }

  static String _formatDateTime(DateTime value) {
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')} '
        '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}:'
        '${value.second.toString().padLeft(2, '0')}';
  }
}

class _LogSeed {
  final String stepName;
  final String action;
  final String? actorRole;
  final String actorName;
  final String? fromStatus;
  final String? toStatus;
  final String? note;

  const _LogSeed({
    required this.stepName,
    required this.action,
    required this.actorRole,
    required this.actorName,
    required this.fromStatus,
    required this.toStatus,
    required this.note,
  });
}
