// home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  title: Text('24/7 Support', style: TextStyle(fontSize: 16.0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String imagePath;

  const ItemCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
