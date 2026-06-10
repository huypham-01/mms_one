import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/permission_provider.dart';

extension BuildContextPermissionExtension on BuildContext {
  bool hasPermission(String permission) {
    return watch<PermissionProvider>().hasPermission(permission);
  }

  bool hasAnyPermission(List<String> permissions) {
    return watch<PermissionProvider>().hasAnyPermission(permissions);
  }

  bool hasAllPermissions(List<String> permissions) {
    return watch<PermissionProvider>().hasAllPermissions(permissions);
  }
}
