import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';

class AddToCart extends StatelessWidget {
  final Function() onAdd;
  final Function() onRemove;
  final Function() addCart;

  const AddToCart({
    super.key,
    required this.currentNumber,
    required this.onAdd,
    required this.onRemove,
    required this.addCart,

  });

  final int currentNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentNumber.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: onAdd,
                    iconSize: 18,
                    icon: const Icon(
                      Ionicons.add_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed:addCart,
              style: TextButton.styleFrom(
                backgroundColor: kprimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40),
              ),
              child: const Text(
                "Thêm vào giỏ hàng",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
