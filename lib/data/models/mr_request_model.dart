import '../../domain/entities/mr_request_entity.dart';

class MrRequestModel extends MrRequestEntity {
  MrRequestModel({
    required super.id,
    required super.requestNumber,
    required super.requestStatus,
    required super.requestDate,
    required super.workOrder,
    required super.materialPn,
    required super.materialName,
    required super.requestQuantity,
    required super.unit,
    required super.currentStatus,
    required super.currentStep,
  });

  factory MrRequestModel.fromJson(Map<String, dynamic> json) {
    return MrRequestModel(
      id: json['id'] ?? '',
      requestNumber: json['request_number'] ?? '',
      requestStatus: json['request_status'] ?? '',
      requestDate: json['request_date'] ?? '',
      workOrder: json['work_order'] ?? '',
      materialPn: json['material_pn'] ?? '',
      materialName: json['material_name'] ?? '',
      requestQuantity: json['request_quantity'] ?? '',
      unit: json['unit'] ?? '',
      currentStatus: json['current_status'] ?? '',
      currentStep: json['current_step'] ?? '',
    );
  }
}