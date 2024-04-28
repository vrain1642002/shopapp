import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/models/product.dart';
import 'package:shop_example/service/cart_service.dart';
import 'package:shop_example/widgets/product_card.dart';
import 'package:shop_example/widgets/product_widgets/add_to_cart.dart';
import 'package:shop_example/widgets/product_widgets/appbar.dart';
import 'package:shop_example/widgets/product_widgets/image_slider.dart';
import 'package:shop_example/widgets/product_widgets/information.dart';
import 'package:shop_example/widgets/product_widgets/product_desc.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int currentImage = 0;
  int currentColor = 0;
  int currentNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      floatingActionButton: AddToCart(
        currentNumber: currentNumber,
        onAdd: () {
          setState(() {
            currentNumber++;
          });
        },
        onRemove: () {
          if (currentNumber != 1) {
            setState(() {
              currentNumber--;
            });
          }
        },
        addCart: () {
          CartService().addToCart(widget.product.id, quantity: currentNumber);

          // Optionally, you can display a message to indicate that the item has been added to the cart.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Đã thêm $currentNumber sản phẩm ${widget.product.title} vào giỏ hàng.'),
              duration: Duration(seconds: 2),
                                 

            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProductAppBar(),
              ImageSlider(
                onChange: (index) {
                  setState(() {
                    currentImage = index;
                  });
                },
                currentImage: currentImage,
                image: widget.product.image,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: currentImage == index ? 15 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      color: currentImage == index
                          ? Colors.black
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  right: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductInfo(product: widget.product),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    ProductDescription(text: widget.product.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
