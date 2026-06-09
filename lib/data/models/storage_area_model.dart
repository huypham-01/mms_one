import '../../domain/entities/storage_area_entity.dart';

class StorageAreaModel extends StorageAreaEntity {
  const StorageAreaModel({
    required super.currentPage,
    required super.total,
    required super.perPage,
    required super.lastPage,
    required super.groups,
  });

  factory StorageAreaModel.fromJson(Map<String, dynamic> json) {
    return StorageAreaModel(
      currentPage: int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      perPage: int.tryParse(json['per_page']?.toString() ?? '50') ?? 50,
      lastPage: int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      groups: (json['data'] as List<dynamic>?)
              ?.map((e) => StorageAreaGroupModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total': total,
      'per_page': perPage,
      'last_page': lastPage,
      'data': groups.map((e) => (e as StorageAreaGroupModel).toJson()).toList(),
    };
  }
}

class StorageAreaGroupModel extends StorageAreaGroupEntity {
  const StorageAreaGroupModel({
    required super.pcn,
    required super.mrCount,
    required super.mrs,
  });

  factory StorageAreaGroupModel.fromJson(Map<String, dynamic> json) {
    return StorageAreaGroupModel(
      pcn: json['pcn']?.toString() ?? '',
      mrCount: int.tryParse(json['mr_count']?.toString() ?? '0') ?? 0,
      mrs: (json['mrs'] as List<dynamic>?)
              ?.map((e) => StorageAreaMrModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pcn': pcn,
      'mr_count': mrCount,
      'mrs': mrs.map((e) => (e as StorageAreaMrModel).toJson()).toList(),
    };
  }
}

class StorageAreaMrModel extends StorageAreaMrEntity {
  const StorageAreaMrModel({
    required super.mrId,
    required super.requestNumber,
    required super.materialPn,
    required super.materialName,
    required super.unit,
    required super.pcn,
    required super.locker,
    required super.preparedMaterialReceived,
    required super.totalToProduction,
    required super.currentMaterialBalance,
    required super.location,
    required super.lastConsumeToWhere,
    required super.lastConsumeAt,
    required super.consumeEventCount,
    required super.currentStatus,
    required super.requestStatus,
    required super.enteredPendingConfirmAt,
    required super.isRejected,
    required super.rejectReason,
    required super.completedAt,
    required super.updatedAt,
    required super.requestDate,
    required super.createdAt,
    required super.verificationMethod,
    required super.verificationCode,
    required super.isBlockedMissingMaster,
    required super.blockReason,
    required super.productionStepStatusOpenClose,
    required super.autoConfirmAt,
    required super.isOvertime,
    required super.daysSinceOpen,
    required super.overtimeAt,
  });

  factory StorageAreaMrModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      return false;
    }

    return StorageAreaMrModel(
      mrId: json['mr_id']?.toString() ?? '',
      requestNumber: json['request_number']?.toString() ?? '',
      materialPn: json['material_pn']?.toString() ?? '',
      materialName: json['material_name']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      pcn: json['pcn']?.toString() ?? '',
      locker: json['locker']?.toString() ?? '',
      preparedMaterialReceived: json['prepared_material_received']?.toString() ?? '',
      totalToProduction: json['total_to_production']?.toString() ?? '',
      currentMaterialBalance: json['current_material_balance']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      lastConsumeToWhere: json['last_consume_to_where']?.toString() ?? '',
      lastConsumeAt: json['last_consume_at']?.toString() ?? '',
      consumeEventCount: json['consume_event_count']?.toString() ?? '',
      currentStatus: json['current_status']?.toString() ?? '',
      requestStatus: json['request_status']?.toString() ?? '',
      enteredPendingConfirmAt: json['entered_pending_confirm_at']?.toString() ?? '',
      isRejected: parseBool(json['is_rejected']),
      rejectReason: json['reject_reason']?.toString() ?? '',
      completedAt: json['completed_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      requestDate: json['request_date']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      verificationMethod: json['verification_method']?.toString() ?? '',
      verificationCode: json['verification_code']?.toString() ?? '',
      isBlockedMissingMaster: parseBool(json['is_blocked_missing_master']),
      blockReason: json['block_reason']?.toString() ?? '',
      productionStepStatusOpenClose: json['production_step_status_open_close']?.toString() ?? '',
      autoConfirmAt: json['auto_confirm_at']?.toString() ?? '',
      isOvertime: parseBool(json['is_overtime']),
      daysSinceOpen: json['days_since_open']?.toString() ?? '',
      overtimeAt: json['overtime_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mrId': mrId,
      'requestNumber': requestNumber,
      'materialPn': materialPn,
      'materialName': materialName,
      'unit': unit,
      'pcn': pcn,
      'locker': locker,
      'preparedMaterialReceived': preparedMaterialReceived,
      'totalToProduction': totalToProduction,
      'currentMaterialBalance': currentMaterialBalance,
      'location': location,
      'lastConsumeToWhere': lastConsumeToWhere,
      'lastConsumeAt': lastConsumeAt,
      'consumeEventCount': consumeEventCount,
      'currentStatus': currentStatus,
      'requestStatus': requestStatus,
      'enteredPendingConfirmAt': enteredPendingConfirmAt,
      'isRejected': isRejected ? 1 : 0,
      'rejectReason': rejectReason,
      'completedAt': completedAt,
      'updatedAt': updatedAt,
      'requestDate': requestDate,
      'createdAt': createdAt,
      'verificationMethod': verificationMethod,
      'verificationCode': verificationCode,
      'isBlockedMissingMaster': isBlockedMissingMaster ? 1 : 0,
      'blockReason': blockReason,
      'productionStepStatusOpenClose': productionStepStatusOpenClose,
      'autoConfirmAt': autoConfirmAt,
      'isOvertime': isOvertime ? 1 : 0,
      'daysSinceOpen': daysSinceOpen,
      'overtimeAt': overtimeAt,
    };
  }
}
