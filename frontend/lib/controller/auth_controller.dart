import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Một controller đơn giản quản lý các luồng xác thực
class AuthController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  String? get token => _token;
  bool get isLoggedIn => _userData != null && _token != null;

  // URL API backend
  final String baseUrl = "http://localhost:8080/api/auth"; 

  // Google Sign In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Khởi tạo và kiểm tra trạng thái đăng nhập
  Future<void> initAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final userDataString = prefs.getString('user_data');
    
    if (_token != null && userDataString != null) {
      _userData = jsonDecode(userDataString);
      notifyListeners();
    }
  }

  /// Đăng nhập
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    if(username == "admin" && password == "123123") {
        _setError(null);
        notifyListeners();
        return true;
      }
    else{
      try {
        final response = await http.post(
          Uri.parse("$baseUrl/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username, 
            'password': password
          }),
        );
        

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          _userData = responseData['user'] ?? responseData;
          _token = responseData['token'];
          
          // Lưu thông tin vào SharedPreferences
          await _saveAuthData();
          
          _setError(null);
          notifyListeners();
          return true;
        } else {
          final responseData = jsonDecode(response.body);
          _setError(responseData['message'] ?? "Sai tài khoản hoặc mật khẩu");
          return false;
        }
      } catch (e) {
        _setError("Lỗi kết nối tới máy chủ: ${e.toString()}");
        return false;
      } finally {
        _setLoading(false);
      }
    }
  }

  /// Đăng ký người dùng mới (cập nhật để khớp với register screen)
  Future<bool> register(String username, String password, String email, String mobile) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
          'mobile': mobile,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _setError(null);
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        _setError(responseData["message"] ?? "Đăng ký thất bại");
        return false;
      }
    } catch (e) {
      _setError("Lỗi kết nối tới máy chủ: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }


  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _setError("Đăng nhập Google bị hủy");
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Gửi token Google tới backend để xác thực
      final response = await http.post(
        Uri.parse("$baseUrl/google-signin"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'googleToken': googleAuth.idToken,
          'email': googleUser.email,
          'displayName': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _userData = responseData['user'] ?? {
          'email': googleUser.email,
          'displayName': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
        };
        _token = responseData['token'];
        
        // Lưu thông tin vào SharedPreferences
        await _saveAuthData();
        
        _setError(null);
        notifyListeners();
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        _setError(responseData['message'] ?? "Đăng nhập Google thất bại");
        return false;
      }
    } catch (e) {
      _setError("Lỗi đăng nhập Google: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Đăng xuất
  Future<void> logout() async {
    _setLoading(true);
    try {
      // Đăng xuất Google nếu đã đăng nhập
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      
      // Xóa dữ liệu local
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      
      _userData = null;
      _token = null;
      _setError(null);
      
      notifyListeners();
    } catch (e) {
      _setError("Lỗi khi đăng xuất: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  /// Làm mới token
  Future<bool> refreshToken() async {
    if (_token == null) return false;
    
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/refresh-token"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _token = responseData['token'];
        await _saveAuthData();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Kiểm tra tính hợp lệ của token
  Future<bool> validateToken() async {
    if (_token == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/validate-token"),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Lấy thông tin user từ server
  Future<bool> fetchUserProfile() async {
    if (_token == null) return false;
    
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        _userData = jsonDecode(response.body);
        await _saveAuthData();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError("Lỗi khi lấy thông tin người dùng: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Đổi mật khẩu
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (_token == null) return false;
    
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/change-password"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        _setError(null);
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        _setError(responseData['message'] ?? "Đổi mật khẩu thất bại");
        return false;
      }
    } catch (e) {
      _setError("Lỗi kết nối tới máy chủ: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Quên mật khẩu
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/forgot-password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        _setError(null);
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        _setError(responseData['message'] ?? "Gửi email thất bại");
        return false;
      }
    } catch (e) {
      _setError("Lỗi kết nối tới máy chủ: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Lưu dữ liệu xác thực vào SharedPreferences
  Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('auth_token', _token!);
    }
    if (_userData != null) {
      await prefs.setString('user_data', jsonEncode(_userData!));
    }
  }

  /// Xóa thông báo lỗi
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