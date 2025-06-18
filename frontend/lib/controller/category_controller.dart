import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodecommerce/model/category.dart';

class CategoryController with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Base URL for your Spring Boot API
  final String baseUrl = "http://localhost:8080/api";

  /// Get all categories from API
  Future<bool> fetchCategories() async {
    _setLoading(true);
    try {
      // TODO: Replace with actual API call when Spring Boot is ready
      // final response = await http.get(
      //   Uri.parse("$baseUrl/categories"),
      //   headers: {'Content-Type': 'application/json'},
      // );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API response with JSON data
      final String jsonResponse = jsonEncode({
        "status": "success",
        "data": [
          {
            "category_id": 1,
            "category_name": "Pizza",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/3595/3595458.png"
          },
          {
            "category_id": 2,
            "category_name": "Burger",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/1046/1046784.png"
          },
          {
            "category_id": 3,
            "category_name": "Sushi",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/2252/2252080.png"
          },
          {
            "category_id": 4,
            "category_name": "Pasta",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/2718/2718896.png"
          },
          {
            "category_id": 5,
            "category_name": "Salad",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/1147/1147496.png"
          },
          {
            "category_id": 6,
            "category_name": "Dessert",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/992/992651.png"
          },
          {
            "category_id": 7,
            "category_name": "Drinks",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/2405/2405479.png"
          },
          {
            "category_id": 8,
            "category_name": "Chicken",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/1046/1046751.png"
          },
          {
            "category_id": 9,
            "category_name": "Seafood",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/2515/2515283.png"
          },
          {
            "category_id": 10,
            "category_name": "Vegetarian",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/1147/1147496.png"
          },
          {
            "category_id": 11,
            "category_name": "Fast Food",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/1046/1046786.png"
          },
          {
            "category_id": 12,
            "category_name": "Healthy",
            "category_icon_url": "https://cdn-icons-png.flaticon.com/512/2515/2515274.png"
          }
        ]
      });

      // Process the JSON response
      final Map<String, dynamic> responseData = jsonDecode(jsonResponse);
      
      if (responseData['status'] == 'success') {
        final List<dynamic> categoriesJson = responseData['data'];
        _categories = categoriesJson
            .map((json) => Category.fromJson(json))
            .toList();
        
        _setError(null);
        notifyListeners();
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to load categories');
        return false;
      }

      // TODO: Use this when your Spring Boot API is ready
      /*
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 'success') {
          final List<dynamic> categoriesJson = responseData['data'];
          _categories = categoriesJson
              .map((json) => Category.fromJson(json))
              .toList();
          
          _setError(null);
          notifyListeners();
          return true;
        } else {
          _setError(responseData['message'] ?? 'Failed to load categories');
          return false;
        }
      } else {
        _setError('Server error: ${response.statusCode}');
        return false;
      }
      */

    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get category by ID
  Category? getCategoryById(int categoryId) {
    try {
      return _categories.firstWhere((category) => category.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Search categories by name
  List<Category> searchCategories(String query) {
    if (query.isEmpty) return _categories;
    
    return _categories
        .where((category) => 
            category.categoryName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Refresh categories
  Future<bool> refreshCategories() async {
    return await fetchCategories();
  }

  /// Clear categories
  void clearCategories() {
    _categories.clear();
    notifyListeners();
  }

  /// Clear error message
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