// checkout_page.dart

import 'package:flutter/material.dart';
import 'cart_item.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
    required this.subtotal,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Here, you would typically send the payment information to your payment gateway

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing payment...')),
      );

      // Simulate a delay for payment processing
      Future.delayed(Duration(seconds: 2), () {
        // After processing, navigate to a confirmation page or reset the cart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful!')),
        );

        // Clear the cart and navigate back to the main page
        Navigator.pop(
            context, true); // Return true to indicate successful payment
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout'), backgroundColor: Colors.grey),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cardholder's Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Cardholder's Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the cardholder\'s name';
                    }
                    return null;
                  },
                ),
                // Card Number
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the card number';
                    }
                    if (value.length != 16) {
                      return 'Card number must be 16 digits';
                    }
                    if (!RegExp(r'^\d{16}$').hasMatch(value)) {
                      return 'Card number must contain only digits';
                    }
                    return null;
                  },
                ),
                // Expiration Date
                TextFormField(
                  controller: _expiryDateController,
                  decoration:
                      InputDecoration(labelText: 'Expiration Date (MM/YY)'),
                  keyboardType: TextInputType.datetime,
                  maxLength: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the expiration date';
                    }
                    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                      return 'Expiration date must be in MM/YY format';
                    }
                    // Add more validation for date if needed
                    return null;
                  },
                ),
                // CVV
                TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the CVV';
                    }
                    if (value.length != 3) {
                      return 'CVV must be 3 digits';
                    }
                    if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                      return 'CVV must contain only digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Total Amount: \$${widget.subtotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _processPayment,
                  child: Text('Pay Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
