import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/route_names.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/permissions/permission_extensions.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../presentation/providers/locale_provider.dart';
import '../../../../core/mock/mock_mode_provider.dart';

/// Side drawer navigation with gradient header,
/// module listing, and version info.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  static const _modules = [
    _DrawerModule(
      'Material Request',
      Icons.assignment_outlined,
      RouteNames.reportPath,
      extra: {'step': 'preparer', 'title': 'Material Request Report'},
      requiredPermission: AppPermissions.mmsView,
    ),
    _DrawerModule(
      'Preparer',
      Icons.inventory_2_outlined,
      RouteNames.reportPath,
      extra: {'step': 'warehouse', 'title': 'Preparer Report'},
      requiredPermission: AppPermissions.mrStepPreparer,
    ),

    _DrawerModule(
      'Warehouse',
      Icons.warehouse_outlined,
      RouteNames.reportPath,
      extra: {'step': 'receiver', 'title': 'Warehouse Report'},
      badge: 0,
      requiredPermission: AppPermissions.mrStepWarehouse,
    ),

    _DrawerModule(
      'Material Receiver',
      Icons.move_to_inbox_outlined,
      RouteNames.reportPath,
      extra: {'step': 'line_leader', 'title': 'Material Receiver Report'},
      requiredPermission: AppPermissions.mrStepReceiver,
    ),

    _DrawerModule(
      'Line Leader',
      Icons.engineering_outlined,
      RouteNames.reportPath,
      extra: {'step': 'production', 'title': 'Line Leader Report'},
      requiredPermission: AppPermissions.mrStepLineLeader,
    ),
    _DrawerModule(
      'To Production',
      Icons.precision_manufacturing_outlined,
      RouteNames.reportPath,
      extra: {'step': 'production', 'title': 'To Production Report'},
      requiredPermission: AppPermissions.mrStepProduction,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DrawerHeader(),

            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'REPORT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ..._modules
                      .where((m) {
                        if (m.requiredPermission == null) return true;
                        return context.hasPermission(m.requiredPermission!);
                      })
                      .map(
                        (m) => _DrawerTile(
                          icon: m.icon,
                          title: m.title,
                          badge: m.badge,
                          onTap: () {
                            Navigator.pop(context);
                            if (m.route != null) {
                              if (m.extra != null) {
                                context.push(m.route!, extra: m.extra);
                              } else {
                                context.go(m.route!);
                              }
                            }
                          },
                        ),
                      ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  // _DrawerTile(
                  //   icon: Icons.history_outlined,
                  //   title: 'Log History',
                  //   highlighted: true,
                  //   onTap: () {},
                  // ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(),
            ),
            const _LanguageSection(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _DrawerTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                highlighted: false,
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  context.read<AuthProvider>().logout();
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'v1.0.0',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final mockModeProvider = context.watch<MockModeProvider>();
    final username = authProvider.username;
    final currentLanguage = localeProvider.getLanguageName(
      localeProvider.locale,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.factory_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            username,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          if (mockModeProvider.isMockMode)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '🧪 MOCK MODE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Language: $currentLanguage',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerModule {
  const _DrawerModule(
    this.title,
    this.icon,
    this.route, {
    this.badge = 0,
    this.extra,
    this.requiredPermission,
  });
  final String title;
  final IconData icon;
  final String? route;
  final int badge;
  final Map<String, dynamic>? extra;
  final String? requiredPermission;
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.badge = 0,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final int badge;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: highlighted
            ? AppColors.primary.withValues(alpha: 0.06)
            : null,
        leading: Icon(
          icon,
          size: 20,
          color: highlighted ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
            color: highlighted ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        trailing: badge > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.badge,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      ),
    );
  }
}

class _LanguageSection extends StatefulWidget {
  const _LanguageSection();

  @override
  State<_LanguageSection> createState() => _LanguageSectionState();
}

class _LanguageSectionState extends State<_LanguageSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            leading: const Icon(
              Icons.language_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
            title: const Text(
              'Language',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Icon(
              _isExpanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              color: AppColors.textSecondary,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
              child: Column(
                children: [..._buildLanguageTiles(context, localeProvider)],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildLanguageTiles(
    BuildContext context,
    LocaleProvider localeProvider,
  ) {
    return AppLocale.all.map((locale) {
      final isSelected = localeProvider.isSelected(locale);
      final languageName = localeProvider.getLanguageName(locale);

      return _LanguageTile(
        title: languageName,
        isSelected: isSelected,
        onTap: () async {
          await localeProvider.changeLocale(locale);
        },
      );
    }).toList();
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isSelected
            ? AppColors.primary.withValues(alpha: 0.06)
            : null,
        leading: Icon(
          isSelected
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 20,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        minTileHeight: 36,
      ),
    );
  }
}
