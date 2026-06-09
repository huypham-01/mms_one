import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/permission_provider.dart';

class PermissionGuard extends StatelessWidget {
  final String? permission;
  final List<String>? permissions;
  final bool requireAll;
  final Widget child;
  final Widget fallback;

  const PermissionGuard({
    super.key,
    this.permission,
    this.permissions,
    this.requireAll = false,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  }) : assert(permission != null || permissions != null,
            'You must provide either a single permission or a list of permissions.');

  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionProvider>(
      builder: (context, provider, _) {
        bool hasAccess = false;

        if (permission != null) {
          hasAccess = provider.hasPermission(permission!);
        } else if (permissions != null) {
          if (requireAll) {
            hasAccess = provider.hasAllPermissions(permissions!);
          } else {
            hasAccess = provider.hasAnyPermission(permissions!);
          }
        }

        return hasAccess ? child : fallback;
      },
    );
  }
}
