import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodecommerce/model/food.dart';
// import 'package:foodecommerce/model/food.dart';

class FoodController with ChangeNotifier {
  List<Food> _foods = [];
  List<Food> _popularFoods = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Food> get foods => _foods;
  List<Food> get popularFoods => _popularFoods;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Base URL for your Spring Boot API
  final String baseUrl = "http://localhost:8080/api";

  /// Get all foods from API
  Future<bool> fetchFoods() async {
    _setLoading(true);
    try {
      // TODO: Replace with actual API call when Spring Boot is ready
      // final response = await http.get(
      //   Uri.parse("$baseUrl/foods"),
      //   headers: {'Content-Type': 'application/json'},
      // );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API response with JSON data
      final String jsonResponse = jsonEncode({
        "status": "success",
        "data": [
          {
            "food_id": 1,
            "user_id": 1,
            "food_category_id": 1,
            "food_name": "Margherita Pizza",
            "food_description": "Classic pizza with fresh tomatoes, mozzarella cheese, and basil",
            "food_price": 12.99,
            "is_available": true,
            "created_at": "2024-01-15T10:30:00Z"
          },
          {
            "food_id": 2,
            "user_id": 1,
            "food_category_id": 2,
            "food_name": "Beef Burger",
            "food_description": "Juicy beef patty with lettuce, tomato, and special sauce",
            "food_price": 9.99,
            "is_available": true,
            "created_at": "2024-01-15T11:00:00Z"
          },
          {
            "food_id": 3,
            "user_id": 2,
            "food_category_id": 3,
            "food_name": "Salmon Sushi Roll",
            "food_description": "Fresh salmon with avocado and cucumber, served with wasabi",
            "food_price": 15.99,
            "is_available": true,
            "created_at": "2024-01-15T12:15:00Z"
          },
          {
            "food_id": 4,
            "user_id": 1,
            "food_category_id": 4,
            "food_name": "Spaghetti Carbonara",
            "food_description": "Creamy pasta with bacon, eggs, and parmesan cheese",
            "food_price": 11.50,
            "is_available": true,
            "created_at": "2024-01-15T13:20:00Z"
          },
          {
            "food_id": 5,
            "user_id": 3,
            "food_category_id": 5,
            "food_name": "Caesar Salad",
            "food_description": "Fresh romaine lettuce with caesar dressing and croutons",
            "food_price": 8.99,
            "is_available": true,
            "created_at": "2024-01-15T14:00:00Z"
          },
          {
            "food_id": 6,
            "user_id": 2,
            "food_category_id": 8,
            "food_name": "Grilled Chicken",
            "food_description": "Tender grilled chicken breast with herbs and spices",
            "food_price": 13.99,
            "is_available": true,
            "created_at": "2024-01-15T15:30:00Z"
          },
          {
            "food_id": 7,
            "user_id": 1,
            "food_category_id": 6,
            "food_name": "Chocolate Cake",
            "food_description": "Rich chocolate cake with chocolate frosting",
            "food_price": 6.99,
            "is_available": true,
            "created_at": "2024-01-15T16:00:00Z"
          },
          {
            "food_id": 8,
            "user_id": 3,
            "food_category_id": 7,
            "food_name": "Fresh Orange Juice",
            "food_description": "Freshly squeezed orange juice, 100% natural",
            "food_price": 4.99,
            "is_available": true,
            "created_at": "2024-01-15T17:00:00Z"
          }
        ]
      });

      // Process the JSON response
      final Map<String, dynamic> responseData = jsonDecode(jsonResponse);
      
      if (responseData['status'] == 'success') {
        final List<dynamic> foodsJson = responseData['data'];
        _foods = foodsJson
            .map((json) => Food.fromJson(json))
            .toList();
        
        // Set popular foods (first 4 items for demo)
        _popularFoods = _foods.take(4).toList();
        
        _setError(null);
        notifyListeners();
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to load foods');
        return false;
      }

    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get popular foods
  Future<bool> fetchPopularFoods() async {
    _setLoading(true);
    try {
      // TODO: Replace with actual API call
      // final response = await http.get(
      //   Uri.parse("$baseUrl/foods/popular"),
      //   headers: {'Content-Type': 'application/json'},
      // );

      await Future.delayed(const Duration(milliseconds: 800));

      // For now, just get the first 4 foods as popular
      if (_foods.isNotEmpty) {
        _popularFoods = _foods.take(4).toList();
      } else {
        // If no foods loaded yet, fetch all foods first
        await fetchFoods();
      }

      _setError(null);
      notifyListeners();
      return true;

    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get foods by category
  List<Food> getFoodsByCategory(int categoryId) {
    return _foods
        .where((food) => food.foodCategoryId == categoryId)
        .toList();
  }

  /// Get food by ID
  Food? getFoodById(int foodId) {
    try {
      return _foods.firstWhere((food) => food.foodId == foodId);
    } catch (e) {
      return null;
    }
  }

  /// Search foods by name
  List<Food> searchFoods(String query) {
    if (query.isEmpty) return _foods;
    
    return _foods
        .where((food) => 
            food.foodName.toLowerCase().contains(query.toLowerCase()) ||
            food.foodDescription.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Get available foods only
  List<Food> getAvailableFoods() {
    return _foods.where((food) => food.isAvailable).toList();
  }

  /// Refresh foods
  Future<bool> refreshFoods() async {
    return await fetchFoods();
  }

  /// Clear foods
  void clearFoods() {
    _foods.clear();
    _popularFoods.clear();
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