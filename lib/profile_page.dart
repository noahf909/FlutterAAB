// profile_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String userName;

  const ProfilePage({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers for the input fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // For form validation
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true; // Indicates whether data is being loaded

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    // Fetch user profile from the server
    final url =
        Uri.parse('http://www.aab.run:5000/api/customers/${widget.userId}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          _nameController.text = responseData['name'];
          _phoneController.text = responseData['phone'];
          _isLoading = false;
        });
      } else {
        // Handle error response
        _showError('Failed to load profile');
      }
    } catch (error) {
      _showError('Error connecting to server: $error');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Perform update profile logic (API call)
      final url =
          Uri.parse('http://www.aab.run:5000/api/customers/${widget.userId}');

      final updatedData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
      };

      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(updatedData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );

          // Update the user's name in the AppBar if changed
          if (_nameController.text != widget.userName) {
            Navigator.pop(context, _nameController.text);
          } else {
            Navigator.pop(context);
          }
        } else {
          // Handle error response
          final responseData = jsonDecode(response.body);
          _showError('Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } catch (error) {
        _showError('Error connecting to server: $error');
      }
    }
  }

  void _deleteAccount() async {
    // Confirm deletion
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirm
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Perform delete account logic (API call)
      final url =
          Uri.parse('http://www.aab.run:5000/api/customers/${widget.userId}');

      try {
        final response = await http.delete(
          url,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account deleted successfully.')),
          );

          // Navigate back and reset the user state
          Navigator.pop(context, 'deleted');
        } else {
          // Handle error response
          final responseData = jsonDecode(response.body);
          _showError('Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } catch (error) {
        _showError('Error connecting to server: $error');
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Profile'), backgroundColor: Colors.grey),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                      // Phone number field
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          // Basic phone number validation
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Update Profile button
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text('Update Profile'),
                      ),
                      SizedBox(height: 20),
                      // Delete Account button
                      ElevatedButton(
                        onPressed: _deleteAccount,
                        child: Text('Delete Account'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red, // Set button color to red
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
