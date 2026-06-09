class OvertimeMrEntity {
  final String id;
  final String batchId;
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
  final String verificationMethod;
  final String verificationCode;
  final bool isBlockedMissingMaster;
  final String? blockReason;
  final String? planner;
  final String? preparer;
  final String? warehouse;
  final String? receiver;
  final String? leader;
  final String? production;
  final String? locker;
  final String? location;
  final String? preparedMaterialReceived;
  final String? totalToProduction;
  final String? currentMaterialBalance;
  final String? createdAt;
  final String? updatedAt;
  final String currentStep;
  final String currentStatus;
  final String? startedAt;
  final String? completedAt;
  final String? enteredPendingConfirmAt;
  final bool isRejected;
  final String? rejectedFromStep;
  final String? rejectReason;
  final String? rejectedAt;
  final bool isOvertime;
  final double daysSinceOpen;
  final String? overtimeAt;

  const OvertimeMrEntity({
    required this.id,
    required this.batchId,
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
    required this.verificationMethod,
    required this.verificationCode,
    required this.isBlockedMissingMaster,
    this.blockReason,
    this.planner,
    this.preparer,
    this.warehouse,
    this.receiver,
    this.leader,
    this.production,
    this.locker,
    this.location,
    this.preparedMaterialReceived,
    this.totalToProduction,
    this.currentMaterialBalance,
    this.createdAt,
    this.updatedAt,
    required this.currentStep,
    required this.currentStatus,
    this.startedAt,
    this.completedAt,
    this.enteredPendingConfirmAt,
    required this.isRejected,
    this.rejectedFromStep,
    this.rejectReason,
    this.rejectedAt,
    required this.isOvertime,
    required this.daysSinceOpen,
    this.overtimeAt,
  });
}

class OvertimePageEntity {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final List<OvertimeMrEntity> items;

  const OvertimePageEntity({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    required this.items,
  });
}
