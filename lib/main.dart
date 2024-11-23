// main.dart
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'products_page.dart';
import 'contacts_page.dart';
import 'signup_page.dart'; // Import the SignUpPage
import 'login_dialog.dart'; // Import the LoginDialog
import 'profile_page.dart'; // Import the ProfilePage

void main() {
  runApp(const MyApp());
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
  String? _userName; // Variable to store the user's name

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

  void _openLoginDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => LoginDialog(),
    );

    if (result != null && result is String) {
      setState(() {
        _userName = result; // Update the user's name
      });
    }
  }

  Future<void> _navigateToSignUp() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );

    if (result != null && result is String) {
      setState(() {
        _userName = result; // Update the user's name
      });
    }
  }

  /*void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(userName: _userName!)),
    );
  }*/

  void _logOut() {
    setState(() {
      _userName = null; // Clear the user's name to log out
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey,
        actions: _userName != null
            ? [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'profile') {
                      //_navigateToProfile();
                    } else if (value == 'logout') {
                      _logOut();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Text('Profile'),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Text('Log Out'),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        'Hello, $_userName',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ]
            : [
                TextButton(
                  onPressed: _navigateToSignUp,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: _openLoginDialog,
                  child: Text(
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
