// products_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
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

        return products;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = snapshot.data!;

          // Check if the product list is empty
          if (products.isEmpty) {
            return Center(child: Text('No products available.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Show a loading spinner by default
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50);
                },
              )
            : Icon(Icons.image_not_supported, size: 50),
        title: Text(widget.product.name),
        subtitle: Text('\$${widget.product.price.toStringAsFixed(2)}'),
        children: [
          // Display the sizes
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.product.sizes.length,
            itemBuilder: (context, index) {
              final sizeOption = widget.product.sizes[index];
              final isAvailable = sizeOption.quantity > 0;
              return ListTile(
                title: Text(
                  sizeOption.size,
                  style: TextStyle(
                    color: isAvailable ? Colors.black : Colors.grey,
                  ),
                ),
                trailing: Text(
                  'Qty: ${sizeOption.quantity}',
                  style: TextStyle(
                    color: isAvailable ? Colors.black : Colors.grey,
                  ),
                ),
                onTap: isAvailable
                    ? () {
                        // Handle size selection
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
