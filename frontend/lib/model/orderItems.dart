class OrderItem {
  final int orderItemsId;
  final int orderId;
  final int foodId;
  final int quantity;
  final double price;
  final double subtotal;

  OrderItem({
    required this.orderItemsId,
    required this.orderId,
    required this.foodId,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderItemsId: json['order_items_id'],
        orderId: json['order_id'],
        foodId: json['food_id'],
        quantity: json['quantity'],
        price: json['price'].toDouble(),
        subtotal: json['subtotal'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'order_items_id': orderItemsId,
        'order_id': orderId,
        'food_id': foodId,
        'quantity': quantity,
        'price': price,
        'subtotal': subtotal,
      };
}
