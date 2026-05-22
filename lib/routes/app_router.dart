import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/material_request/material_request_screen.dart';
import '../presentation/screens/material_request/material_request_detail_screen.dart';
import '../domain/entities/mr_request_entity.dart';
import 'route_names.dart';

/// Application router configuration using go_router.
/// Supports named routes, transition animations, and easy module expansion.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.homePath,
    debugLogDiagnostics: false,
    routes: [
      // ── HOME ───────────────────────────────────────────────────────
      GoRoute(
        name: RouteNames.home,
        path: RouteNames.homePath,
        pageBuilder: (context, state) => _buildPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
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

      // ── WAREHOUSE (placeholder) ────────────────────────────────────
      // GoRoute(
      //   name: RouteNames.warehouse,
      //   path: RouteNames.warehousePath,
      //   pageBuilder: (context, state) => _buildPage(
      //     key: state.pageKey,
      //     child: const WarehouseScreen(),
      //   ),
      // ),

      // ── TO PRODUCTION (placeholder) ────────────────────────────────
      // GoRoute(
      //   name: RouteNames.toProduction,
      //   path: RouteNames.toProductionPath,
      //   pageBuilder: (context, state) => _buildPage(
      //     key: state.pageKey,
      //     child: const ToProductionScreen(),
      //   ),
      // ),

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
          opacity: Tween<double>(begin: 0.0, end: 1.0)
              .animate(curvedAnimation),
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
