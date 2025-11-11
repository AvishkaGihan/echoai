import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';
import '../utils/result.dart';
import '../config/api_config.dart';

/// Authentication service using Firebase Auth
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _initializeAuthListener();
    _initializeGoogleSignIn();
  }

  // Firebase Auth instance
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Auth state stream controller
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  // Current user cache
  User? _currentUser;

  // ========================================
  // PUBLIC API
  // ========================================

  /// Stream of authentication state changes
  Stream<User?> get authStateStream => _authStateController.stream;

  /// Get current authenticated user
  User? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Sign up with email and password
  Future<Result<User>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          )
          .timeout(const Duration(milliseconds: ApiConfig.authTimeoutMs));

      if (credential.user == null) {
        return Result.error('Failed to create account');
      }

      final user = User.fromFirebaseUser(credential.user!);
      _updateCurrentUser(user);

      return Result.success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.error(_mapFirebaseAuthError(e));
    } on TimeoutException {
      return Result.error('Connection timeout. Please try again.');
    } catch (e) {
      return Result.error('Failed to create account: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email.trim(), password: password)
          .timeout(const Duration(milliseconds: ApiConfig.authTimeoutMs));

      if (credential.user == null) {
        return Result.error('Failed to sign in');
      }

      final user = User.fromFirebaseUser(credential.user!);
      _updateCurrentUser(user);

      return Result.success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.error(_mapFirebaseAuthError(e));
    } on TimeoutException {
      return Result.error('Connection timeout. Please try again.');
    } catch (e) {
      return Result.error('Failed to sign in: ${e.toString()}');
    }
  }

  /// Sign in with Google
  Future<Result<User>> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Get authentication tokens (idToken)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return Result.error('Failed to get authentication token');
      }

      // Get authorization tokens (accessToken)
      final GoogleSignInClientAuthorization? authorization = await googleUser
          .authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final accessToken = authorization?.accessToken;

      // Create Firebase credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // Sign in to Firebase
      final userCredential = await _firebaseAuth
          .signInWithCredential(credential)
          .timeout(const Duration(milliseconds: ApiConfig.authTimeoutMs));

      if (userCredential.user == null) {
        return Result.error('Failed to sign in with Google');
      }

      final user = User.fromFirebaseUser(userCredential.user!);
      _updateCurrentUser(user);

      return Result.success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.error(_mapFirebaseAuthError(e));
    } on TimeoutException {
      return Result.error('Connection timeout. Please try again.');
    } catch (e) {
      return Result.error('Failed to sign in with Google: ${e.toString()}');
    }
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    try {
      // Disconnect from Google
      await _googleSignIn.disconnect();

      // Sign out from Firebase
      await _firebaseAuth.signOut();

      _updateCurrentUser(null);

      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to sign out: ${e.toString()}');
    }
  }

  /// Send password reset email
  Future<Result<void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth
          .sendPasswordResetEmail(email: email.trim())
          .timeout(const Duration(milliseconds: ApiConfig.authTimeoutMs));

      return Result.success(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.error(_mapFirebaseAuthError(e));
    } on TimeoutException {
      return Result.error('Connection timeout. Please try again.');
    } catch (e) {
      return Result.error(
        'Failed to send password reset email: ${e.toString()}',
      );
    }
  }

  /// Delete current user account
  Future<Result<void>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return Result.error('No user signed in');
      }

      // Disconnect from Google
      await _googleSignIn.disconnect();

      // Delete Firebase account
      await user.delete();

      _updateCurrentUser(null);

      return Result.success(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return Result.error(
          'This operation requires recent authentication. Please sign out and sign in again.',
        );
      }
      return Result.error(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.error('Failed to delete account: ${e.toString()}');
    }
  }

  /// Send email verification
  Future<Result<void>> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return Result.error('No user signed in');
      }

      if (user.emailVerified) {
        return Result.error('Email already verified');
      }

      await user.sendEmailVerification();

      return Result.success(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.error(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.error('Failed to send verification email: ${e.toString()}');
    }
  }

  /// Reload user data from Firebase
  Future<Result<User>> reloadUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser == null) {
        return Result.error('No user signed in');
      }

      await firebaseUser.reload();
      final refreshedUser = _firebaseAuth.currentUser;

      if (refreshedUser == null) {
        return Result.error('Failed to reload user');
      }

      final user = User.fromFirebaseUser(refreshedUser);
      _updateCurrentUser(user);

      return Result.success(user);
    } catch (e) {
      return Result.error('Failed to reload user: ${e.toString()}');
    }
  }

  // ========================================
  // PRIVATE METHODS
  // ========================================

  /// Initialize Google Sign-In
  void _initializeGoogleSignIn() {
    _googleSignIn
        .initialize()
        .then((_) {
          // Listen to authentication events
          _googleSignIn.authenticationEvents.listen(
            (event) {
              // Handle sign-in/sign-out events
              if (event is GoogleSignInAuthenticationEventSignIn) {
                // User signed in
              } else if (event is GoogleSignInAuthenticationEventSignOut) {
                // User signed out
                _updateCurrentUser(null);
              }
            },
            onError: (error) {
              // Handle authentication errors
              // TODO: Add proper logging instead of print
            },
          );
        })
        .catchError((error) {
          // TODO: Add proper logging instead of print
        });
  }

  void _initializeAuthListener() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        final user = User.fromFirebaseUser(firebaseUser);
        _updateCurrentUser(user);
      } else {
        _updateCurrentUser(null);
      }
    });
  }

  /// Update current user and notify listeners
  void _updateCurrentUser(User? user) {
    _currentUser = user;
    _authStateController.add(user);
  }

  /// Map Firebase Auth errors to user-friendly messages
  String _mapFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      case 'requires-recent-login':
        return 'Please sign in again to continue';
      default:
        return 'Authentication failed: ${e.message ?? e.code}';
    }
  }

  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}
