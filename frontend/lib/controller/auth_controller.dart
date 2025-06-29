import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class để xử lý database operations
class AuthController {
  final String baseUrl = "http://10.0.2.2:8000"; // Android Emulator
  // final String baseUrl = "http://192.168.1.100:8080/api"; // Thiết bị thật
  // final String baseUrl = "https://your-api-domain.com/api"; // Production

  /// Save user to database
  Future<bool> saveUserToDatabase({
    required String firebaseUid,
    required String fullname,
    required String email,
    required String mobile,
  }) async {
    try {
      print("Attempting to save user to database: $baseUrl/users");
      
      final response = await http.post(
        Uri.parse("$baseUrl/user/create"),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'uid': firebaseUid,
          'name': fullname,
          'email': email,
          'phone': mobile
        }),
      ).timeout(const Duration(seconds: 15));

      print("Database save response status: ${response.statusCode}");
      print("Database save response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Database save failed with status: ${response.statusCode}");
        return false;
      }
    } on http.ClientException catch (e) {
      print("Network error during database save: $e");
      return false;
    } catch (e) {
      print("Database save error: $e");
      return false;
    }
  }

  /// Get user by Firebase UID
  Future<Map<String, dynamic>?> getUserByFirebaseUid(String firebaseUid) async {
    try {
      print("Attempting to get user from database: $baseUrl/user/profile");
      
      final response = await http.post(
        Uri.parse("$baseUrl/user/profile"),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'uid': firebaseUid
        }),
      ).timeout(const Duration(seconds: 15));

      print("Database get response status: ${response.statusCode}");
      print("Database get response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Handle different response formats
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('data')) {
            return responseData['data'] as Map<String, dynamic>?;
          } else if (responseData.containsKey('user')) {
            return responseData['user'] as Map<String, dynamic>?;
          } else {
            return responseData;
          }
        }
      } else if (response.statusCode == 404) {
        print("User not found in database");
        return null;
      } else {
        print("Database get failed with status: ${response.statusCode}");
        return null;
      }
      
      return null;
    } on http.ClientException catch (e) {
      print("Network error during database get: $e");
      return null;
    } catch (e) {
      print("Database get error: $e");
      return null;
    }
  }

  /// Update user Firebase UID
  Future<bool> updateUserFirebaseUid(int userId, String firebaseUid) async {
    try {
      print("Attempting to update user Firebase UID: $baseUrl/users/$userId");
      
      final response = await http.put(
        Uri.parse("$baseUrl/users/$userId"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'firebase_uid': firebaseUid,
        }),
      ).timeout(const Duration(seconds: 15));

      print("Update Firebase UID response status: ${response.statusCode}");
      print("Update Firebase UID response body: ${response.body}");

      return response.statusCode == 200;
    } on http.ClientException catch (e) {
      print("Network error during Firebase UID update: $e");
      return false;
    } catch (e) {
      print("Update Firebase UID error: $e");
      return false;
    }
  }

  /// Check if user exists in database
  Future<bool> userExistsInDatabase(String firebaseUid) async {
    try {
      final userData = await getUserByFirebaseUid(firebaseUid);
      return userData != null;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }

  /// Test database connection
  Future<bool> testConnection() async {
    try {
      print("Testing database connection: $baseUrl/health");
      
      final response = await http.get(
        Uri.parse("$baseUrl/health"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print("Health check response status: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("Database connection test failed: $e");
      return false;
    }
  }
}