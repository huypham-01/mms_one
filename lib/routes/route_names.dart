/// Centralized route name and path definitions.
/// Easily extensible for new modules (warehouse, production, cmms, etc.)
class RouteNames {
  RouteNames._();

  // ── ROUTE NAMES ──────────────────────────────────────────────────────
  static const String home = 'home';
  static const String materialRequest = 'material-request';
  static const String warehouse = 'warehouse';
  static const String toProduction = 'to-production';
  static const String labelControl = 'label-control';

  // ── ROUTE PATHS ──────────────────────────────────────────────────────
  static const String homePath = '/home';
  static const String materialRequestPath = '/material-request';
  static const String warehousePath = '/warehouse';
  static const String toProductionPath = '/to-production';
  static const String labelControlPath = '/label-control';

  // ── FUTURE MODULES ───────────────────────────────────────────────────
  // static const String cmms = 'cmms';
  // static const String cmmsPath = '/cmms';
  // static const String production = 'production';
  // static const String productionPath = '/production';
}
