import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    final Uri url = Uri.parse(
        'https://backendshop-production-3cd7.up.railway.app/api/v1/donhangs/nguoidung/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        orders = data.map((item) => Order.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn hàng của bạn'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _navigateToOrderDetail(orders[index].ma.toString());
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Mã đơn hàng: ${orders[index].ma.toString()}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: 'Tổng tiền ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: ' ${formatCurrency(orders[index].tongtien)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: 'Trạng thái đơn hàng ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: utf8
                                .decode(orders[index].trangthaiDH.codeUnits),
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToOrderDetail(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://backendshop-production-3cd7.up.railway.app/api/v1/donhangs/$orderId'),
      );

      if (response.statusCode == 200) {
        final orderDetail = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId');

        if (userId != null && orderDetail['manguoidung'] == int.parse(userId)) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(orderDetail: orderDetail),
            ),
          );
        }
      } else {
        print('Failed to fetch order details');
      }
    } catch (e) {
      print('Exception: $e');
    }
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

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> orderDetail;

  OrderDetailPage({required this.orderDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã đơn hàng: ${orderDetail["ma"]}',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            Text(
              'Họ tên người nhận: ${utf8.decode(orderDetail["hoten_Nguoinhan"].toString().codeUnits)}',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            Text(
              'Tổng tiền: ${formatCurrency(orderDetail['tongtien'])}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            Text(
              'Trạng thái đơn hàng: ${utf8.decode(orderDetail['trangthaidh'].toString().codeUnits)}',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            SizedBox(height: 20.0),
            Text(
              'Chi tiết đơn hàng:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            if (orderDetail['chitietdonhangs'] != null &&
                orderDetail['chitietdonhangs'].isNotEmpty)
              for (var item in orderDetail['chitietdonhangs'])
                Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(
                      "https://backendshop-production-3cd7.up.railway.app/api/v1/sanphams/images/" +
                          item['sanpham']['hinhthunho'],
                      height: 120, // Đặt chiều cao mong muốn
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      '${utf8.decode(item['sanpham']['ten'].toString().codeUnits)}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Giá: ${formatCurrency(item['gia'])}',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                        Text(
                          'Số lượng: ${item['soluong']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Thành tiền: ${formatCurrency(item['thanhtien'])}',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
            // Add a Divider
          ],
        ),
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

class Order {
  final int ma;
  final double tongtien;
  final String trangthaiDH;

  Order({
    required this.ma,
    required this.tongtien,
    required this.trangthaiDH,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      ma: json['ma'],
      tongtien: json['tongtien'],
      trangthaiDH: json['trangthaiDH'],
    );
  }
}
