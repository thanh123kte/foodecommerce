class FoodImage {
  final int imageId;
  final int foodId;
  final String url;
  final bool isPrimary;
  final int sortOrder;
  final String createdAt;

  FoodImage({
    required this.imageId,
    required this.foodId,
    required this.url,
    required this.isPrimary,
    required this.sortOrder,
    required this.createdAt,
  });

  factory FoodImage.fromJson(Map<String, dynamic> json) => FoodImage(
        imageId: json['image_id'],
        foodId: json['food_id'],
        url: json['url'],
        isPrimary: json['is_primary'],
        sortOrder: json['sort_order'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'image_id': imageId,
        'food_id': foodId,
        'url': url,
        'is_primary': isPrimary,
        'sort_order': sortOrder,
        'created_at': createdAt,
      };
}