import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/models/category.dart';
import 'package:shop_example/models/product.dart';
import 'package:shop_example/widgets/home_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:shop_example/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Category>> _categories;
  late List<Product> _products = [];
  int? _selectedCategoryId;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = 0;
    _categories = _fetchCategories();
    _fetchProducts();
  }

  Future<List<Category>> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(
          'https://backendshop-production-3cd7.up.railway.app/api/v1/danhmucsanphams?page=0&limit=100'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((category) => Category.fromJson(category)).toList();
      } else {
        throw Exception(
            'Failed to load categories! Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error loading categories: $error');
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(
          'https://backendshop-production-3cd7.up.railway.app/api/v1/sanphams?page=0&limit=100&keyword=$_searchKeyword&Ma=$_selectedCategoryId'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data is Map<String, dynamic> && data.containsKey("sanphams")) {
          final List<dynamic> productList = data["sanphams"];
          setState(() {
            _products = productList
                .map((product) => Product.fromJson(product))
                .toList();
          });
        } else {
          throw Exception(
              "Invalid API response format: Key 'sanphams' not found or not a list");
        }
      } else {
        throw Exception(
            'Failed to load product list! Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error loading product list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Danh sách sản phẩm",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: kcontentColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Ionicons.search,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _searchKeyword = value;
                                    _fetchProducts();
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: "Search...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                FutureBuilder<List<Category>>(
                  future: _categories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No categories found');
                    } else {
                      List<Category> categories = snapshot.data!;
                      return DropdownButton<int>(
                        value: _selectedCategoryId,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedCategoryId = value;
                            _fetchProducts();
                          });
                        },
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text('Tất Cả'),
                          ),
                          ...categories.map(
                            (category) => DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(utf8.decode(category.name.codeUnits)),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: _products[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
