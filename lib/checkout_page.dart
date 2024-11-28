import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactEmailController = TextEditingController();

  final Map<String, String> _deliveryAddress = {
    'fullName': '',
    'addressLine1': '',
    'addressLine2': '',
    'city': '',
    'state': '',
    'postalCode': '',
    'country': 'US',
  };

  final Map<String, String> _billingAddress = {
    'fullName': '',
    'addressLine1': '',
    'addressLine2': '',
    'city': '',
    'state': '',
    'postalCode': '',
    'country': 'US',
  };

  bool _useSameAddress = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _contactEmailController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Step 1: Create PaymentIntent on the backend
      final response = await http.post(
        Uri.parse('http://www.aab.run:5000/api/stripe/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': (widget.subtotal * 100).toInt()}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create PaymentIntent');
      }

      final clientSecret = jsonDecode(response.body)['clientSecret'];

      // Step 2: Present the Stripe Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Average at Best',
          billingDetails: BillingDetails(
            email: _contactEmailController.text,
            address: Address(
              line1: _billingAddress['addressLine1'],
              line2: _billingAddress['addressLine2'],
              city: _billingAddress['city'],
              state: _billingAddress['state'],
              postalCode: _billingAddress['postalCode'],
              country: _billingAddress['country'],
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Step 3: Save Order
      await _saveOrder();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );

      Navigator.pop(context, true);
    } catch (error) {
      // If Payment Sheet fails, try manual confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveOrder() async {
    final orderData = {
      'userId': null,
      'products': widget.cartItems.map((item) => item.toJson()).toList(),
      'total': widget.subtotal,
      'address':
          '${_deliveryAddress['addressLine1']}, ${_deliveryAddress['addressLine2']}, ${_deliveryAddress['city']}, ${_deliveryAddress['state']}, ${_deliveryAddress['postalCode']}, ${_deliveryAddress['country']}',
    };

    final response = await http.post(
      Uri.parse('http://www.aab.run:5000/api/stripe/save-order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to save order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Contact Information
                const Text('Contact Information'),
                TextFormField(
                  controller: _contactEmailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Delivery Address
                const Text('Delivery Address'),
                ..._buildAddressFields(_deliveryAddress),

                const SizedBox(height: 20),

                // Billing Address
                CheckboxListTile(
                  title: const Text('Billing Address Same as Delivery Address'),
                  value: _useSameAddress,
                  onChanged: (value) {
                    setState(() {
                      _useSameAddress = value!;
                      if (_useSameAddress) {
                        _billingAddress.addAll(_deliveryAddress);
                      }
                    });
                  },
                ),
                if (!_useSameAddress)
                  const Text('Billing Address'),
                if (!_useSameAddress) ..._buildAddressFields(_billingAddress),

                const SizedBox(height: 20),

                

                const Text('Total:'),
                Text(
                  '\$${widget.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Payment Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _processPayment,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Pay Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAddressFields(Map<String, String> address) {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Full Name'),
        initialValue: address['fullName'],
        onChanged: (value) => address['fullName'] = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Address Line 1'),
        initialValue: address['addressLine1'],
        onChanged: (value) => address['addressLine1'] = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter address line 1';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Address Line 2'),
        initialValue: address['addressLine2'],
        onChanged: (value) => address['addressLine2'] = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'City'),
        initialValue: address['city'],
        onChanged: (value) => address['city'] = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the city';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'State'),
        initialValue: address['state'],
        onChanged: (value) => address['state'] = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the state';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Postal Code'),
        initialValue: address['postalCode'],
        onChanged: (value) => address['postalCode'] = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the postal code';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Country'),
        initialValue: address['country'],
        onChanged: (value) => address['country'] = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the country';
          }
          return null;
        },
      ),
    ];
  }
}
