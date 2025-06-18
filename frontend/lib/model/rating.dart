class Rating {
  final int rateId;
  final int customerId;
  final int foodId;
  final int stars;
  final String comment;
  final String createdAt;

  Rating({
    required this.rateId,
    required this.customerId,
    required this.foodId,
    required this.stars,
    required this.comment,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rateId: json['rate_id'],
        customerId: json['customer_id'],
        foodId: json['food_id'],
        stars: json['stars'],
        comment: json['comment'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'rate_id': rateId,
        'customer_id': customerId,
        'food_id': foodId,
        'stars': stars,
        'comment': comment,
        'created_at': createdAt,
      };
}
