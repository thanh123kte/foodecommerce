import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodecommerce/model/seller.dart';
import 'dart:math';

class ShopController with ChangeNotifier {
  List<Shop> _shops = [];
  List<Shop> _featuredShops = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // User location (you can get this from GPS or user input)
  double _userLatitude = 10.0452; // Can Tho coordinates as example
  double _userLongitude = 105.7469;

  List<Shop> get shops => _shops;
  List<Shop> get featuredShops => _featuredShops;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final String baseUrl = "http://localhost:8080/api";

  // Set user location
  void setUserLocation(double latitude, double longitude) {
    _userLatitude = latitude;
    _userLongitude = longitude;
    notifyListeners();
  }

  // Calculate distance between two coordinates using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    
    return double.parse(distance.toStringAsFixed(1)); // Round to 1 decimal place
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Parse location string to get coordinates
  // Assuming location format: "latitude,longitude" or "address"
  Map<String, double>? parseLocation(String location) {
    try {
      if (location.contains(',')) {
        List<String> coords = location.split(',');
        if (coords.length == 2) {
          double lat = double.parse(coords[0].trim());
          double lng = double.parse(coords[1].trim());
          return {'latitude': lat, 'longitude': lng};
        }
      }
      // If location is an address, you would need to geocode it
      // For now, return random coordinates near Can Tho
      return _getRandomLocationNearCanTho();
    } catch (e) {
      return _getRandomLocationNearCanTho();
    }
  }

  // Generate random location near Can Tho for demo
  Map<String, double> _getRandomLocationNearCanTho() {
    Random random = Random();
    double baseLat = 10.0452;
    double baseLng = 105.7469;
    
    // Add random offset within ~10km radius
    double latOffset = (random.nextDouble() - 0.5) * 0.1; // ~11km per 0.1 degree
    double lngOffset = (random.nextDouble() - 0.5) * 0.1;
    
    return {
      'latitude': baseLat + latOffset,
      'longitude': baseLng + lngOffset,
    };
  }

  // Calculate estimated delivery time based on distance
  int calculateDeliveryTime(double distance) {
    // Base time + time based on distance
    int baseTime = 15; // 15 minutes base
    int additionalTime = (distance * 5).round(); // 5 minutes per km
    return baseTime + additionalTime;
  }

  Future<bool> fetchShops() async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));

      final String jsonResponse = jsonEncode({
        "status": "success",
        "data": [
          {
            "shop_id": 1,
            "user_id": 1,
            "shop_name": "cafe.tto - Trà Trái Cây & Cà Phê Muối",
            "shop_description": "Trà trái cây tươi mát, cà phê muối đặc biệt",
            "shop_image_url": "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=300",
            "rating": 4.9,
            "location": "10.0352,105.7569", // Coordinates format
            "is_favorite": false,
            "is_available": true,
            "created_at": "2024-01-15T10:30:00Z"
          },
          {
            "shop_id": 2,
            "user_id": 2,
            "shop_name": "Bún Đậu Mắm Tôm Phát Lộc 6 - Đường Số 5",
            "shop_description": "Bún đậu mắm tôm truyền thống, đậm đà hương vị",
            "shop_image_url": "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300",
            "rating": 4.8,
            "location": "Đường Số 5, Khu Đô Thị Hưng Phú, Cái Răng, Cần Thơ",
            "is_favorite": true,
            "is_available": true,
            "created_at": "2024-01-15T11:00:00Z"
          },
          {
            "shop_id": 3,
            "user_id": 3,
            "shop_name": "Bún Đậu 1996 - Bún Đậu, Mỳ Cay & Trà Sữa",
            "shop_description": "Combo bún đậu, mỳ cay và trà sữa thơm ngon",
            "shop_image_url": "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=300",
            "rating": 4.6,
            "location": "10.0252,105.7369",
            "is_favorite": false,
            "is_available": true,
            "created_at": "2024-01-15T12:15:00Z"
          },
          {
            "shop_id": 4,
            "user_id": 4,
            "shop_name": "Pizza Hut - Nguyễn Văn Cừ",
            "shop_description": "Pizza Ý chính hiệu, nóng hổi thơm ngon",
            "shop_image_url": "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300",
            "rating": 4.7,
            "location": "Đường Nguyễn Văn Cừ, Ninh Kiều, Cần Thơ",
            "is_favorite": true,
            "is_available": true,
            "created_at": "2024-01-15T13:20:00Z"
          },
          {
            "shop_id": 5,
            "user_id": 5,
            "shop_name": "KFC - Lotte Mart Cần Thơ",
            "shop_description": "Gà rán giòn tan, burger thơm ngon",
            "shop_image_url": "https://images.unsplash.com/photo-1606755962773-d324e2d53014?w=300",
            "rating": 4.5,
            "location": "10.0552,105.7669",
            "is_favorite": false,
            "is_available": true,
            "created_at": "2024-01-15T14:00:00Z"
          },
          {
            "shop_id": 6,
            "user_id": 6,
            "shop_name": "Highlands Coffee - Vincom Cần Thơ",
            "shop_description": "Cà phê Việt Nam chất lượng cao",
            "shop_image_url": "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=300",
            "rating": 4.4,
            "location": "10.0152,105.7269",
            "is_favorite": false,
            "is_available": true,
            "created_at": "2024-01-15T15:30:00Z"
          }
        ]
      });

      final Map<String, dynamic> responseData = jsonDecode(jsonResponse);
      
      if (responseData['status'] == 'success') {
        final List<dynamic> shopsJson = responseData['data'];
        _shops = shopsJson.map((json) => Shop.fromJson(json)).toList();
        _featuredShops = _shops.take(5).toList();
        
        _setError(null);
        notifyListeners();
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to load shops');
        return false;
      }

    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get distance for a specific shop
  double getShopDistance(Shop shop) {
    Map<String, double>? shopCoords = parseLocation(shop.location);
    if (shopCoords != null) {
      return calculateDistance(
        _userLatitude,
        _userLongitude,
        shopCoords['latitude']!,
        shopCoords['longitude']!,
      );
    }
    return 0.0; // Default distance if location parsing fails
  }

  // Get delivery time for a specific shop
  int getShopDeliveryTime(Shop shop) {
    double distance = getShopDistance(shop);
    return calculateDeliveryTime(distance);
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