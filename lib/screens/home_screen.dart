import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/models/category.dart';
import 'package:shop_example/models/product.dart';
import 'package:shop_example/screens/products_screen.dart';
import 'package:shop_example/widgets/home_appbar.dart';
import 'package:shop_example/widgets/home_slider.dart';
import 'package:shop_example/widgets/product_card.dart';
import 'package:shop_example/widgets/search_field.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlide = 0;
  List<Product> _products = [
    Product(
      id: 0,
      title: "",
      description: "",
      image: "assets/load.png",
      price: 0,
    ),
    Product(
      id: 1,
      title: "",
      description: "",
      image: "assets/load.png",
      price: 0,
    ),
    Product(
      id: 2,
      title: "",
      description: "",
      image: "assets/load.png",
      price: 0,
    ),
    Product(
      id: 3,
      title: "",
      description: "",
      image: "assets/load.png",
      price: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(
          'https://backendshop-production-3cd7.up.railway.app/api/v1/sanphams?page=0&limit=100&Ma=0'));

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
                const SearchField(),
                const SizedBox(height: 20),
                HomeSlider(
                  onChange: (value) {
                    setState(() {
                      currentSlide = value;
                    });
                  },
                  currentSlide: currentSlide,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Dành cho bạn",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsScreen()),
                        );
                      },
                      child: const Text("Xem tất cả"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: 4,
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
