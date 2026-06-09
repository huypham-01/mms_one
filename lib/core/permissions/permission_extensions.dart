import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/permission_provider.dart';

extension BuildContextPermissionExtension on BuildContext {
  bool hasPermission(String permission) {
    return read<PermissionProvider>().hasPermission(permission);
  }

  bool hasAnyPermission(List<String> permissions) {
    return read<PermissionProvider>().hasAnyPermission(permissions);
  }

  bool hasAllPermissions(List<String> permissions) {
    return read<PermissionProvider>().hasAllPermissions(permissions);
  }
}
