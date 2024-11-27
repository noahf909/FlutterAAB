// cart_page.dart

import 'package:flutter/material.dart';
import 'cart_item.dart';
import 'checkout_page.dart'; // Import the CheckoutPage

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get subtotal {
    return widget.cartItems.fold(
      0.0,
      (total, item) => total + item.product.price,
    );
  }

  void _continueToCheckout() async {
    // Navigate to the CheckoutPage
    final paymentSuccessful = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cartItems: widget.cartItems,
          subtotal: subtotal,
        ),
      ),
    );

    if (paymentSuccessful == true) {
      // Clear the cart items if payment was successful
      setState(() {
        widget.cartItems.clear();
      });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your purchase!')),
      );
      Navigator.pop(context);
    }
  }

  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item removed from cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.grey,
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = widget.cartItems[index];
                      return ListTile(
                        leading: cartItem.product.frontImageUrl.isNotEmpty
                            ? Image.network(
                                cartItem.product.frontImageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              )
                            : const Icon(Icons.image_not_supported, size: 50),
                        title: Text(cartItem.product.name),
                        subtitle: Text('Size: ${cartItem.sizeOption.size}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${cartItem.product.price.toStringAsFixed(2)}',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _removeItem(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: _continueToCheckout,
                  child: const Text('Continue to Checkout'),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
