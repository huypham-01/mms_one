/// Centralized route name and path definitions.
/// Easily extensible for new modules (warehouse, production, cmms, etc.)
class RouteNames {
  RouteNames._();

  // ── ROUTE NAMES ──────────────────────────────────────────────────────
  static const String login = 'login';
  static const String home = 'home';
  static const String materialRequest = 'material-request';
  static const String preparer = 'preparer';
  static const String report = 'report';
  static const String workflowReportDetail = 'workflow-report-detail';
  static const String materialRequestDetail = 'material-request-detail';
  static const String warehouse = 'warehouse';
  static const String materialReceiver = 'material-receiver';
  static const String lineLeader = 'line-leader';
  static const String toProduction = 'to-production';
  static const String labelControl = 'label-control';
  static const String storageArea = 'pd-storage-area';
  static const String materialOvertime = 'material-overtime';
  static const String transactionLog = 'transaction-log';
  static const String logHistory = 'log-history';
  static const String changePassword = 'change-password';

  // ── ROUTE PATHS ──────────────────────────────────────────────────────
  static const String loginPath = '/login';
  static const String homePath = '/home';
  static const String materialRequestPath = '/material-request';
  static const String preparerPath = '/preparer';
  static const String reportPath = '/report';
  static const String workflowReportDetailPath = 'detail';
  static const String materialRequestDetailPath = 'detail';
  static const String warehousePath = '/warehouse';
  static const String materialReceiverPath = '/material-receiver';
  static const String lineLeaderPath = '/line-leader';
  static const String toProductionPath = '/to-production';
  static const String labelControlPath = '/label-control';
  static const String storageAreaPath = '/storage-area';
  static const String materialOvertimePath = '/material-overtime';
  static const String transactionLogPath = '/transaction-log/:mrId';
  static const String logHistoryPath = '/log-history/:mrId';
  static const String changePasswordPath = '/change-password';

  // ── FUTURE MODULES ───────────────────────────────────────────────────
  // static const String cmms = 'cmms';
  // static const String cmmsPath = '/cmms';
  // static const String production = 'production';
  // static const String productionPath = '/production';
}
