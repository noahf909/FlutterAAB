// product_model.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final int quantity;
  final String frontImageUrl;
  final String backImageUrl;
  final List<SizeOption> sizes;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.frontImageUrl,
    required this.backImageUrl,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var sizesList = json['sizes'] as List<dynamic>? ?? [];
    List<SizeOption> sizes = sizesList
        .map((size) => SizeOption.fromJson(size as Map<String, dynamic>))
        .toList();

    return Product(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      frontImageUrl: json['frontImageUrl']?.toString() ?? '',
      backImageUrl: json['backImageUrl']?.toString() ?? '',
      sizes: sizes,
    );
  }
}

class SizeOption {
  final String size;
  final int quantity;
  final String id;

  SizeOption({
    required this.size,
    required this.quantity,
    required this.id,
  });

  factory SizeOption.fromJson(Map<String, dynamic> json) {
    return SizeOption(
      size: json['size'],
      quantity: json['quantity'],
      id: json['_id'],
    );
  }
}
