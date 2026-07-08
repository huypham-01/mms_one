import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/check_login_status_usecase.dart';
import '../../../../core/auth/token_manager.dart';
import '../../../../core/services/fcm_topic_service.dart';
import '../../../../presentation/providers/permission_provider.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckLoginStatusUseCase _checkLoginStatusUseCase;
  final TokenManager _tokenManager;
  final PermissionProvider _permissionProvider;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get hasChangedPassword => _tokenManager.hasChangedPassword;
  
  Future<void> setHasChangedPassword(bool value) async {
    await _tokenManager.setHasChangedPassword(value);
    notifyListeners();
  }

  String get username {
    final token = _tokenManager.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        final decoded = JwtDecoder.decode(token);
        return decoded['username'] ?? 'User';
      } catch (e) {
        return 'User';
      }
    }
    return 'User';
  }
  String get fullname {
    final token = _tokenManager.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        final decoded = JwtDecoder.decode(token);
        return decoded['fullname'] ?? 'User';
      } catch (e) {
        return 'User';
      }
    }
    return 'User';
  }

  AuthProvider({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckLoginStatusUseCase checkLoginStatusUseCase,
    required TokenManager tokenManager,
    required PermissionProvider permissionProvider,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _checkLoginStatusUseCase = checkLoginStatusUseCase,
        _tokenManager = tokenManager,
        _permissionProvider = permissionProvider {
    checkLoginStatus();
    _syncFcmTopicsOnStartup();
  }

  /// Khi mở lại app mà đã đăng nhập sẵn → subscribe lại topic theo role
  /// (idempotent, subscribe lại không sao). Firebase đã init ở main().
  Future<void> _syncFcmTopicsOnStartup() async {
    if (_tokenManager.hasToken()) {
      await FcmTopicService.subscribeForToken(_tokenManager.getToken());
    }
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _checkLoginStatusUseCase.execute();
    if (_isLoggedIn != isLoggedIn) {
      _isLoggedIn = isLoggedIn;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _loginUseCase.execute(username, password, otp);
      if (response.status && response.accessToken != null) {
        await _permissionProvider.loadPermissions();
        // Subscribe FCM topic theo role (best-effort, không chặn login).
        await FcmTopicService.subscribeForToken(_tokenManager.getToken());
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    // Unsubscribe topic KHI token còn hiệu lực (trước khi logout xoá token).
    await FcmTopicService.unsubscribeForToken(_tokenManager.getToken());
    await _logoutUseCase.execute();
    await _permissionProvider.clearPermissions();
    _isLoggedIn = false;
    notifyListeners();
  }
}
