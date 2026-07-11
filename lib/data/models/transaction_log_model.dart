import '../../domain/entities/transaction_log_entity.dart';

class TransactionLogModel extends TransactionLogEntity {
  const TransactionLogModel({required super.items});

  factory TransactionLogModel.fromJson(Map<String, dynamic> json) {
    return TransactionLogModel(
      items:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TransactionLogItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': items
          .map((e) => (e as TransactionLogItemModel).toJson())
          .toList(),
    };
  }
}

class TransactionLogItemModel extends TransactionLogItemEntity {
  const TransactionLogItemModel({
    required super.id,
    required super.mrRequestId,
    required super.eventSeq,
    super.personName,
    super.note,
    super.otpVerifiedAt,
    required super.toProductionNow,
    super.toWhere,
    super.toWho,
    super.createdAt,
    super.updatedAt,
  });

  factory TransactionLogItemModel.fromJson(Map<String, dynamic> json) {
    final extraData = json['extra_data'] as Map<String, dynamic>? ?? {};

    return TransactionLogItemModel(
      id: json['id']?.toString() ?? '',
      mrRequestId: json['mr_request_id']?.toString() ?? '',
      eventSeq: int.tryParse(json['event_seq']?.toString() ?? '0') ?? 0,
      personName: json['person_name']?.toString(),
      note: json['note']?.toString(),
      otpVerifiedAt: json['otp_verified_at']?.toString(),
      toProductionNow:
          (extraData['to_production_now'] as num?)?.toDouble() ?? 0.0,
      toWhere: extraData['to_where']?.toString(),
      toWho: extraData['to_who']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mr_request_id': mrRequestId,
      'event_seq': eventSeq,
      'person_name': personName,
      'note': note,
      'otp_verified_at': otpVerifiedAt,
      'extra_data': {
        'to_production_now': toProductionNow,
        'to_where': toWhere,
        'to_who': toWho,
      },
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
