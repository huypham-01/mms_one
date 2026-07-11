class TransactionLogEntity {
  final List<TransactionLogItemEntity> items;

  const TransactionLogEntity({
    required this.items,
  });
}

class TransactionLogItemEntity {
  final String id;
  final String mrRequestId;
  final int eventSeq;
  final String? personName;
  final String? note;
  final String? otpVerifiedAt;
  final double toProductionNow;
  final String? toWhere;
  final String? toWho;
  final String? createdAt;
  final String? updatedAt;

  const TransactionLogItemEntity({
    required this.id,
    required this.mrRequestId,
    required this.eventSeq,
    this.personName,
    this.note,
    this.otpVerifiedAt,
    required this.toProductionNow,
    this.toWhere,
    this.toWho,
    this.createdAt,
    this.updatedAt,
  });
}
