class Voucher {
  final int voucherId;
  final String code;
  final String title;
  final String discountType;
  final double discountValue;
  final double maxDiscount;
  final double minOrderValue;
  final String startDate;
  final String endDate;
  final int usageLimit;
  final int usedCount;
  final int createdByAdmin;
  final int sellerId;
  final String status;

  Voucher({
    required this.voucherId,
    required this.code,
    required this.title,
    required this.discountType,
    required this.discountValue,
    required this.maxDiscount,
    required this.minOrderValue,
    required this.startDate,
    required this.endDate,
    required this.usageLimit,
    required this.usedCount,
    required this.createdByAdmin,
    required this.sellerId,
    required this.status,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        voucherId: json['voucher_id'],
        code: json['code'],
        title: json['title'],
        discountType: json['discount_type'],
        discountValue: json['discount_value'].toDouble(),
        maxDiscount: json['max_discount'].toDouble(),
        minOrderValue: json['min_order_value'].toDouble(),
        startDate: json['start_date'],
        endDate: json['end_date'],
        usageLimit: json['usage_limit'],
        usedCount: json['used_count'],
        createdByAdmin: json['created_by_admin'],
        sellerId: json['seller_id'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'voucher_id': voucherId,
        'code': code,
        'title': title,
        'discount_type': discountType,
        'discount_value': discountValue,
        'max_discount': maxDiscount,
        'min_order_value': minOrderValue,
        'start_date': startDate,
        'end_date': endDate,
        'usage_limit': usageLimit,
        'used_count': usedCount,
        'created_by_admin': createdByAdmin,
        'seller_id': sellerId,
        'status': status,
      };
}
