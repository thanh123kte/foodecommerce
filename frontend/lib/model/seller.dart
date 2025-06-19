class Shop {
  final int shopId;
  final int userId;
  final String shopName;
  final String shopDescription;
  final String shopImageUrl;
  final double rating;
  final String location;
  final bool isFavorite;
  final bool isAvailable;
  final String createdAt;

  Shop({
    required this.shopId,
    required this.userId,
    required this.shopName,
    required this.shopDescription,
    required this.shopImageUrl,
    required this.rating,
    required this.location,
    required this.isFavorite,
    required this.isAvailable,
    required this.createdAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        shopId: json['shop_id'],
        userId: json['user_id'],
        shopName: json['shop_name'],
        shopDescription: json['shop_description'],
        shopImageUrl: json['shop_image_url'],
        rating: json['rating'].toDouble(),
        location: json['distance'].toString(),
        isFavorite: json['is_favorite'],
        isAvailable: json['is_available'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'shop_id': shopId,
        'user_id': userId,
        'shop_name': shopName,
        'shop_description': shopDescription,
        'shop_image_url': shopImageUrl,
        'rating': rating,
        'location': location,
        'is_favorite': isFavorite,
        'is_available': isAvailable,
        'created_at': createdAt,
      };
}
