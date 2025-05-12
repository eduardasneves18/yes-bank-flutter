import 'dart:async';

import '../../../models/cliente.dart';
import '../../../store/cliente_store.dart';
import '../login/login_firebase.dart';

class SessionManager {
  static const Duration sessionTimeout = Duration(minutes: 10);
  Timer? _sessionTimer;

  final LoginFirebaseAuthService _authService;
  final Cliente _user;
  final ClienteStore _clienteStore;

  SessionManager(this._authService, this._user, this._clienteStore) {
    startSessionTimer();
  }

  void _defineUser() {
    _clienteStore.defineCliente(_user);
  }

  void _cleanUser() {
    _clienteStore.removeCliente();
  }

  void startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(sessionTimeout, _handleSessionTimeout);
    _defineUser();
  }

  void resetSessionTimer() {
    startSessionTimer();
  }

  void _handleSessionTimeout() {
    logout();
  }

  Future<void> logout() async {
    _sessionTimer?.cancel();
    await _authService.signOut();
    _cleanUser();
  }

  void dispose() {
    _sessionTimer?.cancel();
  }
}
