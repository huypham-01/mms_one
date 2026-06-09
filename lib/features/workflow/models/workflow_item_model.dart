/// Model đại diện cho một MR Workflow item từ API.
class WorkflowItemModel {
  final String id;
  final String? batchId;
  final String requestStatus;
  final String requestDate;
  final String requestNumber;
  final String workOrder;
  final String demandWk;
  final String pcn;
  final String finishGoodCtn;
  final String materialPn;
  final String materialName;
  final String requestQuantity;
  final String unit;
  final String? verificationMethod;
  final String? verificationCode;
  final bool isBlockedMissingMaster;
  final String? blockReason;
  final String? locker;
  final String? location;
  final String currentStep;
  final String currentStatus;
  final bool isOvertime;
  final double daysSinceOpen;
  final String? overtimeAt;
  final bool isRejected;
  final String? rejectReason;
  final String? currentStepStatus;
  final String? currentStepPersonName;
  final String? startedAt;
  final String? completedAt;

  const WorkflowItemModel({
    required this.id,
    this.batchId,
    required this.requestStatus,
    required this.requestDate,
    required this.requestNumber,
    required this.workOrder,
    required this.demandWk,
    required this.pcn,
    required this.finishGoodCtn,
    required this.materialPn,
    required this.materialName,
    required this.requestQuantity,
    required this.unit,
    this.verificationMethod,
    this.verificationCode,
    required this.isBlockedMissingMaster,
    this.blockReason,
    this.locker,
    this.location,
    required this.currentStep,
    required this.currentStatus,
    required this.isOvertime,
    required this.daysSinceOpen,
    this.overtimeAt,
    required this.isRejected,
    this.rejectReason,
    this.currentStepStatus,
    this.currentStepPersonName,
    this.startedAt,
    this.completedAt,
  });

  factory WorkflowItemModel.fromJson(Map<String, dynamic> json) {
    return WorkflowItemModel(
      id: json['id'] ?? '',
      batchId: json['batch_id'],
      requestStatus: json['request_status'] ?? '',
      requestDate: json['request_date'] ?? '',
      requestNumber: json['request_number'] ?? '',
      workOrder: json['work_order'] ?? '',
      demandWk: json['demand_wk']?.toString() ?? '',
      pcn: json['pcn']?.toString() ?? '',
      finishGoodCtn: json['finish_good_ctn']?.toString() ?? '',
      materialPn: json['material_pn'] ?? '',
      materialName: json['material_name'] ?? '',
      requestQuantity: json['request_quantity']?.toString() ?? '',
      unit: json['unit'] ?? '',
      verificationMethod: json['verification_method'],
      verificationCode: json['verification_code'],
      isBlockedMissingMaster: (json['is_blocked_missing_master'] ?? 0) == 1,
      blockReason: json['block_reason'],
      locker: json['locker'],
      location: json['location'],
      currentStep: json['current_step'] ?? '',
      currentStatus: json['current_status'] ?? '',
      isOvertime: json['is_overtime'] == true,
      daysSinceOpen: (json['days_since_open'] ?? 0.0).toDouble(),
      overtimeAt: json['overtime_at'],
      isRejected: (json['is_rejected'] ?? 0) == 1,
      rejectReason: json['reject_reason'],
      currentStepStatus: json['current_step_status'],
      currentStepPersonName: json['current_step_person_name'],
      startedAt: json['started_at'],
      completedAt: json['completed_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'locker': locker,
      'location': location,
      'current_step': currentStep,
      'current_status': currentStatus,
      'is_overtime': isOvertime,
      'days_since_open': daysSinceOpen,
      'overtime_at': overtimeAt,
      'is_rejected': isRejected ? 1 : 0,
      'reject_reason': rejectReason,
      'current_step_status': currentStepStatus,
      'current_step_person_name': currentStepPersonName,
      'started_at': startedAt,
      'completed_at': completedAt,
    };
  }

  /// Display title cho bottom sheet list
  String get displayTitle => '$requestNumber · $workOrder · $materialPn';
}
