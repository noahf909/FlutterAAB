// customer_provider.dart
import 'package:flutter/material.dart';
import 'customer.dart'; // Import your Customer model

class CustomerProvider extends ChangeNotifier {
  Customer? _customer; // The currently logged-in customer, or null if no one is logged in

  // Getter for the customer
  Customer? get customer => _customer;

  // Setter to set or update the customer
  void setCustomer(Customer newCustomer) {
    _customer = newCustomer;
    notifyListeners(); // Notify listeners that the customer state has changed
  }

  // Method to clear the customer (e.g., on logout)
  void clearCustomer() {
    _customer = null;
    notifyListeners(); // Notify listeners that the customer state has been cleared
  }
}
