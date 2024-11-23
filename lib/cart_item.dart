// cart_item.dart

import 'product_model.dart';

class CartItem {
  final Product product;
  final SizeOption sizeOption;

  CartItem({
    required this.product,
    required this.sizeOption,
  });
}
