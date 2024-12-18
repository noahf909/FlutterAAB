// login_dialog.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'customer_provider.dart'; // Your CustomerProvider class
import 'forgot_password.dart'; //import forgot password 
import 'customer.dart'; // Your Customer model

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  // Controllers for the input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // For form validation
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Perform login logic (API call)
      final url = Uri.parse('http://www.aab.run:5000/api/customers/login');

      final loginData = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      try {
        // Make POST request
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(loginData),
        );

        if (response.statusCode == 200) {
          // Parse the response
          final responseData = jsonDecode(response.body);

          // Create a Customer object from the response data
          final customerData = responseData['customer'];
          final customer = Customer.fromJson(customerData);

          // Save the customer in CustomerProvider
          Provider.of<CustomerProvider>(context, listen: false).setCustomer(customer);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful!')),
          );

          // Close the dialog
          Navigator.of(context).pop();
        } else {
          // Handle error response
          final responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['error']}')),
          );
        }
      } catch (error) {
        // Handle network or parsing errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to server: $error')),
        );
      }
    }
  }

  void _forgotPassword() {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ForgotPasswordPage(),
    ),
  );
}

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Login'),
      content: Form(
        key: _formKey, // Assign the form key
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Email field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // Basic email validation
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            // Password field
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // Hide the password text
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),

        // Forgot Password button
        TextButton(
          onPressed: _forgotPassword,
          child: Text('Forgot Password?'),
        ),

        // Login button
        ElevatedButton(
          onPressed: _login,
          child: Text('Login'),
        ),
      ],
    );
  }
}
