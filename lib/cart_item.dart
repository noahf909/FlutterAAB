import 'product_model.dart'; // Import the Product and SizeOption classes

class CartItem {
  final Product product;
  final SizeOption sizeOption;
  int quantity; // Add quantity field

  CartItem({
    required this.product,
    required this.sizeOption,
    required this.quantity, // Quantity is required when adding to the cart
  });

  // Map cart items to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'product': product.id, // Product ID
      'size': sizeOption.size, // Size
      'quantity': quantity, // Selected quantity
    };
  }
}
