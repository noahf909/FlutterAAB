import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _message;
  String? _error;
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    final email = _emailController.text;

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _error = 'Please enter a valid email address.';
        _message = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
      _error = null;
    });

    try {
      final url = Uri.parse('http://www.aab.run:5000/api/auth/forgot-password'); // Update with actual API endpoint
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _message = data['message'];
          _error = null;
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _error = data['message'] ?? 'Failed to send email. Please try again.';
          _message = null;
        });
      }
    } catch (err) {
      setState(() {
        _error = 'Error sending email. Please try again.';
        _message = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email address below, and we will send you instructions to reset your password.',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading ? CircularProgressIndicator() : Text('Send Reset Link'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
