import 'dart:async';
import '../../../models/cliente.dart';
import '../../../store/cliente_store.dart';
import '../../../services/firebase/login/login_firebase.dart';
import '../../../services/cache/transaction_cache_service.dart';

class SessionManager {
  static const Duration sessionTimeout = Duration(minutes: 10);
  Timer? _sessionTimer;

  final LoginFirebaseAuthService _authService;
  final Cliente _user;
  final ClienteStore _clienteStore;
  final TransactionCacheService _cacheService = TransactionCacheService();

  SessionManager(this._authService, this._user, this._clienteStore) {
    _startSessionTimer();
    _setUser();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(sessionTimeout, _handleSessionTimeout);
  }

  void resetSessionTimer() {
    _startSessionTimer();
  }

  void _setUser() {
    _clienteStore.defineCliente(_user);
  }

  void _clearUser() {
    _clienteStore.removeCliente();
  }

  Future<void> _handleSessionTimeout() async {
    await logout();
  }

  Future<void> logout() async {
    _sessionTimer?.cancel();
    await _authService.signOut();
    _clearUser();
    await _cacheService.clearCache();
  }

  void dispose() {
    _sessionTimer?.cancel();
  }
}
