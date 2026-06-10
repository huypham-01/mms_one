import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_label.dart';
import '../../../routes/route_names.dart';
import '../../../core/permissions/app_permissions.dart';
import '../../../core/permissions/permission_extensions.dart';
import '../../../core/localization/localization_extensions.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/home_menu_card.dart';
import 'widgets/home_drawer.dart';
import '../../../presentation/providers/overtime_provider.dart';

/// Home dashboard screen showing module cards in a grid layout.
/// Entry point of the application with navigation to all modules.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnack(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('→ $title'),
          ],
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  List<_ModuleItem> _getModules1() {
    return [
      _ModuleItem(
        title: context.l10n.materialRequest,
        icon: Icons.assignment_outlined,
        route: RouteNames.materialRequestPath,
        isActive: true,
        requiredPermission: AppPermissions.mmsView,
      ),
      _ModuleItem(
        title: context.l10n.preparer,
        icon: Icons.inventory_2_outlined,
        route: RouteNames.preparerPath,
        isActive: true,
        requiredPermission: AppPermissions.mrStepPreparer,
      ),
      _ModuleItem(
        title: context.l10n.warehouse,
        icon: Icons.warehouse_outlined,
        isActive: true,
        route: RouteNames.warehousePath,
        requiredPermission: AppPermissions.mrStepWarehouse,
      ),
      _ModuleItem(
        title: context.l10n.materialReceiver,
        icon: Icons.move_to_inbox_outlined,
        isActive: true,
        route: RouteNames.materialReceiverPath,
        requiredPermission: AppPermissions.mrStepReceiver,
      ),
      _ModuleItem(
        title: context.l10n.lineLeader,
        icon: Icons.engineering_outlined,
        iconColor: const Color(0xFF7C3AED),
        isActive: true,
        route: RouteNames.lineLeaderPath,
        requiredPermission: AppPermissions.mrStepLineLeader,
      ),
      _ModuleItem(
        title: context.l10n.toProduction,
        icon: Icons.precision_manufacturing_outlined,
        isActive: true,
        iconColor: const Color(0xFF0D9488),
        route: RouteNames.toProductionPath,
        requiredPermission: AppPermissions.mrStepProduction,
      ),
    ];
  }

  List<_ModuleItem> _getModules2() {
    return [
      _ModuleItem(
        title: context.l10n.pdStorageArea,
        icon: Icons.warehouse_outlined,
        route: RouteNames.storageAreaPath,
        isActive: true,
      ),
      _ModuleItem(
        title: context.l10n.materialOvertime,
        icon: Icons.schedule_outlined,
        route: RouteNames.materialOvertimePath,
        isActive: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const HomeDrawer(),
      appBar: HomeTopBar(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(context.l10n.materialManagement),
            const SizedBox(height: 14),
            _buildModuleGrid1(),
            const SizedBox(height: 14),
            SectionLabel(context.l10n.monitoring),
            const SizedBox(height: 14),
            _buildModuleGrid2(),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleGrid1() {
    final modules = _getModules1();
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.0,
      children: modules
          .where((module) {
            if (module.requiredPermission == null) return true;
            return context.hasPermission(module.requiredPermission!);
          })
          .map((module) {
            return HomeMenuCard(
              title: module.title,
              icon: module.icon,
              isActive: module.isActive,
              badge: module.badge,
              iconColor: module.iconColor,
              onTap: () {
                if (module.route != null) {
                  context.push(module.route!);
                } else {
                  _showSnack(module.title);
                }
              },
            );
          })
          .toList(),
    );
  }

  Widget _buildModuleGrid2() {
    final modules = _getModules2();
    return Consumer<OvertimeProvider>(
      builder: (context, overtime, _) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.6,
          children: modules
              .where((module) {
                if (module.requiredPermission == null) return true;
                return context.hasPermission(module.requiredPermission!);
              })
              .map((module) {
                final badge = module.title == context.l10n.materialOvertime
                    ? overtime.total
                    : module.badge;
                return HomeMenuCard(
                  title: module.title,
                  icon: module.icon,
                  isActive: module.isActive,
                  badge: badge,
                  iconColor: module.iconColor,
                  onTap: () {
                    if (module.route != null) {
                      context.push(module.route!);
                    } else {
                      _showSnack(module.title);
                    }
                  },
                );
              })
              .toList(),
        );
      },
    );
  }
}

// ── MODULE ITEM DATA ─────────────────────────────────────────────────────────
class _ModuleItem {
  const _ModuleItem({
    required this.title,
    required this.icon,
    this.route,
    this.isActive = false,
    this.badge = 0,
    this.iconColor,
    this.requiredPermission,
  });

  final String title;
  final IconData icon;
  final String? route;
  final bool isActive;
  final int badge;
  final Color? iconColor;
  final String? requiredPermission;
}
