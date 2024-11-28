// products_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_model.dart';
import 'cart_item.dart';
import 'cart_page.dart';

class ProductsPage extends StatefulWidget {
  final String initialSearchQuery;

  const ProductsPage({Key? key, this.initialSearchQuery = ''}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<void> _futureProducts;
  List<Product> _allProducts = []; // List to store all products
  List<Product> _filteredProducts = []; // List to store filtered products
  List<CartItem> cartItems = []; // List to store cart items
  final TextEditingController _searchController = TextEditingController(); // Search controller

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
    _searchController.addListener(_onSearchChanged);

    // Set the initial search query if provided
    if (widget.initialSearchQuery.isNotEmpty) {
      _searchController.text = widget.initialSearchQuery;
      // Trigger search after setting the initial query
      _onSearchChanged();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://www.aab.run:5000/api/products'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);

        // Convert JSON to List<Product>
        List<Product> products = jsonResponse
            .map((data) => Product.fromJson(data as Map<String, dynamic>))
            .toList();

        setState(() {
          _allProducts = products;
          _filteredProducts = products;
        });

        // Apply initial search query if present
        if (widget.initialSearchQuery.isNotEmpty) {
          _onSearchChanged();
        }
      } else {
        // Log the error
        print('Failed to load products. Status code: ${response.statusCode}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Log the exception
      print('Error fetching products: $e');
      rethrow;
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _addToCart(CartItem item) {
    setState(() {
      cartItems.add(item);
    });
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: cartItems),
      ),
    ).then((_) {
      setState(() {}); // Refresh in case items were removed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.white,
        elevation: 0, // Remove default shadow
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Expanded to fill the available space
          Expanded(
            child: FutureBuilder<void>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Check if the product list is empty
                  if (_filteredProducts.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }

                  return ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: _filteredProducts[index],
                        onAddToCart: _addToCart,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Show a loading spinner by default
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: cartItems.isNotEmpty
          ? FloatingActionButton(
              onPressed: _navigateToCart,
              child: const Icon(Icons.shopping_cart),
            )
          : null,
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(CartItem) onAddToCart; // Callback to add item to cart

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  SizeOption? _selectedSize; // Tracks the selected size
  int _selectedQuantity = 1; // Tracks the quantity for the selected size

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        leading: widget.product.frontImageUrl.isNotEmpty
            ? Image.network(
                widget.product.frontImageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image_not_supported, size: 50),
        title: Text(widget.product.name),
        subtitle: Text('\$${widget.product.price.toStringAsFixed(2)}'),
        children: [
          // List of sizes
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.product.sizes.length,
            itemBuilder: (context, index) {
              final sizeOption = widget.product.sizes[index];
              final isAvailable = sizeOption.quantity > 0;

              return Container(
                color: _selectedSize?.size == sizeOption.size
                    ? Colors.blue.withOpacity(0.2)
                    : null, // Highlight selected size
                child: ListTile(
                  title: Text(
                    sizeOption.size,
                    style: TextStyle(
                      color: isAvailable ? Colors.black : Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    'Available: ${sizeOption.quantity}',
                    style: TextStyle(
                      color: isAvailable ? Colors.black : Colors.grey,
                    ),
                  ),
                  selected: _selectedSize?.size == sizeOption.size,
                  onTap: isAvailable
                      ? () {
                          setState(() {
                            _selectedSize = sizeOption;
                            _selectedQuantity = 1; // Reset quantity
                          });
                        }
                      : null,
                ),
              );
            },
          ),
          if (_selectedSize != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Quantity:'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: _selectedQuantity > 1
                                ? () {
                                    setState(() {
                                      _selectedQuantity--;
                                    });
                                  }
                                : null,
                          ),
                          Text(_selectedQuantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _selectedQuantity <
                                    _selectedSize!.quantity
                                ? () {
                                    setState(() {
                                      _selectedQuantity++;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () {
                      widget.onAddToCart(
                        CartItem(
                          product: widget.product,
                          sizeOption: _selectedSize!,
                          quantity: _selectedQuantity,
                        ),
                      );

                      // Reset selection
                      setState(() {
                        _selectedSize = null;
                        _selectedQuantity = 1;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}



