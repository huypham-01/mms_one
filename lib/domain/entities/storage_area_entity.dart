class StorageAreaEntity {
  final int currentPage;
  final int total;
  final int perPage;
  final int lastPage;
  final List<StorageAreaGroupEntity> groups;

  const StorageAreaEntity({
    required this.currentPage,
    required this.total,
    required this.perPage,
    required this.lastPage,
    required this.groups,
  });
}

class StorageAreaGroupEntity {
  final String pcn;
  final int mrCount;
  final List<StorageAreaMrEntity> mrs;

  const StorageAreaGroupEntity({
    required this.pcn,
    required this.mrCount,
    required this.mrs,
  });
}

class StorageAreaMrEntity {
  final String mrId;
  final String requestNumber;
  final String materialPn;
  final String materialName;
  final String unit;
  final String pcn;
  final String locker;
  final String preparedMaterialReceived;
  final String totalToProduction;
  final String currentMaterialBalance;
  final String location;
  final String lastConsumeToWhere;
  final String lastConsumeAt;
  final String consumeEventCount;
  final String currentStatus;
  final String requestStatus;
  final String enteredPendingConfirmAt;
  final bool isRejected;
  final String rejectReason;
  final String completedAt;
  final String updatedAt;
  final String requestDate;
  final String createdAt;
  final String verificationMethod;
  final String verificationCode;
  final bool isBlockedMissingMaster;
  final String blockReason;
  final String productionStepStatusOpenClose;
  final String autoConfirmAt;
  final bool isOvertime;
  final String daysSinceOpen;
  final String overtimeAt;

  const StorageAreaMrEntity({
    required this.mrId,
    required this.requestNumber,
    required this.materialPn,
    required this.materialName,
    required this.unit,
    required this.pcn,
    required this.locker,
    required this.preparedMaterialReceived,
    required this.totalToProduction,
    required this.currentMaterialBalance,
    required this.location,
    required this.lastConsumeToWhere,
    required this.lastConsumeAt,
    required this.consumeEventCount,
    required this.currentStatus,
    required this.requestStatus,
    required this.enteredPendingConfirmAt,
    required this.isRejected,
    required this.rejectReason,
    required this.completedAt,
    required this.updatedAt,
    required this.requestDate,
    required this.createdAt,
    required this.verificationMethod,
    required this.verificationCode,
    required this.isBlockedMissingMaster,
    required this.blockReason,
    required this.productionStepStatusOpenClose,
    required this.autoConfirmAt,
    required this.isOvertime,
    required this.daysSinceOpen,
    required this.overtimeAt,
  });
}
