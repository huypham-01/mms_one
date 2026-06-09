import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

// --- Core ---
import '../core/constants/app_constants.dart';
import '../core/storage/storage_service.dart';
import '../core/auth/token_manager.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_client.dart';
import '../core/localization/locale_storage.dart';

// --- Auth Feature ---
import '../data/datasources/mr_workflow_reject_remote_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/check_login_status_usecase.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

// --- Permission Module ---
import '../data/datasources/permission_remote_datasource.dart';
import '../data/repositories/permission_repository_impl.dart';
import '../domain/repositories/permission_repository.dart';
import '../domain/usecases/get_my_permissions_usecase.dart';
import '../presentation/providers/permission_provider.dart';

// --- Locale Module ---
import '../presentation/providers/locale_provider.dart';

// --- Global Workflow Feature ---
import '../features/workflow/services/workflow_service.dart';
import '../features/workflow/controllers/workflow_controller.dart';

// --- Material Request / Workflow Models ---
import '../data/datasources/mr_request_remote_datasource.dart';
import '../data/datasources/mr_workflow_remote_datasource.dart';
import '../data/datasources/mr_workflow_submit_remote_datasource.dart';
import '../data/datasources/upload_remote_datasource.dart';
import '../data/repositories/mr_request_repository_impl.dart';
import '../data/repositories/mr_workflow_repository_impl.dart';
import '../data/repositories/mr_workflow_submit_repository_impl.dart';
import '../domain/repositories/mr_request_repository.dart';
import '../domain/repositories/mr_workflow_repository.dart';
import '../domain/repositories/mr_workflow_submit_repository.dart';
import '../domain/usecases/get_mr_requests_usecase.dart';
import '../domain/usecases/get_mr_workflow_usecase.dart';
import '../domain/usecases/get_workflow_report_detail_usecase.dart';

// --- Presentation Providers ---
import '../presentation/providers/mr_request_provider.dart';
import '../presentation/providers/mr_workflow_provider.dart';
import '../presentation/providers/storage_area_provider.dart';
import '../routes/app_router.dart';

// --- Storage Area Module ---
import '../data/datasources/storage_area_remote_datasource.dart';
import '../data/repositories/storage_area_repository_impl.dart';
import '../domain/repositories/storage_area_repository.dart';
import '../domain/usecases/get_storage_areas_usecase.dart';

// --- Transaction Log Module ---
import '../data/datasources/transaction_log_remote_datasource.dart';
import '../data/repositories/transaction_log_repository_impl.dart';
import '../domain/repositories/transaction_log_repository.dart';
import '../domain/usecases/get_transaction_logs_usecase.dart';
import '../presentation/providers/transaction_log_provider.dart';

// --- Log History Module ---
import '../data/datasources/log_history_remote_datasource.dart';
import '../data/repositories/log_history_repository_impl.dart';
import '../domain/repositories/log_history_repository.dart';
import '../domain/usecases/get_log_history_usecase.dart';
import '../presentation/providers/log_history_provider.dart';

// --- Overtime Module ---
import '../data/datasources/overtime_remote_datasource.dart';
import '../data/repositories/overtime_repository_impl.dart';
import '../domain/repositories/overtime_repository.dart';
import '../domain/usecases/get_overtimes_usecase.dart';
import '../presentation/providers/overtime_provider.dart';

class AppProviders {
  AppProviders._();

  /// Returns the root MultiProvider that wraps the entire app.
  static Widget wrapWithProviders({
    required SharedPreferences prefs,
    required Widget child,
  }) {
    // 1. Core Services
    final storageService = StorageService(prefs);
    final tokenManager = TokenManager(prefs);
    final localeStorage = LocaleStorage(prefs);

    // 2. Networking (Dio & ApiClient)
    final dioClient = DioClient(
      // baseUrl: 'http://192.168.110.2/web_develop/mms/backend',
      baseUrl: AppConstants.baseUrlll,
      tokenManager: tokenManager,
    );
    final apiClient = ApiClient(dioClient);
    final workflowService = WorkflowService(apiClient);

    return MultiProvider(
      providers: [
        // ── CORE PROVIDERS ─────────────────────────────────────────────
        Provider<StorageService>.value(value: storageService),
        Provider<TokenManager>.value(value: tokenManager),
        Provider<LocaleStorage>.value(value: localeStorage),
        Provider<ApiClient>.value(value: apiClient),
        Provider<WorkflowService>.value(value: workflowService),

        // ── LOCALE MODULE ──────────────────────────────────────────────
        ChangeNotifierProvider<LocaleProvider>(
          create: (context) =>
              LocaleProvider(context.read<LocaleStorage>())..loadSavedLocale(),
        ),

        // ── PERMISSION MODULE ──────────────────────────────────────────
        Provider<PermissionRemoteDataSource>(
          create: (context) =>
              PermissionRemoteDataSourceImpl(context.read<ApiClient>()),
        ),
        Provider<PermissionRepository>(
          create: (context) => PermissionRepositoryImpl(
            context.read<PermissionRemoteDataSource>(),
          ),
        ),
        Provider<GetMyPermissionsUseCase>(
          create: (context) =>
              GetMyPermissionsUseCase(context.read<PermissionRepository>()),
        ),
        ChangeNotifierProvider<PermissionProvider>(
          create: (context) => PermissionProvider(
            useCase: context.read<GetMyPermissionsUseCase>(),
            storageService: context.read<StorageService>(),
          )..restorePermissions(),
        ),

        // ── AUTH FEATURE ───────────────────────────────────────────────
        Provider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSource(context.read<ApiClient>()),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            context.read<AuthRemoteDataSource>(),
            context.read<TokenManager>(),
          ),
        ),
        Provider<LoginUseCase>(
          create: (context) => LoginUseCase(context.read<AuthRepository>()),
        ),
        Provider<LogoutUseCase>(
          create: (context) => LogoutUseCase(context.read<AuthRepository>()),
        ),
        Provider<CheckLoginStatusUseCase>(
          create: (context) =>
              CheckLoginStatusUseCase(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            loginUseCase: context.read<LoginUseCase>(),
            logoutUseCase: context.read<LogoutUseCase>(),
            checkLoginStatusUseCase: context.read<CheckLoginStatusUseCase>(),
            tokenManager: context.read<TokenManager>(),
            permissionProvider: context.read<PermissionProvider>(),
          ),
        ),

        // ── ROUTER PROVIDER ────────────────────────────────────────────
        Provider<GoRouter>(
          create: (context) =>
              AppRouter.createRouter(context.read<AuthProvider>()),
        ),

        // ── NEW WORKFLOW CONTROLLER ────────────────────────────────────
        ChangeNotifierProvider<WorkflowController>(
          create: (context) =>
              WorkflowController(context.read<WorkflowService>()),
        ),

        // ── STORAGE AREA MODULE ────────────────────────────────────────
        Provider<StorageAreaRemoteDataSource>(
          create: (context) =>
              StorageAreaRemoteDataSourceImpl(context.read<ApiClient>()),
        ),
        Provider<StorageAreaRepository>(
          create: (context) => StorageAreaRepositoryImpl(
            context.read<StorageAreaRemoteDataSource>(),
          ),
        ),
        Provider<GetStorageAreasUseCase>(
          create: (context) =>
              GetStorageAreasUseCase(context.read<StorageAreaRepository>()),
        ),
        ChangeNotifierProvider<StorageAreaProvider>(
          create: (context) =>
              StorageAreaProvider(context.read<GetStorageAreasUseCase>()),
        ),

        // ── TRANSACTION LOG MODULE ─────────────────────────────────────
        Provider<TransactionLogRemoteDataSource>(
          create: (context) =>
              TransactionLogRemoteDataSourceImpl(context.read<ApiClient>()),
        ),
        Provider<TransactionLogRepository>(
          create: (context) => TransactionLogRepositoryImpl(
            context.read<TransactionLogRemoteDataSource>(),
          ),
        ),
        Provider<GetTransactionLogsUseCase>(
          create: (context) => GetTransactionLogsUseCase(
            context.read<TransactionLogRepository>(),
          ),
        ),
        ChangeNotifierProvider<TransactionLogProvider>(
          create: (context) =>
              TransactionLogProvider(context.read<GetTransactionLogsUseCase>()),
        ),

        // ── LOG HISTORY MODULE ─────────────────────────────────────────
        Provider<LogHistoryRemoteDataSource>(
          create: (context) =>
              LogHistoryRemoteDataSourceImpl(context.read<ApiClient>()),
        ),
        Provider<LogHistoryRepository>(
          create: (context) => LogHistoryRepositoryImpl(
            context.read<LogHistoryRemoteDataSource>(),
          ),
        ),
        Provider<GetLogHistoryUseCase>(
          create: (context) =>
              GetLogHistoryUseCase(context.read<LogHistoryRepository>()),
        ),
        ChangeNotifierProvider<LogHistoryProvider>(
          create: (context) =>
              LogHistoryProvider(context.read<GetLogHistoryUseCase>()),
        ),

        // ── OVERTIME MODULE ────────────────────────────────────────────
        Provider<OvertimeRemoteDataSource>(
          create: (context) =>
              OvertimeRemoteDataSourceImpl(context.read<ApiClient>()),
        ),
        Provider<OvertimeRepository>(
          create: (context) =>
              OvertimeRepositoryImpl(context.read<OvertimeRemoteDataSource>()),
        ),
        Provider<GetOvertimesUseCase>(
          create: (context) =>
              GetOvertimesUseCase(context.read<OvertimeRepository>()),
        ),
        ChangeNotifierProvider<OvertimeProvider>(
          create: (context) =>
              OvertimeProvider(context.read<GetOvertimesUseCase>()),
        ),

        // ── MATERIAL REQUEST MODULE ────────────────────────────────────
        ..._materialRequestProviders(),

        // ── MR WORKFLOW & SUBMIT MODULE ────────────────────────────────
        ..._mrWorkflowProviders(),
      ],
      child: child,
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // MATERIAL REQUEST MODULE
  // ════════════════════════════════════════════════════════════════════════
  static List<SingleChildWidget> _materialRequestProviders() {
    return [
      Provider<MrRequestRemoteDataSource>(
        create: (context) =>
            MrRequestRemoteDataSource(context.read<ApiClient>()),
      ),
      Provider<MrRequestRepository>(
        create: (context) =>
            MrRequestRepositoryImpl(context.read<MrRequestRemoteDataSource>()),
      ),
      Provider<GetMrRequestsUseCase>(
        create: (context) =>
            GetMrRequestsUseCase(context.read<MrRequestRepository>()),
      ),
      ChangeNotifierProvider<MrRequestProvider>(
        create: (context) =>
            MrRequestProvider(context.read<GetMrRequestsUseCase>())
              ..fetchMrRequests(),
      ),
    ];
  }

  // ════════════════════════════════════════════════════════════════════════
  // MR WORKFLOW MODULE
  // ════════════════════════════════════════════════════════════════════════
  static List<SingleChildWidget> _mrWorkflowProviders() {
    return [
      // Workflow Fetch Data Sources
      Provider<MrWorkflowRemoteDataSource>(
        create: (context) =>
            MrWorkflowRemoteDataSource(context.read<ApiClient>()),
      ),
      Provider<MrWorkflowRepository>(
        create: (context) => MrWorkflowRepositoryImpl(
          context.read<MrWorkflowRemoteDataSource>(),
        ),
      ),
      Provider<GetMrWorkflowUseCase>(
        create: (context) =>
            GetMrWorkflowUseCase(context.read<MrWorkflowRepository>()),
      ),
      Provider<GetWorkflowReportDetailUseCase>(
        create: (context) => GetWorkflowReportDetailUseCase(
          context.read<MrWorkflowRepository>(),
        ),
      ),

      // Workflow Submit Data Sources
      Provider<UploadRemoteDataSource>(
        create: (context) => UploadRemoteDataSource(context.read<ApiClient>()),
      ),
      Provider<MrWorkflowSubmitRemoteDataSource>(
        create: (context) =>
            MrWorkflowSubmitRemoteDataSource(context.read<ApiClient>()),
      ),
      Provider<MrWorkflowRejectRemoteDataSource>(
        create: (context) =>
            MrWorkflowRejectRemoteDataSource(context.read<ApiClient>()),
      ),
      Provider<MrWorkflowSubmitRepository>(
        create: (context) => MrWorkflowSubmitRepositoryImpl(
          uploadDataSource: context.read<UploadRemoteDataSource>(),
          submitDataSource: context.read<MrWorkflowSubmitRemoteDataSource>(),
          rejectDataSource: context.read<MrWorkflowRejectRemoteDataSource>(),
        ),
      ),

      // Default provider cho Preparer step
      ChangeNotifierProvider<MrWorkflowProvider>(
        create: (context) => MrWorkflowProvider(
          step: 'preparer',
          useCase: context.read<GetMrWorkflowUseCase>(),
          detailUseCase: context.read<GetWorkflowReportDetailUseCase>(),
        ),
      ),
    ];
  }

  /// Factory tạo MrWorkflowProvider cho một step cụ thể.
  /// Dùng cho các screen (warehouse, receiver, ...) cần provider riêng.
  static MrWorkflowProvider createWorkflowProvider(
    BuildContext context,
    String step,
  ) {
    return MrWorkflowProvider(
      step: step,
      useCase: context.read<GetMrWorkflowUseCase>(),
      detailUseCase: context.read<GetWorkflowReportDetailUseCase>(),
    );
  }
}
