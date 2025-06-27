class User {
  final int? userId;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? address;
  final DateTime? dayOfBirth;
  final String? role;
  final String? avatarUrl;
  final String? status;
  final DateTime? createdAt;

  User({
    this.userId,
    this.email,
    this.fullName,
    this.phone,
    this.address,
    this.dayOfBirth,
    this.role,
    this.avatarUrl,
    this.status,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      dayOfBirth: json['dayOfBirth'] != null ? DateTime.parse(json['dayOfBirth']) : null,
      role: json['role'],
      avatarUrl: json['avatarUrl'],
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'dayOfBirth': dayOfBirth?.toIso8601String(),
      'role': role,
      'avatarUrl': avatarUrl,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}