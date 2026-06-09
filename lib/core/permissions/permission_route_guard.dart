import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/permission_provider.dart';
import '../../presentation/screens/common/unauthorized_screen.dart';

class PermissionRouteGuard extends StatelessWidget {
  final String? permission;
  final List<String>? permissions;
  final bool requireAll;
  final Widget child;

  const PermissionRouteGuard({
    super.key,
    this.permission,
    this.permissions,
    this.requireAll = false,
    required this.child,
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

        return hasAccess ? child : const UnauthorizedScreen();
      },
    );
  }
}
