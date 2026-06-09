class WorkflowReportEntity {
  final String requestId;
  final String batchId;
  final String requestNumber;
  final String requestDate;
  final String workOrder;
  final String demandWk;
  final String pcn;
  final String finishGoodCtn;
  final String materialPn;
  final String materialName;
  final String requestQuantity;
  final String unit;

  final String requestStatus;

  final String stepId;
  final String stepName;
  final String stepStatus;
  final String? actionDate;

  final String? verificationMethod;
  final String? verificationCode;

  final String specCheck;
  final String quantityCheck;
  final String locker;

  final List<String> specPictures;

  final double preparedQuantity;
  final double difference;

  final List<LotInformationEntity> lots;

  const WorkflowReportEntity({
    required this.requestId,
    required this.batchId,
    required this.requestNumber,
    required this.requestDate,
    required this.workOrder,
    required this.demandWk,
    required this.pcn,
    required this.finishGoodCtn,
    required this.materialPn,
    required this.materialName,
    required this.requestQuantity,
    required this.unit,
    required this.requestStatus,
    required this.stepId,
    required this.stepName,
    required this.stepStatus,
    this.actionDate,
    this.verificationMethod,
    this.verificationCode,
    required this.specCheck,
    required this.quantityCheck,
    required this.locker,
    required this.specPictures,
    required this.preparedQuantity,
    required this.difference,
    required this.lots,
  });
}

class LotInformationEntity {
  final String lotName;
  final double quantity;

  const LotInformationEntity({
    required this.lotName,
    required this.quantity,
  });
}