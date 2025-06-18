class Cart {
  final int cartId;
  final int customerId;
  final int foodId;
  final int quantity;

  Cart({
    required this.cartId,
    required this.customerId,
    required this.foodId,
    required this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartId: json['cart_id'],
        customerId: json['customer_id'],
        foodId: json['food_id'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'cart_id': cartId,
        'customer_id': customerId,
        'food_id': foodId,
        'quantity': quantity,
      };
}
