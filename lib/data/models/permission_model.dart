import '../../domain/entities/permission_entity.dart';

class PermissionModel extends PermissionEntity {
  const PermissionModel({
    required super.permissions,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      permissions: (json['data'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          <String>{},
    );
  }
}
