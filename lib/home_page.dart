// home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onExploreNow; // Accept the callback

  const HomePage({Key? key, required this.onExploreNow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner with Text and Search Bar
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFaacfcf), // Color: #aacfcf
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                // Title Text
                Text(
                  'Made for the Average Runner',
                  style: TextStyle(
                    fontSize: 24.0, // Big text size
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                // Subtitle Text
                Text(
                  '50+ Products | 100+ Customers',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                // Search Bar
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for products...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white, // White background for input
                  ),
                ),
              ],
            ),
          ),
          // About Us Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'About Us',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center, // Centered heading
            ),
          ),
          const SizedBox(height: 8.0),
          // About Us Paragraph
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'At Average at Best, we started with a simple idea: running is for everyone. Whether you\'re starting your journey or simply looking for comfortable, affordable gear to keep up with your daily run, we’re here for you. We\'re here to celebrate the everyday runner, the ones who believe that running is more about the journey than the destination. So, whether you\'re setting new personal records or just getting started, we\'re with you every step of the way.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center, // Centered paragraph
            ),
          ),
          const SizedBox(height: 24.0),
          // Icons Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _IconWithText(
                  icon: Icons.directions_run,
                  title: 'Performance',
                  description:
                      'Unlock your potential and give your best with gear designed to support every step of your journey.',
                ),
                _IconWithText(
                  icon: Icons.public,
                  title: 'Community',
                  description:
                      'Join a global community of runners where every stride is shared and every milestone is celebrated.',
                ),
                _IconWithText(
                  icon: Icons.eco,
                  title: 'Quality',
                  description:
                      'Crafted with care, built to last, and designed to leave a lighter footprint on the planet.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          // Shop by Category Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  'Shop by Category',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center, // Centered heading
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Find what you are looking for',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center, // Centered subtitle
                ),
                const SizedBox(height: 16.0),
                // Box with images
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFaacfcf),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CategoryItem(
                        imagePath: 'assets/mens_item.jpg', // Replace with your image path
                        label: 'Men',
                      ),
                      _CategoryItem(
                        imagePath: 'assets/womens_item.jpg', // Replace with your image path
                        label: 'Women',
                      ),
                      _CategoryItem(
                        imagePath: 'assets/accessories_item.jpg', // Replace with your image path
                        label: 'Accessories',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          // Explore All AAB Products Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  'Explore All AAB Products',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center, // Centered heading
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Browse our full range of running apparel and accessories to find the perfect gear for your journey.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center, // Centered paragraph
                ),
                const SizedBox(height: 16.0),
                // Explore Now Button
                ElevatedButton(
                  onPressed: onExploreNow, // Use the callback
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFaacfcf), // Button color same as search bar box
                  ),
                  child: const Text(
                    'Explore Now',
                    style: TextStyle(
                      color: Colors.white, // White text
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}

class _IconWithText extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _IconWithText({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Circle with icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFFaacfcf), // Circle color same as search bar box
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, size: 40.0, color: Colors.white), // White icon
          ),
        ),
        const SizedBox(height: 8.0),
        // Title text
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        // Description text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center, // Centered text
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String imagePath;
  final String label;

  const _CategoryItem({
    Key? key,
    required this.imagePath,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
