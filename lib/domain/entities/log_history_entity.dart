/// Entity đại diện cho một mục trong lịch sử xử lý của Material Request.
class LogHistoryEntity {
  final List<LogHistoryItemEntity> items;

  const LogHistoryEntity({required this.items});
}

class LogHistoryItemEntity {
  final String id;
  final String mrRequestId;
  final String? stepName;
  final String action;
  final String? actorId;
  final String? actorRole;
  final String? actorName;
  final String? fromStatus;
  final String? toStatus;
  final String? ipAddress;
  final Map<String, Object?> payload;
  final String? note;
  final String? createdAt;
  final String? updatedAt;

  const LogHistoryItemEntity({
    required this.id,
    required this.mrRequestId,
    this.stepName,
    required this.action,
    this.actorId,
    this.actorRole,
    this.actorName,
    this.fromStatus,
    this.toStatus,
    this.ipAddress,
    required this.payload,
    this.note,
    this.createdAt,
    this.updatedAt,
  });
}
