import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_label.dart';
import '../../../routes/route_names.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/home_menu_card.dart';
import 'widgets/home_drawer.dart';

/// Home dashboard screen showing module cards in a grid layout.
/// Entry point of the application with navigation to all modules.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ── MODULE DEFINITIONS ──────────────────────────────────────────────
  static const _modules1 = [
    _ModuleItem(
      title: 'Material Request',
      icon: Icons.description_outlined,
      route: RouteNames.materialRequestPath,
      isActive: true,
    ),
    _ModuleItem(title: 'Preparer', icon: Icons.warehouse_outlined),
    _ModuleItem(title: 'Warehouser', icon: Icons.local_shipping_outlined),
    _ModuleItem(
      title: 'Material Receiver',
      icon: Icons.label_outlined,
      badge: 3,
    ),
    _ModuleItem(
      title: 'Line Leader',
      icon: Icons.groups_outlined,
      iconColor: Color(0xFF7C3AED),
    ),
    _ModuleItem(
      title: 'To Production',
      icon: Icons.inventory_2_outlined,
      isActive: true,
      iconColor: Color(0xFF0D9488),
    ),
  ];
  static const _modules2 = [
    _ModuleItem(
      title: 'PD Storage Area',
      icon: Icons.description_outlined,
      route: RouteNames.materialRequestPath,
      isActive: true,
    ),
    _ModuleItem(title: 'Material Overtime', icon: Icons.warehouse_outlined),
  ];
  static const _modules3 = [
    _ModuleItem(
      title: 'SL',
      icon: Icons.description_outlined,
      route: RouteNames.materialRequestPath,
      isActive: true,
    ),
    _ModuleItem(title: 'SL IO', icon: Icons.warehouse_outlined),
    _ModuleItem(
      title: 'BL',
      icon: Icons.description_outlined,
      route: RouteNames.materialRequestPath,
      isActive: true,
    ),
    _ModuleItem(title: 'BL IO', icon: Icons.warehouse_outlined),
  ];

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
            const SectionLabel('MATERIAL MANAGEMENT'),
            const SizedBox(height: 14),
            _buildModuleGrid1(),
            const SectionLabel('MONITORING'),
            const SizedBox(height: 14),
            _buildModuleGrid2(),
            const SectionLabel('LABEL CONTROL'),
            const SizedBox(height: 14),
            _buildModuleGrid3(),
            // ToProductionButton(onTap: () => _showSnack('To Production')),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // ── BOTTOM NAV ───────────────────────────────────────────────────
      // bottomNavigationBar: HomeBottomNav(
      //   selectedIndex: _navIndex,
      //   onTap: (i) => setState(() => _navIndex = i),
      // ),
    );
  }

  Widget _buildModuleGrid1() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.0,
      children: _modules1.map((module) {
        return HomeMenuCard(
          title: module.title,
          icon: module.icon,
          isActive: module.isActive,
          badge: module.badge,
          iconColor: module.iconColor,
          onTap: () {
            if (module.route != null) {
              context.go(module.route!);
            } else {
              _showSnack(module.title);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildModuleGrid2() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.6,
      children: _modules2.map((module) {
        return HomeMenuCard(
          title: module.title,
          icon: module.icon,
          isActive: module.isActive,
          badge: module.badge,
          iconColor: module.iconColor,
          onTap: () {
            if (module.route != null) {
              context.go(module.route!);
            } else {
              _showSnack(module.title);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildModuleGrid3() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.78,
      children: _modules3.map((module) {
        return HomeMenuCard(
          title: module.title,
          icon: module.icon,
          isActive: module.isActive,
          badge: module.badge,
          iconColor: module.iconColor,
          onTap: () {
            if (module.route != null) {
              context.go(module.route!);
            } else {
              _showSnack(module.title);
            }
          },
        );
      }).toList(),
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
  });

  final String title;
  final IconData icon;
  final String? route;
  final bool isActive;
  final int badge;
  final Color? iconColor;
}
