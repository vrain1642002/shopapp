import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../screens/cart_screen.dart';

class ProductAppBar extends StatelessWidget {
  const ProductAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            icon: const Icon(Ionicons.chevron_back),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            icon: const Icon(Ionicons.cart),
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            icon: const Icon(Ionicons.share_social_outline),
          ),
        ],
      ),
    );
  }
}
