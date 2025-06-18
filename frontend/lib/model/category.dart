class Category {
  final int categoryId;
  final String categoryName;
  final String categoryIconUrl;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIconUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json['category_id'],
        categoryName: json['category_name'],
        categoryIconUrl: json['category_icon_url'],
      );

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'category_name': categoryName,
        'category_icon_url': categoryIconUrl,
      };
}