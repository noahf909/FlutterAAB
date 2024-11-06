import 'package:flutter/material.dart';

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
        primarySwatch: Colors.deepPurple,
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
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Tabs below the AppBar
          Container(
            color: Colors.deepPurple,
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
              children: [
                // Home Tab Content
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Banner with Search Bar
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for products...',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // Best Selling Items Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Best Selling Items',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('See More'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 150.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: 120.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage('assets/item1.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            Container(
                              width: 120.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage('assets/item2.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            Container(
                              width: 120.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage('assets/item3.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // About Us Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // About Us Details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: const [
                            ListTile(
                              leading: Icon(Icons.shopping_bag, size: 40.0),
                              title: Text('Large Assortment of Items',
                                  style: TextStyle(fontSize: 16.0)),
                            ),
                            ListTile(
                              leading: Icon(Icons.local_shipping, size: 40.0),
                              title: Text('Fast and Free Shipping',
                                  style: TextStyle(fontSize: 16.0)),
                            ),
                            ListTile(
                              leading: Icon(Icons.support_agent, size: 40.0),
                              title: Text('24/7 Support',
                                  style: TextStyle(fontSize: 16.0)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Products Tab Content
                const Center(child: Text('Products Page')),
                // Contacts Tab Content
                const Center(child: Text('Contacts Page')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
