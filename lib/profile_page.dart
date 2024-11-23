import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customer_provider.dart';
import 'customer.dart'; // Import your Customer model
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<Map<String, dynamic>> _orders = []; // List to store past orders

  @override
  void initState() {
    super.initState();
    // Prepopulate the form with customer details
    final customer = Provider.of<CustomerProvider>(context, listen: false).customer;
    if (customer != null) {
      _nameController.text = customer.name;
      _phoneController.text = customer.phone;
      _fetchOrders(customer.id); // Fetch past orders for the customer
    }
  }

  Future<void> _fetchOrders(String customerId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://www.aab.run:5000/api/orders/customer/$customerId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _orders = data.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        _showError('Failed to fetch orders');
      }
    } catch (error) {
      _showError('Error fetching orders: $error');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateProfile(CustomerProvider customerProvider) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final customer = customerProvider.customer!;
      final url = Uri.parse('http://www.aab.run:5000/api/customers/${customer.id}');
      final updatedData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
      };

      try {
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(updatedData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );

          final updatedCustomer = Customer(
            id: customer.id,
            name: _nameController.text,
            email: customer.email,
            phone: _phoneController.text,
            orders: customer.orders,
            createdAt: customer.createdAt,
          );
          customerProvider.setCustomer(updatedCustomer);

          Navigator.pop(context);
        } else {
          _showError('Failed to update profile');
        }
      } catch (error) {
        _showError('Error updating profile: $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customer = customerProvider.customer;

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('No customer data available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile'), backgroundColor: Colors.grey),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^\d{3}-\d{3}-\d{4}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Update Profile button
                    ElevatedButton(
                      onPressed: () => _updateProfile(customerProvider),
                      child: const Text('Update Profile'),
                    ),
                    const SizedBox(height: 20),
                    // Past Orders Section
                    const Text(
                      'Your Past Orders:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _orders.isEmpty
                        ? const Text('No past orders found.')
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              final order = _orders[index];
                              return ExpansionTile(
                                title: Text('Order ID: ${order['_id']}'),
                                subtitle: Text('Total: \$${order['total'].toStringAsFixed(2)}'),
                                children: (order['products'] as List<dynamic>).map((product) {
                                  final productName = product['productDetails']?['name'] ?? 'Unknown Product';
                                  final productSize = product['size'];
                                  final productQuantity = product['quantity'];
                                  return ListTile(
                                    title: Text(productName),
                                    subtitle: Text('Size: $productSize | Quantity: $productQuantity'),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
