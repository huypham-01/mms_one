/// Model đại diện cho một MR Workflow item từ API.
class MrWorkflowItemModel {
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
  final String? updatedAt;
  final String? completedAt;

  const MrWorkflowItemModel({
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
    this.updatedAt,
    this.completedAt,
  });

  factory MrWorkflowItemModel.fromJson(Map<String, dynamic> json) {
    return MrWorkflowItemModel(
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
      startedAt: json['started_at'] ?? "-",
      updatedAt: json['updated_at'] ?? "-",
      completedAt: json['completed_at'],
    );
  }

  /// Display title cho bottom sheet list
  String get displayTitle => '$requestNumber · $workOrder · $materialPn';
}
