import 'package:shop_example/models/product.dart';

class CartItem {
  int quantity;
  Product product;

  CartItem({
    required this.quantity,
    required this.product,
  });
}
