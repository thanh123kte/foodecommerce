class Order {
  final int orderId;
  final int userId;
  final String status;
  final double totalPrice;
  final String deliverAddress;
  final String? note;
  final String createdAt;
  final String updatedAt;

  Order({
    required this.orderId,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.deliverAddress,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json['order_id'],
        userId: json['user_id'],
        status: json['status'],
        totalPrice: json['total_price'].toDouble(),
        deliverAddress: json['deliver_address'],
        note: json['note'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'user_id': userId,
        'status': status,
        'total_price': totalPrice,
        'deliver_address': deliverAddress,
        'note': note,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
