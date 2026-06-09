import '../../domain/entities/overtime_entity.dart';

class OvertimeMrModel extends OvertimeMrEntity {
  const OvertimeMrModel({
    required super.id,
    required super.batchId,
    required super.requestStatus,
    required super.requestDate,
    required super.requestNumber,
    required super.workOrder,
    required super.demandWk,
    required super.pcn,
    required super.finishGoodCtn,
    required super.materialPn,
    required super.materialName,
    required super.requestQuantity,
    required super.unit,
    required super.verificationMethod,
    required super.verificationCode,
    required super.isBlockedMissingMaster,
    super.blockReason,
    super.planner,
    super.preparer,
    super.warehouse,
    super.receiver,
    super.leader,
    super.production,
    super.locker,
    super.location,
    super.preparedMaterialReceived,
    super.totalToProduction,
    super.currentMaterialBalance,
    super.createdAt,
    super.updatedAt,
    required super.currentStep,
    required super.currentStatus,
    super.startedAt,
    super.completedAt,
    super.enteredPendingConfirmAt,
    required super.isRejected,
    super.rejectedFromStep,
    super.rejectReason,
    super.rejectedAt,
    required super.isOvertime,
    required super.daysSinceOpen,
    super.overtimeAt,
  });

  factory OvertimeMrModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      return false;
    }

    return OvertimeMrModel(
      id: json['id']?.toString() ?? '',
      batchId: json['batch_id']?.toString() ?? '',
      requestStatus: json['request_status']?.toString() ?? '',
      requestDate: json['request_date']?.toString() ?? '',
      requestNumber: json['request_number']?.toString() ?? '',
      workOrder: json['work_order']?.toString() ?? '',
      demandWk: json['demand_wk']?.toString() ?? '',
      pcn: json['pcn']?.toString() ?? '',
      finishGoodCtn: json['finish_good_ctn']?.toString() ?? '',
      materialPn: json['material_pn']?.toString() ?? '',
      materialName: json['material_name']?.toString() ?? '',
      requestQuantity: json['request_quantity']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      verificationMethod: json['verification_method']?.toString() ?? '',
      verificationCode: json['verification_code']?.toString() ?? '',
      isBlockedMissingMaster: parseBool(json['is_blocked_missing_master']),
      blockReason: json['block_reason']?.toString(),
      planner: json['planner']?.toString(),
      preparer: json['preparer']?.toString(),
      warehouse: json['warehouse']?.toString(),
      receiver: json['receiver']?.toString(),
      leader: json['leader']?.toString(),
      production: json['production']?.toString(),
      locker: json['locker']?.toString(),
      location: json['location']?.toString(),
      preparedMaterialReceived: json['prepared_material_received']?.toString(),
      totalToProduction: json['total_to_production']?.toString(),
      currentMaterialBalance: json['current_material_balance']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      currentStep: json['current_step']?.toString() ?? '',
      currentStatus: json['current_status']?.toString() ?? '',
      startedAt: json['started_at']?.toString(),
      completedAt: json['completed_at']?.toString(),
      enteredPendingConfirmAt: json['entered_pending_confirm_at']?.toString(),
      isRejected: parseBool(json['is_rejected']),
      rejectedFromStep: json['rejected_from_step']?.toString(),
      rejectReason: json['reject_reason']?.toString(),
      rejectedAt: json['rejected_at']?.toString(),
      isOvertime: parseBool(json['is_overtime']),
      daysSinceOpen: (json['days_since_open'] as num?)?.toDouble() ?? 0.0,
      overtimeAt: json['overtime_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'batch_id': batchId,
        'request_status': requestStatus,
        'request_date': requestDate,
        'request_number': requestNumber,
        'work_order': workOrder,
        'demand_wk': demandWk,
        'pcn': pcn,
        'finish_good_ctn': finishGoodCtn,
        'material_pn': materialPn,
        'material_name': materialName,
        'request_quantity': requestQuantity,
        'unit': unit,
        'verification_method': verificationMethod,
        'verification_code': verificationCode,
        'is_blocked_missing_master': isBlockedMissingMaster ? 1 : 0,
        'block_reason': blockReason,
        'planner': planner,
        'preparer': preparer,
        'warehouse': warehouse,
        'receiver': receiver,
        'leader': leader,
        'production': production,
        'locker': locker,
        'location': location,
        'prepared_material_received': preparedMaterialReceived,
        'total_to_production': totalToProduction,
        'current_material_balance': currentMaterialBalance,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'current_step': currentStep,
        'current_status': currentStatus,
        'started_at': startedAt,
        'completed_at': completedAt,
        'entered_pending_confirm_at': enteredPendingConfirmAt,
        'is_rejected': isRejected ? 1 : 0,
        'rejected_from_step': rejectedFromStep,
        'reject_reason': rejectReason,
        'rejected_at': rejectedAt,
        'is_overtime': isOvertime,
        'days_since_open': daysSinceOpen,
        'overtime_at': overtimeAt,
      };
}

class OvertimePageModel extends OvertimePageEntity {
  const OvertimePageModel({
    required super.currentPage,
    required super.lastPage,
    required super.total,
    required super.perPage,
    required super.items,
  });

  factory OvertimePageModel.fromJson(Map<String, dynamic> json) {
    return OvertimePageModel(
      currentPage: int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      lastPage: int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      perPage: int.tryParse(json['per_page']?.toString() ?? '50') ?? 50,
      items: (json['data'] as List<dynamic>?)
              ?.map((e) => OvertimeMrModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
