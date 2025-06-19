import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestFirebaseAuthController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  
  bool _isLoading = false;
  String? _errorMessage;
  User? _firebaseUser;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get firebaseUser => _firebaseUser;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoggedIn => _firebaseUser != null;

  /// Initialize auth state
  Future<void> initAuth() async {
    try {
      _firebaseUser = _firebaseAuth.currentUser;
      
      if (_firebaseUser != null) {
        // Load user data from local storage
        await _loadUserDataFromPrefs();
        
        // If no local data, create from Firebase user
        if (_userData == null) {
          _createUserDataFromFirebase();
        }
      }
      
      notifyListeners();
    } catch (e) {
      print("Error in initAuth: $e");
    }
  }

  /// Email/Password Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    // Admin account check
    if (email == "admin@gmail.com" && password == "123123") {
      _userData = {
        'id': 'admin',
        'firebase_uid': 'admin',
        'username': 'admin',
        'email': 'admin@gmail.com',
        'role': 'admin',
        'created_at': DateTime.now().toIso8601String(),
      };
      await _saveUserDataToPrefs();
      _setLoading(false);
      notifyListeners();
      return true;
    }

    try {
      print("Attempting Firebase login with email: $email");
      
      // Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      _firebaseUser = userCredential.user;
      print("Firebase login successful. User: ${_firebaseUser?.email}");
      
      if (_firebaseUser != null) {
        // Create user data from Firebase user
        _createUserDataFromFirebase();
        
        await _saveUserDataToPrefs();
        _setLoading(false);
        notifyListeners();
        return true;
      }
      
      return false;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      print("General login error: $e");
      _setError("Lỗi đăng nhập: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user
  Future<bool> register(String username, String email, String password, String mobile) async {
    _setLoading(true);
    _setError(null);
    
    try {
      print("Attempting Firebase registration with email: $email");
      
      // Create Firebase user
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      _firebaseUser = userCredential.user;
      print("Firebase registration successful. User: ${_firebaseUser?.email}");
      
      if (_firebaseUser != null) {
        // Update Firebase display name
        await _firebaseUser!.updateDisplayName(username);
        
        // Create user data with registration info
        _userData = {
          'id': _firebaseUser!.uid,
          'firebase_uid': _firebaseUser!.uid,
          'username': username,
          'email': email,
          'mobile': mobile,
          'emailVerified': _firebaseUser!.emailVerified,
          'photoURL': _firebaseUser!.photoURL,
          'created_at': DateTime.now().toIso8601String(),
        };
        
        await _saveUserDataToPrefs();
        _setLoading(false);
        notifyListeners();
        return true;
      }
      
      return false;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException in register: ${e.code} - ${e.message}");
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      print("General registration error: $e");
      _setError("Lỗi đăng ký: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Google Sign-In
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);
    
    try {
      print("Attempting Google Sign-In");
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _setError("Đăng nhập Google bị hủy");
        _setLoading(false);
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      _firebaseUser = userCredential.user;
      
      print("Google Sign-In successful. User: ${_firebaseUser?.email}");

      if (_firebaseUser != null) {
        // Create user data from Google sign-in
        _userData = {
          'id': _firebaseUser!.uid,
          'firebase_uid': _firebaseUser!.uid,
          'username': _firebaseUser!.displayName ?? 'Google User',
          'email': _firebaseUser!.email ?? '',
          'mobile': '', // Google doesn't provide mobile
          'photoURL': _firebaseUser!.photoURL,
          'emailVerified': _firebaseUser!.emailVerified,
          'provider': 'google',
          'created_at': DateTime.now().toIso8601String(),
        };
        
        await _saveUserDataToPrefs();
        _setLoading(false);
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print("Google Sign-In error: $e");
      _setError("Lỗi đăng nhập Google: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _firebaseAuth.signOut();
      
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      
      _firebaseUser = null;
      _userData = null;
      _setError(null);
      
      notifyListeners();
    } catch (e) {
      print("Logout error: $e");
      _setError("Lỗi khi đăng xuất: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      print("Reset password error: ${e.code} - ${e.message}");
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      print("General reset password error: $e");
      _setError("Lỗi khi gửi email reset: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Send email verification
  Future<bool> sendEmailVerification() async {
    if (_firebaseUser == null) return false;
    
    _setLoading(true);
    _setError(null);
    
    try {
      await _firebaseUser!.sendEmailVerification();
      _setLoading(false);
      return true;
    } catch (e) {
      print("Send email verification error: $e");
      _setError("Lỗi khi gửi email xác thực: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Reload user data from Firebase
  Future<void> reloadUser() async {
    if (_firebaseUser == null) return;
    
    try {
      await _firebaseUser!.reload();
      _firebaseUser = _firebaseAuth.currentUser;
      
      if (_firebaseUser != null) {
        _createUserDataFromFirebase();
        await _saveUserDataToPrefs();
        notifyListeners();
      }
    } catch (e) {
      print("Reload user error: $e");
    }
  }

  /// Create user data from Firebase user
  void _createUserDataFromFirebase() {
    if (_firebaseUser == null) return;
    
    _userData = {
      'id': _firebaseUser!.uid,
      'firebase_uid': _firebaseUser!.uid,
      'username': _firebaseUser!.displayName ?? 'User',
      'email': _firebaseUser!.email ?? '',
      'mobile': _userData?['mobile'] ?? '', // Keep existing mobile if available
      'photoURL': _firebaseUser!.photoURL,
      'emailVerified': _firebaseUser!.emailVerified,
      'created_at': _userData?['created_at'] ?? DateTime.now().toIso8601String(),
    };
  }

  /// Handle Firebase Auth errors
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        _setError('Không tìm thấy tài khoản với email này');
        break;
      case 'wrong-password':
        _setError('Mật khẩu không chính xác');
        break;
      case 'email-already-in-use':
        _setError('Email này đã được sử dụng');
        break;
      case 'weak-password':
        _setError('Mật khẩu quá yếu (tối thiểu 6 ký tự)');
        break;
      case 'invalid-email':
        _setError('Email không hợp lệ');
        break;
      case 'user-disabled':
        _setError('Tài khoản đã bị vô hiệu hóa');
        break;
      case 'too-many-requests':
        _setError('Quá nhiều yêu cầu. Vui lòng thử lại sau');
        break;
      case 'network-request-failed':
        _setError('Lỗi kết nối mạng. Kiểm tra internet của bạn');
        break;
      case 'invalid-credential':
        _setError('Thông tin đăng nhập không hợp lệ');
        break;
      case 'operation-not-allowed':
        _setError('Phương thức đăng nhập này chưa được kích hoạt');
        break;
      case 'requires-recent-login':
        _setError('Vui lòng đăng nhập lại để thực hiện thao tác này');
        break;
      default:
        _setError('Lỗi xác thực: ${e.message ?? e.code}');
    }
  }

  /// Save user data to SharedPreferences
  Future<void> _saveUserDataToPrefs() async {
    try {
      if (_userData != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(_userData!));
        print("User data saved to local storage");
      }
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  /// Load user data from SharedPreferences
  Future<void> _loadUserDataFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      
      if (userDataString != null) {
        _userData = jsonDecode(userDataString);
        print("User data loaded from local storage: ${_userData?['email']}");
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  /// Get user display name
  String get displayName {
    return _userData?['username'] ?? 
           _firebaseUser?.displayName ?? 
           _userData?['email']?.split('@')[0] ?? 
           'User';
  }

  /// Get user email
  String get userEmail {
    return _userData?['email'] ?? _firebaseUser?.email ?? '';
  }

  /// Get user photo URL
  String? get photoURL {
    return _userData?['photoURL'] ?? _firebaseUser?.photoURL;
  }

  /// Check if email is verified
  bool get isEmailVerified {
    return _firebaseUser?.emailVerified ?? false;
  }

  void clearError() {
    _setError(null);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}