import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_controller.dart'; // Import database service

class FirebaseAuthController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final AuthController _authService = AuthController(); // Database service
  
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
        // Load user data from local storage first
        await _loadUserDataFromPrefs();
        
        // If no local data, fetch from database
        if (_userData == null) {
          await _fetchUserDataFromDatabase();
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
        'fullname': 'admin',
        'email': 'admin@gmail.com',
        'role': '0', // Admin role
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
        // Fetch user data from your database
        bool success = await _fetchUserDataFromDatabase();
        
        if (success) {
          await _saveUserDataToPrefs();
          _setLoading(false);
          notifyListeners();
          return true;
        } else {
          _setError("Không thể lấy thông tin người dùng từ database");
        }
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
  Future<bool> register(String fullname, String email, String password, String mobile) async {
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
        await _firebaseUser!.updateDisplayName(fullname);
        
        // Save user data to your database using AuthController service
        bool success = await _authService.saveUserToDatabase(
          firebaseUid: _firebaseUser!.uid,
          fullname: fullname,
          email: email,
          mobile: mobile,
          avatarUrl: _firebaseUser!.photoURL,
        );
        
        if (success) {
          // Get the saved user data
          _userData = await _authService.getUserByFirebaseUid(_firebaseUser!.uid);
          
          if (_userData != null) {
            await _saveUserDataToPrefs();
            _setLoading(false);
            notifyListeners();
            return true;
          }
        } else {
          // If database save fails, delete Firebase user
          await _firebaseUser!.delete();
          _firebaseUser = null;
          _setError("Không thể lưu thông tin vào database");
        }
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
        // Check if user exists in database
        _userData = await _authService.getUserByFirebaseUid(_firebaseUser!.uid);
        
        if (_userData == null) {
          // Create new user in database
          bool success = await _authService.saveUserToDatabase(
            firebaseUid: _firebaseUser!.uid,
            fullname: _firebaseUser!.displayName ?? 'Google User',
            email: _firebaseUser!.email ?? '',
            mobile: _firebaseUser!.phoneNumber ?? '',
            avatarUrl: _firebaseUser!.photoURL,
          );
          print("firebaseuid:"
              "${_firebaseUser!.uid}, fullname: ${_firebaseUser!.displayName}, email: ${_firebaseUser!.email}, mobile: ${_firebaseUser!.phoneNumber}, avatarUrl: ${_firebaseUser!.photoURL}");
          
          if (success) {
            _userData = await _authService.getUserByFirebaseUid(_firebaseUser!.uid);
          } else {
            _setError("Không thể tạo tài khoản trong database");
            return false;
          }
        }
        
        if (_userData != null) {
          await _saveUserDataToPrefs();
          _setLoading(false);
          notifyListeners();
          return true;
        }
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

  // google login function
  Future<bool> logInWithGoogle() async {
    _setLoading(true);
    _setError(null);

    try {
      print("Attempting Google Login");

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

      print("Google Login successful. User: ${_firebaseUser?.email}");

      if (_firebaseUser != null) {
        // Chỉ kiểm tra user đã tồn tại, không tạo mới
        _userData = await _authService.getUserByFirebaseUid(_firebaseUser!.uid);

        if (_userData == null) {
          _setError("Tài khoản chưa được đăng ký trong hệ thống");
          _setLoading(false);
          return false;
        }

        await _saveUserDataToPrefs();
        _setLoading(false);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      print("Google Login error: $e");
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

  /// Fetch user data from database
  Future<bool> _fetchUserDataFromDatabase() async {
    if (_firebaseUser == null) return false;
    
    try {
      _userData = await _authService.getUserByFirebaseUid(_firebaseUser!.uid);
      return _userData != null;
    } catch (e) {
      print("Error fetching user data: $e");
      return false;
    }
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
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
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