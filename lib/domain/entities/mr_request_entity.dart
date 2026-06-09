class MrRequestEntity {
  final String id;
  final String requestNumber;
  final String requestStatus;
  final String requestDate;
  final String workOrder;
  final String demandWk;
  final String pcn;
  final String finishGoodCtn;
  final String materialPn;
  final String materialName;
  final String requestQuantity;
  final String unit;
  final String currentStatus;
  final String currentStep;

  MrRequestEntity({
    required this.id,
    required this.requestNumber,
    required this.requestStatus,
    required this.requestDate,
    required this.workOrder,
    required this.demandWk,
    required this.pcn,
    required this.finishGoodCtn,
    required this.materialPn,
    required this.materialName,
    required this.requestQuantity,
    required this.unit,
    required this.currentStatus,
    required this.currentStep,
  });
}
