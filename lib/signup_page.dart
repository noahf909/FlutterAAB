// signup_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for the input fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // For form validation
  final _formKey = GlobalKey<FormState>();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      // Perform sign-up logic (API call)
      final url = Uri.parse('http://www.aab.run:5000/api/customers');

      // Collect customer data
      final customerData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text
      };

      try {
        // Make POST request
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(customerData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Parse the response
          final responseData = jsonDecode(response.body);

          // Extract user information
          final userName = responseData['name'];
          final userId = responseData['_id'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-up successful!')),
          );

          // Navigate back and pass the user's data
          Navigator.pop(context, {
            'name': userName,
            'userId': userId,
          });
        } else {
          // Handle error response
          String errorMessage = 'An unknown error occurred';

          if (response.body.isNotEmpty) {
            try {
              final responseData = jsonDecode(response.body);
              if (responseData['error'] != null) {
                errorMessage = responseData['error'];
              } else {
                errorMessage = 'Unexpected response: ${response.body}';
              }
            } catch (e) {
              errorMessage = 'Error parsing response: $e';
            }
          } else {
            errorMessage = 'Empty response from server';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $errorMessage')),
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

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up'), backgroundColor: Colors.grey),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add a basic email format validation
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                // Phone number field
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Add a basic phone number validation
                    if (!RegExp(r'^\d{3}-\d{3}-\d{4}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
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
                      return 'Please enter a password';
                    }
                    // Add password strength validation if desired
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Sign Up button
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
