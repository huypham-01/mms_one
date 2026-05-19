import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/datasources/mr_request_remote_datasource.dart';
import '../data/repositories/mr_request_repository_impl.dart';
import '../domain/usecases/get_mr_requests_usecase.dart';
import '../presentation/providers/mr_request_provider.dart';

/// Centralized provider configuration for the entire application.
///
/// Organized by module for easy maintenance and extension.
/// To add a new module (e.g., CMMS, Warehouse), simply:
///   1. Create the module's data/domain/presentation layers
///   2. Add the provider to the appropriate section below
class AppProviders {
  AppProviders._();

  /// Returns the root MultiProvider that wraps the entire app.
  static Widget wrapWithProviders({required Widget child}) {
    return MultiProvider(
      providers: [
        // ── MATERIAL REQUEST MODULE ────────────────────────────────────
        ..._materialRequestProviders(),

        // ── WAREHOUSE MODULE (future) ──────────────────────────────────
        // ..._warehouseProviders(),

        // ── PRODUCTION MODULE (future) ──────────────────────────────────
        // ..._productionProviders(),

        // ── CMMS MODULE (future) ────────────────────────────────────────
        // ..._cmmsProviders(),
      ],
      child: child,
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // MATERIAL REQUEST MODULE
  // ════════════════════════════════════════════════════════════════════════

  static List<SingleChildWidget> _materialRequestProviders() {
    // Data source
    final mrRemoteDataSource = MrRequestRemoteDataSource();

    // Repository
    final mrRepository = MrRequestRepositoryImpl(mrRemoteDataSource);

    // Use cases
    final getMrRequestsUseCase = GetMrRequestsUseCase(mrRepository);

    return [
      ChangeNotifierProvider<MrRequestProvider>(
        create: (_) => MrRequestProvider(getMrRequestsUseCase)
          ..fetchMrRequests(),
      ),
    ];
  }

  // ════════════════════════════════════════════════════════════════════════
  // WAREHOUSE MODULE (example for future extension)
  // ════════════════════════════════════════════════════════════════════════

  // static List<SingleChildWidget> _warehouseProviders() {
  //   return [
  //     ChangeNotifierProvider<WarehouseProvider>(
  //       create: (_) => WarehouseProvider(...),
  //     ),
  //   ];
  // }
}
