import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/home_page.dart';
import 'package:shop_example/models/cart_item.dart';
import 'package:shop_example/models/product.dart';
import 'package:shop_example/service/product_service.dart';
import 'package:shop_example/widgets/cart_tile.dart';
import 'package:shop_example/widgets/check_out_box.dart';
import 'package:shop_example/service/cart_service.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ProductService productService = ProductService();

  late Future<void> productDetailsFuture;
  Map<int, Map<String, dynamic>> productDetails = {};
  late List<Product> _products = [];
  bool _cartEmpty = false;

  @override
  void initState() {
    super.initState();
    // Initialize the Future in initState
    productDetailsFuture = loadProductDetails();
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

  Future<void> loadProductDetails() async {
    Map<int, int> cart = cartService.getCart();

    productDetails = {}; // Initialize the map here

    for (int productId in cart.keys) {
      Map<String, dynamic> details =
          await productService.getProductDetails(productId);
      productDetails[productId] = details;
    }

    // Force a rebuild of the widget tree
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateCartQuantity(
    int productId,
    int newQuantity,
    Function() onQuantityUpdated,
  ) async {
    if (newQuantity > 0) {
      cartService.updateCartQuantity(productId, newQuantity);
    } else {
      // Remove the product ID from the cart if the quantity is 0
      cartService.removeProductFromCart(productId);
    }

    // Reload product details after updating the cart
    await loadProductDetails();
    // Callback to notify that the quantity has been updated
    onQuantityUpdated();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, int> cart = cartService.getCart();
    final List<CartItem> cartItems = [];

    // Duyệt qua từng phần tử trong danh sách _products
    for (var product in _products) {
      // Kiểm tra xem sản phẩm có trong giỏ hàng không
      if (cart.containsKey(product.id)) {
        // Lấy số lượng từ giỏ hàng
        var quantity = cart[product.id];

        // Kiểm tra và xử lý giá trị null trước khi sử dụng
        if (quantity != null) {
          // Tạo CartItem từ sản phẩm và số lượng
          var cartItem = CartItem(quantity: quantity, product: product);

          // Thêm cartItem vào danh sách cartItems
          cartItems.add(cartItem);
        }
      }
    }

    if (cartItems.isEmpty) {
      // Thêm một mục giả vào danh sách nếu giỏ hàng trống
      cartItems.add(CartItem(
          quantity: 0,
          product: Product(
              id: -1, title: "", price: 0, description: '', image: '')));
      _cartEmpty = true;
    } else {
      _cartEmpty = false;
    }

    return Scaffold(
      backgroundColor: kcontentColor,
      appBar: AppBar(
        backgroundColor: kcontentColor,
        centerTitle: true,
        title: const Text(
          "Giỏ hàng",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth:
            100, // Đảm bảo độ rộng đủ để chứa các icon và khoảng cách giữa chúng
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(Ionicons.chevron_back),
              ),
              const SizedBox(width: 10), // Khoảng cách giữa các icon
              IconButton(
                onPressed: () {
                  cartService.clearCart();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                  // Xử lý khi nhấn vào icon mới
                },
                icon: const Icon(
                  Ionicons.trash_outline,
                  color: Colors.red,
                  size: 25,
                ), // Thêm icon mới vào đây
              ),
            ],
          ),
        ),
      ),
      bottomSheet: CheckOutBox(
        items: cartItems,
      ),
      body: _cartEmpty
          ? Center(
              child: Text(
                'Giỏ hàng rỗng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) => CartTile(
                  item: cartItems[index],
                  De: () {
                    final currentQuantity = cartItems[index].quantity;
                    cartService
                        .removeProductFromCart(cartItems[index].product.id);
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                  onRemove: () {
                    final currentQuantity = cartItems[index].quantity;
                    if (currentQuantity != 1) {
                      updateCartQuantity(
                          cartItems[index].product.id, currentQuantity - 1, () {
                        setState(() {
                          cartItems[index].quantity = currentQuantity - 1;
                        });
                      });
                    }
                  },
                  onAdd: () {
                    final currentQuantity = cartItems[index].quantity;
                    updateCartQuantity(
                        cartItems[index].product.id, currentQuantity + 1, () {
                      setState(() {
                        cartItems[index].quantity = currentQuantity + 1;
                      });
                    });
                  }),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: cartItems.length,
            ),
    );
  }
}
