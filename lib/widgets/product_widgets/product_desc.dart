import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_example/constants.dart';

class ProductDescription extends StatelessWidget {
  final String text;
  const ProductDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Mô tả:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, // Add underline decoration
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
