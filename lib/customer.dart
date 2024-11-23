// customer.dart
class Customer {
  final String id; // MongoDB _id
  final String name;
  final String email;
  final String phone;
  final List<String> orders; // List of order IDs
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.orders = const [], // Default to an empty list if no orders are provided
    required this.createdAt,
  });

  // Factory constructor to create a Customer object from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      orders: List<String>.from(json['orders'] ?? []), // Ensure orders is a list
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert a Customer object to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'orders': orders,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
