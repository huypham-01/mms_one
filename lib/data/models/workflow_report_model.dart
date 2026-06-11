import 'dart:convert';

import '../../domain/entities/workflow_report_entity.dart';

class WorkflowReportModel extends WorkflowReportEntity {
  const WorkflowReportModel({
    required super.requestId,
    required super.batchId,
    required super.requestNumber,
    required super.requestDate,
    required super.workOrder,
    required super.demandWk,
    required super.pcn,
    required super.finishGoodCtn,
    required super.materialPn,
    required super.materialName,
    required super.requestQuantity,
    required super.unit,
    required super.requestStatus,
    required super.stepId,
    required super.stepName,
    required super.stepStatus,
    super.actionDate,
    super.verificationMethod,
    super.verificationCode,
    required super.specCheck,
    required super.quantityCheck,
    required super.locker,
    required super.personName,
    required super.specPictures,
    required super.preparedQuantity,
    required super.difference,
    required super.lots,
  });

  factory WorkflowReportModel.fromJson(Map<String, dynamic> json) {
    final extraData = json['extra_data'] as Map<String, dynamic>? ?? {};

    const baseUrl = 'http://192.168.110.2/web_develop/';

    List<String> specPictures = [];

    try {
      final pictures = json['spec_picture'];

      if (pictures is String && pictures.isNotEmpty) {
        final decoded = List<String>.from(jsonDecode(pictures));

        specPictures = decoded.map((path) {
          if (path.startsWith('http')) {
            return path;
          }
          return '$baseUrl$path';
        }).toList();
      } else if (pictures is List) {
        specPictures = pictures.map((path) {
          final value = path.toString();

          if (value.startsWith('http')) {
            return value;
          }

          return '$baseUrl$value';
        }).toList();
      }
    } catch (e) {
      print('Parse spec picture error: $e');
    }

    return WorkflowReportModel(
      requestId: json['request_id'] ?? '',
      batchId: json['batch_id'] ?? '',
      requestNumber: json['request_number'] ?? '',
      requestDate: json['request_date'] ?? '',
      workOrder: json['work_order'] ?? '',
      demandWk: json['demand_wk']?.toString() ?? '',
      pcn: json['pcn']?.toString() ?? '',
      finishGoodCtn: json['finish_good_ctn']?.toString() ?? '',
      materialPn: json['material_pn'] ?? '',
      materialName: json['material_name'] ?? '',
      requestQuantity: json['request_quantity']?.toString() ?? '',
      unit: json['unit'] ?? '',

      requestStatus: json['request_status'] ?? '',

      stepId: json['step_id'] ?? '',
      stepName: json['step_name'] ?? '',
      stepStatus: json['step_status'] ?? '',
      actionDate: json['action_date'],

      verificationMethod: json['verify_method'],
      verificationCode: json['verification_code'],

      specCheck: json['spec_check']?.toString() ?? '',
      quantityCheck: json['quantity_check']?.toString() ?? '',
      locker: json['locker']?.toString() ?? '',
      personName: json['person_name']?.toString() ?? '',

      specPictures: specPictures,

      preparedQuantity:
          double.tryParse(extraData['prepared_quantity']?.toString() ?? '0') ??
          0,

      difference:
          double.tryParse(extraData['difference']?.toString() ?? '0') ?? 0,

      lots:
          (extraData['lots'] as List<dynamic>?)
              ?.map(
                (e) => LotInformationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
  String get displayTitle => '$requestNumber · $workOrder · $materialPn';
}

class LotInformationModel extends LotInformationEntity {
  const LotInformationModel({required super.lotName, required super.quantity});

  factory LotInformationModel.fromJson(Map<String, dynamic> json) {
    return LotInformationModel(
      lotName: json['lot_name'] ?? '',
      quantity: double.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
    );
  }
}
