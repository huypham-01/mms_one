import '../../domain/entities/log_history_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class LogHistoryModel extends LogHistoryEntity {
  const LogHistoryModel({required super.items});

  factory LogHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final List<dynamic> dataList = rawData is List ? rawData : [];
    return LogHistoryModel(
      items: dataList
          .map((e) => LogHistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ITEM MODEL
// ─────────────────────────────────────────────────────────────────────────────

class LogHistoryItemModel extends LogHistoryItemEntity {
  const LogHistoryItemModel({
    required super.id,
    required super.mrRequestId,
    super.stepName,
    required super.action,
    super.actorId,
    super.actorRole,
    super.actorName,
    super.fromStatus,
    super.toStatus,
    super.ipAddress,
    required super.payload,
    super.note,
    super.createdAt,
    super.updatedAt,
  });

  factory LogHistoryItemModel.fromJson(Map<String, dynamic> json) {
    // Safely parse payload as Map<String, Object?> – no dynamic in caller.
    final rawPayload = json['payload'];
    final Map<String, Object?> payload = rawPayload is Map
        ? Map<String, Object?>.from(rawPayload.map(
            (k, v) => MapEntry(k.toString(), v as Object?),
          ))
        : {};

    return LogHistoryItemModel(
      id: json['id']?.toString() ?? '',
      mrRequestId: json['mr_request_id']?.toString() ?? '',
      stepName: json['step_name']?.toString(),
      action: json['action']?.toString() ?? '',
      actorId: json['actor_id']?.toString(),
      actorRole: json['actor_role']?.toString(),
      actorName: json['actor_name']?.toString(),
      fromStatus: json['from_status']?.toString(),
      toStatus: json['to_status']?.toString(),
      ipAddress: json['ip_address']?.toString(),
      payload: payload,
      note: json['note']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
