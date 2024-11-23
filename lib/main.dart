import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customer_provider.dart';
import 'home_page.dart';
import 'products_page.dart';
import 'contacts_page.dart';
import 'signup_page.dart'; // Import the SignUpPage
import 'login_dialog.dart'; // Import the LoginDialog
import 'profile_page.dart'; // Import the ProfilePage

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CustomerProvider(), // Provide the CustomerProvider globally
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Average At Best',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Average At Best'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to open the login dialog
  void _openLoginDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const LoginDialog(),
    );
  }

  // Function to navigate to the sign-up page
  Future<void> _navigateToSignUp() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  // Function to navigate to the profile page
  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the CustomerProvider
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customer = customerProvider.customer;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey,
        actions: customer != null
            ? [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'profile') {
                      _navigateToProfile(context); // Navigate to ProfilePage
                    } else if (value == 'logout') {
                      customerProvider.clearCustomer(); // Log out by clearing customer data
                    }
                  },
                  // Drop-down menu for logged-in user
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Text('Profile'),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Text('Log Out'),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        'Hello, ${customer.name}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ]
            : [
                TextButton(
                  onPressed: _navigateToSignUp,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: _openLoginDialog,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
      ),
      body: Column(
        children: [
          // Tabs below the AppBar
          Container(
            color: Colors.grey,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Home'),
                Tab(text: 'Products'),
                Tab(text: 'Contacts'),
              ],
            ),
          ),
          // Content of the tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                HomePage(),
                ProductsPage(),
                ContactsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
