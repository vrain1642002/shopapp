import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/models/cart_item.dart';
import 'package:shop_example/service/cart_service.dart';

late CartService cartService = CartService();

class CartTile extends StatelessWidget {
  final CartItem item;
  final Function() onRemove;
  final Function() onAdd;
  final Function() De;
  const CartTile(
      {super.key,
      required this.item,
      required this.onRemove,
      required this.onAdd,
       required this.De});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  color: kcontentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.network(
                  item.product.image,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formatCurrency(item.product.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "=>" + formatCurrency(item.product.price * item.quantity),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                 onPressed: De,
                icon: const Icon(
                  Ionicons.trash_outline,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: kcontentColor,
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onRemove,
                      iconSize: 18,
                      icon: const Icon(
                        Ionicons.remove_outline,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: onAdd,
                      iconSize: 18,
                      icon: const Icon(
                        Ionicons.add_outline,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  String formatCurrency(double price) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return currencyFormat.format(price);
  }
}
