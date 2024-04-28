import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shop_example/login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  DateTime? _selectedDate; // Ngày sinh được chọn
  bool showPassword = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final apiUrl =
          'https://backendshop-production-3cd7.up.railway.app/api/v1/nguoidungs/dangki';

      DateTime? selectedDate = _selectedDate;
      final formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate ?? DateTime.now());

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Ma_Vaitro": 2,
          "SDT": _phoneNumberController.text,
          "Hoten": _fullNameController.text,
          "Diachi": _addressController.text,
          "Matkhau": _passwordController.text,
          "Nhaplaimatkhau": _confirmPasswordController.text,
          'Ngaysinh': formattedDate,
        }),
      );

      if (response.statusCode == 200) {
        print('Đăng ký thành công');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Đăng kí thành công'),
              content: Text('Đăng kí tài khoản thành công'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        await Future.delayed(Duration(seconds: 2));

        // Chuyển trang về home
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('Đăng ký thất bại');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Đăng kí thất bại'),
              content: Text('SDT đã được sử dụng'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        // Xử lý lỗi hoặc hiển thị thông báo thất bại
      }
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat('dd/MM/yyyy').format(date);
    }
    return 'Chọn ngày sinh';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tạo tài khoản',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.green,
                        ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Số điện thoại',
                      labelStyle:
                          TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Họ và tên',
                      labelStyle:
                          TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ và tên';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Địa chỉ',
                      labelStyle:
                          TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(
                          !showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                      labelStyle:
                          TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      hintText: 'Nhập lại mật khẩu',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(
                          !showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                      labelStyle:
                          TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập lại mật khẩu';
                      } else if (value != _passwordController.text) {
                        return 'Mật khẩu không khớp';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(
                        _formatDate(_selectedDate),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register();
                      }
                    },
                    child: const Text(
                      'Đăng kí',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: "Đã có tài khoản? ",
                      style: const TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Đăng nhập',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
