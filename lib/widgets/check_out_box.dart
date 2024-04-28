import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/models/cart_item.dart';

import '../order_page.dart';

class CheckOutBox extends StatelessWidget {
  final List<CartItem> items;
  const CheckOutBox({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ),
              filled: true,
              fillColor: kcontentColor,
              hintText: "Nhập mã khuyến mãi",
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              suffixIcon: TextButton(
                onPressed: () {},
                child: const Text(
                  "Apply",
                  style: TextStyle(
                    color: kprimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tạm tính",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                formatCurrency(items.length > 1
                    ? items
                        .map<double>((e) => e.quantity * e.product.price)
                        .reduce((value1, value2) => value1 + value2)
                    : items[0].product.price * items[0].quantity),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thành tiền",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatCurrency(items.length > 1
                    ? items
                        .map<double>((e) => e.quantity * e.product.price)
                        .reduce((value1, value2) => value1 + value2)
                    : items[0].product.price * items[0].quantity),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              double totalAmount = items.length > 1
                  ? items
                      .map<double>((e) => e.quantity * e.product.price)
                      .reduce((value1, value2) => value1 + value2)
                  : items[0].product.price * items[0].quantity;
              if (totalAmount > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CheckoutPage(totalAmount: totalAmount),
                  ),
                );
              } else
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đơn hàng chưa có sản phẩm nào'),
                    duration: Duration(seconds: 2),
                  ),
                );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              minimumSize: const Size(double.infinity, 55),
            ),
            child: const Text(
              "Đặt hàng",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
