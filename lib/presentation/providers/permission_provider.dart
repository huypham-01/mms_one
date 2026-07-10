import 'package:flutter/material.dart';
import '../../domain/usecases/get_my_permissions_usecase.dart';
import '../../core/storage/storage_service.dart';
import '../../core/mock/mock_mode_provider.dart';
import '../../core/permissions/app_permissions.dart';

class PermissionProvider extends ChangeNotifier {
  final GetMyPermissionsUseCase _useCase;
  final StorageService _storageService;
  final MockModeProvider _mockModeProvider;

  PermissionProvider({
    required GetMyPermissionsUseCase useCase,
    required StorageService storageService,
    required MockModeProvider mockModeProvider,
  })  : _useCase = useCase,
        _storageService = storageService,
        _mockModeProvider = mockModeProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  Set<String> _permissions = {};
  Set<String> get permissions => _permissions;

  Future<void> loadPermissions({bool forceReload = false}) async {
    if (_isLoading) return;
    if (_hasLoaded && !forceReload) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      if (_mockModeProvider.isMockMode) {
        _permissions = AppPermissions.allPermissions.toSet();
        _hasLoaded = true;
        await savePermissions();
        debugPrint('[PermissionProvider] Mock mode enabled, granted FULL permissions');
      } else {
        final serverPermissions = await _useCase.call();
        _permissions = serverPermissions;
        _hasLoaded = true;
        await savePermissions();
        debugPrint('[PermissionProvider] Successfully loaded permissions from server');
      }
    } catch (e) {
      debugPrint('[PermissionProvider] Error loading permissions from server: $e');
      // On error, we fallback to cache if available
      if (_permissions.isEmpty) {
        await restorePermissions();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> restorePermissions() async {
    final cached = _storageService.getPermissions();
    if (cached != null && cached.isNotEmpty) {
      _permissions = cached.toSet();
      _hasLoaded = true;
      debugPrint('[PermissionProvider] Restored permissions from cache: $_permissions');
      notifyListeners();
    }
  }

  Future<void> savePermissions() async {
    await _storageService.savePermissions(_permissions.toList());
  }

  Future<void> clearPermissions() async {
    _permissions.clear();
    _hasLoaded = false;
    await _storageService.clearPermissions();
    notifyListeners();
    debugPrint('[PermissionProvider] Cleared permissions in memory and cache');
  }

  bool hasPermission(String permission) {
    if (!_hasLoaded) {
      debugPrint('[PermissionProvider] Warning: Checking permission "$permission" before loaded.');
    }
    return _permissions.contains(permission);
  }

  bool hasAnyPermission(List<String> requiredPermissions) {
    for (final perm in requiredPermissions) {
      if (_permissions.contains(perm)) return true;
    }
    return false;
  }

  bool hasAllPermissions(List<String> requiredPermissions) {
    for (final perm in requiredPermissions) {
      if (!_permissions.contains(perm)) return false;
    }
    return true;
  }
}
