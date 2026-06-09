import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/material_overtime/material_overtime_screen.dart';
import '../presentation/screens/material_request/material_request_screen.dart';
import '../presentation/screens/material_request/material_request_detail_screen.dart';
import '../domain/entities/mr_request_entity.dart';
import '../presentation/screens/report/report_screen.dart';
import '../presentation/screens/report/workflow_report_detail_screen.dart';
import '../presentation/screens/preparer/preparer_screen.dart';
import '../presentation/screens/storage_area/storage_area_screen.dart';
import '../presentation/screens/storage_area/storage_area_detail_screen.dart';
import '../presentation/screens/warehouse/warehouse_screen.dart';
import '../presentation/screens/material_receiver/material_receiver_screen.dart';
import '../presentation/screens/line_leader/line_leader_screen.dart';
import '../presentation/screens/to_production/to_production_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../providers/app_providers.dart';
import 'package:provider/provider.dart';
import 'route_names.dart';
import '../presentation/screens/log_history/log_history_screen.dart';

/// Application router configuration using go_router.
/// Supports named routes, transition animations, and easy module expansion.
class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: authProvider.isLoggedIn
          ? RouteNames.homePath
          : RouteNames.loginPath,
      debugLogDiagnostics: false,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isGoingToLogin = state.uri.toString() == RouteNames.loginPath;

        if (!isLoggedIn && !isGoingToLogin) {
          return RouteNames.loginPath;
        }

        if (isLoggedIn && isGoingToLogin) {
          return RouteNames.homePath;
        }

        return null;
      },
      routes: [
        // ── LOGIN ────────────────────────────────────────────────────────
        GoRoute(
          name: RouteNames.login,
          path: RouteNames.loginPath,
          pageBuilder: (context, state) =>
              _buildPage(key: state.pageKey, child: const LoginScreen()),
        ),

        // ── HOME ───────────────────────────────────────────────────────
        GoRoute(
          name: RouteNames.home,
          path: RouteNames.homePath,
          pageBuilder: (context, state) =>
              _buildPage(key: state.pageKey, child: const HomeScreen()),
        ),

        // ── MATERIAL REQUEST ───────────────────────────────────────────
        GoRoute(
          name: RouteNames.materialRequest,
          path: RouteNames.materialRequestPath,
          pageBuilder: (context, state) => _buildPage(
            key: state.pageKey,
            child: const MaterialRequestScreen(),
          ),
          routes: [
            GoRoute(
              name: RouteNames.materialRequestDetail,
              path: RouteNames.materialRequestDetailPath,
              pageBuilder: (context, state) {
                final request = state.extra as MrRequestEntity?;
                return _buildPage(
                  key: state.pageKey,
                  child: MaterialRequestDetailScreen(request: request),
                );
              },
            ),
          ],
        ),

        // ──  PREPARER ────────────────────────────────────
        GoRoute(
          name: RouteNames.preparer,
          path: RouteNames.preparerPath,
          pageBuilder: (context, state) =>
              _buildPage(key: state.pageKey, child: const PreparerScreen()),
        ),
        GoRoute(
          name: RouteNames.report,
          path: RouteNames.reportPath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final step = extra['step'] as String? ?? 'preparer';
            final title = extra['title'] as String? ?? 'Preparer Report';

            return _buildPage(
              key: state.pageKey,
              child: ChangeNotifierProvider(
                create: (context) =>
                    AppProviders.createWorkflowProvider(context, step)..fetch(),
                child: ReportScreen(workflowStep: step, title: title),
              ),
            );
          },
          routes: [
            GoRoute(
              name: RouteNames.workflowReportDetail,
              path: RouteNames.workflowReportDetailPath,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>? ?? {};
                final itemId = extra['itemId'] as String? ?? '';
                final title = extra['title'] as String? ?? '';
                final step = extra['step'] as String? ?? 'preparer';

                return _buildPage(
                  key: state.pageKey,
                  child: ChangeNotifierProvider(
                    create: (context) =>
                        AppProviders.createWorkflowProvider(context, step),
                    child: WorkflowReportDetailScreen(
                      itemId: itemId,
                      step: step,
                      title: title,
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        // ── WAREHOUSE ────────────────────────────────────
        GoRoute(
          name: RouteNames.warehouse,
          path: RouteNames.warehousePath,
          pageBuilder: (context, state) =>
              _buildPage(key: state.pageKey, child: const WarehouseScreen()),
        ),

        // ── MATERIAL RECEIVER ────────────────────────────────────
        GoRoute(
          name: RouteNames.materialReceiver,
          path: RouteNames.materialReceiverPath,
          pageBuilder: (context, state) => _buildPage(
            key: state.pageKey,
            child: const MaterialReceiverScreen(),
          ),
        ),

        // ── LINE LEADER ────────────────────────────────────
        GoRoute(
          name: RouteNames.lineLeader,
          path: RouteNames.lineLeaderPath,
          pageBuilder: (context, state) =>
              _buildPage(key: state.pageKey, child: const LineLeaderScreen()),
        ),

        // ── TO PRODUCTION ────────────────────────────────
        GoRoute(
          name: RouteNames.toProduction,
          path: RouteNames.toProductionPath,
          pageBuilder: (context, state) =>
              _buildPage(key: state.pageKey, child: const ToProductionScreen()),
        ),

        // ── PD STORAGE AREA ────────────────────────────────
        GoRoute(
          name: RouteNames.storageArea,
          path: RouteNames.storageAreaPath,
          pageBuilder: (context, state) =>
              _buildPage(key: state.pageKey, child: const StorageAreaScreen()),
        ),

        // ── TRANSACTION LOG ────────────────────────────────
        GoRoute(
          name: RouteNames.transactionLog,
          path: RouteNames.transactionLogPath,
          pageBuilder: (context, state) {
            final mrId = state.pathParameters['mrId'] ?? '';
            return _buildPage(
              key: state.pageKey,
              child: TransactionLogScreen(mrId: mrId),
            );
          },
        ),

        // ── LOG HISTORY ────────────────────────────────────
        GoRoute(
          name: RouteNames.logHistory,
          path: RouteNames.logHistoryPath,
          pageBuilder: (context, state) {
            final mrId = state.pathParameters['mrId'] ?? '';
            return _buildPage(
              key: state.pageKey,
              child: LogHistoryScreen(mrId: mrId),
            );
          },
        ),

        // ── MATERIAL OVERTIME ────────────────────────────────
        GoRoute(
          name: RouteNames.materialOvertime,
          path: RouteNames.materialOvertimePath,
          pageBuilder: (context, state) => _buildPage(
            key: state.pageKey,
            child: const MaterialOvertimeScreen(),
          ),
        ),

        // ── LABEL CONTROL (placeholder) ────────────────────────────────
        // GoRoute(
        //   name: RouteNames.labelControl,
        //   path: RouteNames.labelControlPath,
        //   pageBuilder: (context, state) => _buildPage(
        //     key: state.pageKey,
        //     child: const LabelControlScreen(),
        //   ),
        // ),
      ],

      // ── ERROR PAGE ────────────────────────────────────────────────────
      errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Page not found',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  state.uri.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.go(RouteNames.homePath),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a page with a smooth slide + fade transition.
  static CustomTransitionPage _buildPage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
