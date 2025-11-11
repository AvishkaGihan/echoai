// lib/providers/auth_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

/// Authentication state provider
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // State
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<User?>? _authStateSubscription;

  // ========================================
  // GETTERS
  // ========================================

  /// Current authenticated user
  User? get currentUser => _currentUser;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error message
  String? get error => _error;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  // ========================================
  // CONSTRUCTOR
  // ========================================

  AuthProvider() {
    _initializeAuthListener();
  }

  // ========================================
  // AUTHENTICATION METHODS
  // ========================================

  /// Sign up with email and password
  Future<bool> signUp({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.signUpWithEmail(
      email: email,
      password: password,
    );

    return result.when(
      success: (user) {
        _currentUser = user;
        _setLoading(false);
        notifyListeners();
        return true;
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  /// Sign in with email and password
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    return result.when(
      success: (user) {
        _currentUser = user;
        _setLoading(false);
        notifyListeners();
        return true;
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    final result = await _authService.signInWithGoogle();

    return result.when(
      success: (user) {
        _currentUser = user;
        _setLoading(false);
        notifyListeners();
        return true;
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  /// Sign out
  Future<bool> signOut() async {
    _setLoading(true);
    _clearError();

    final result = await _authService.signOut();

    return result.when(
      success: (_) {
        _currentUser = null;
        _setLoading(false);
        notifyListeners();
        return true;
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  /// Send password reset email
  Future<bool> resetPassword({required String email}) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.resetPassword(email: email);

    return result.when(
      success: (_) {
        _setLoading(false);
        notifyListeners();
        return true;
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    _setLoading(true);
    _clearError();

    final result = await _authService.deleteAccount();

    return result.when(
      success: (_) {
        _currentUser = null;
        _setLoading(false);
        notifyListeners();
        return true;
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  /// Send email verification
  Future<bool> sendEmailVerification() async {
    _setLoading(true);
    _clearError();

    final result = await _authService.sendEmailVerification();

    return result.when(
      success: (_) {
        _setLoading(false);
        notifyListeners();
        return true;
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  /// Reload user data
  Future<void> reloadUser() async {
    final result = await _authService.reloadUser();

    result.when(
      success: (user) {
        _currentUser = user;
        notifyListeners();
      },
      error: (message) {
        _setError(message);
      },
    );
  }

  // ========================================
  // PRIVATE METHODS
  // ========================================

  /// Initialize auth state listener
  void _initializeAuthListener() {
    _authStateSubscription = _authService.authStateStream.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _error = null;
  }

  // ========================================
  // DISPOSE
  // ========================================

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
