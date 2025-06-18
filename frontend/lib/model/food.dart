class Food {
  final int foodId;
  final int userId;
  final int foodCategoryId;
  final String foodName;
  final String foodDescription;
  final double foodPrice;
  final bool isAvailable;
  final String createdAt;

  Food({
    required this.foodId,
    required this.userId,
    required this.foodCategoryId,
    required this.foodName,
    required this.foodDescription,
    required this.foodPrice,
    required this.isAvailable,
    required this.createdAt,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        foodId: json['food_id'],
        userId: json['user_id'],
        foodCategoryId: json['food_category_id'],
        foodName: json['food_name'],
        foodDescription: json['food_description'],
        foodPrice: json['food_price'].toDouble(),
        isAvailable: json['is_available'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'food_id': foodId,
        'user_id': userId,
        'food_category_id': foodCategoryId,
        'food_name': foodName,
        'food_description': foodDescription,
        'food_price': foodPrice,
        'is_available': isAvailable,
        'created_at': createdAt,
      };
}