import '../../presentation/providers/permission_provider.dart';
import 'app_permissions.dart';

class WorkflowPermissions {
  // General
  static bool canView(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mmsView);
  }

  // Material Request
  static bool canPlanner(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mrPlanner);
  }

  static bool canImport(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mrImport);
  }

  static bool canActions(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mrActions);
  }

  // Workflow Steps
  static bool canPreparer(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mrStepPreparer);
  }

  static bool canWarehouse(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mrStepWarehouse);
  }

  static bool canReceiver(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mrStepReceiver);
  }

  static bool canLineLeader(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mrStepLineLeader);
  }

  static bool canProduction(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.mrStepProduction);
  }

  // Management
  static bool canManageMaterial(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.materialManage);
  }

  static bool canManageLock(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.lockManage);
  }

  static bool canManageWorkflowStep(PermissionProvider provider) {
    return provider.hasPermission(AppPermissions.workflowStepManage);
  }
}
