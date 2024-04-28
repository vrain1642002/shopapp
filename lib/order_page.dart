import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_example/screens/cart_screen.dart';
import 'package:shop_example/screens/myorder_screen.dart';
import 'package:shop_example/service/cart_service.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount;

  var cartService;

  CheckoutPage({required this.totalAmount});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController hoTenController = TextEditingController();
  TextEditingController sdtController = TextEditingController();
  TextEditingController ghiChuController = TextEditingController();
  TextEditingController diaChiController = TextEditingController();
  String? phuongThucVanChuyen;
  String? phuongThucThanhToan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: hoTenController,
                decoration: InputDecoration(labelText: 'Họ tên người nhận'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Họ tên không được để trống';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: sdtController,
                decoration:
                    InputDecoration(labelText: 'Số điện thoại người nhận'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Số điện thoại không được để trống';
                  }
                  if (value.length != 10) {
                    return 'Số điện thoại phải có 10 chữ số';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ghiChuController,
                decoration: InputDecoration(labelText: 'Ghi chú'),
              ),
              TextFormField(
                controller: diaChiController,
                decoration: InputDecoration(labelText: 'Địa chỉ giao hàng'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Địa chỉ không được để trống';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: phuongThucVanChuyen,
                onChanged: (String? newValue) {
                  setState(() {
                    phuongThucVanChuyen = newValue;
                  });
                },
                items: ['Giao nhanh', 'Giao thường']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration:
                    InputDecoration(labelText: 'Phương thức vận chuyển'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn phương thức vận chuyển';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: phuongThucThanhToan,
                onChanged: (String? newValue) {
                  setState(() {
                    phuongThucThanhToan = newValue;
                  });
                },
                items: ['Thanh toán khi giao hàng', 'Chuyển khoản']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration:
                    InputDecoration(labelText: 'Phương thức thanh toán'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn phương thức thanh toán';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Nếu tất cả các trường đều hợp lệ, thì tiến hành đặt hàng
                    _placeOrder();
                  }
                },
                child: Text('Đặt hàng'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
                child: Text('Quay về trang giỏ hàng'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Tổng tiền: ${formatCurrency(widget.totalAmount)}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _placeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? token = prefs.getString('token'); // Lấy token từ local storage

    if (userId == null || token == null) {
      // Xử lý trường hợp không có mã người dùng hoặc token
      return;
    }

    List<Map<String, dynamic>> cartItems = [];
    CartService cartService = CartService();

    Map<int, int> cart = cartService.getCart();

    cartItems = cart.entries.map((entry) {
      return {'product_id': entry.key, 'quantity': entry.value};
    }).toList();

    Map<String, dynamic> orderData = {
      'Ma_Nguoidung': userId,
      'Hoten_Nguoinhan': hoTenController.text,
      'SDT_Nguoinhan': sdtController.text,
      'Ghichu': ghiChuController.text,
      'Diachigiaohang': diaChiController.text,
      'Phuongthucvanchuyen': phuongThucVanChuyen ?? '',
      'Phuongthucthanhtoan': phuongThucThanhToan ?? '',
      'Tongtien': widget.totalAmount,
      'cart_items': cartItems,
    };

    // Tạo headers với Authorization header chứa token
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      // Gửi orderData lên server
      final response = await http.post(
        Uri.parse(
            'https://backendshop-production-3cd7.up.railway.app/api/v1/donhangs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(orderData),
      );

      // Kiểm tra và xử lý phản hồi từ server
      if (response.statusCode == 200) {
        // Xử lý phản hồi thành công
        // Lấy token từ response
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String ma = responseData['ma'].toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Đặt hàng thành công với mã đơn hàng là $ma ,hãy theo dõi trạng thái đơn'),
            duration: Duration(seconds: 2),
          ),
        );
        cartService.clearCart();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyOrderScreen(),
          ),
        );
      } else {
        // Xử lý phản hồi không thành công

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đặt hàng không thành công '),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Xử lý lỗi kết nối hoặc lỗi khác
      print('Đã xảy ra lỗi: $error');
    }
  }

  String formatCurrency(double amount) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return currencyFormat.format(amount);
  }
}
