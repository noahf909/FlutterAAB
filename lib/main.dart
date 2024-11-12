// main.dart
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'products_page.dart';
import 'contacts_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey,
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
