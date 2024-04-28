import 'dart:convert';
import 'package:iconsax/iconsax.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_example/register_page.dart';
import 'package:shop_example/screens/main_screen.dart';

import 'service/user_profile_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserProfileService _userProfileService;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hãy nhập email';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hãy nhập mật khẩu';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? re = prefs.getBool('rememberMe');

    if (re == true) {
      // Nếu có token, chuyển đến trang home
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneNumber', _phoneNumberController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setBool('rememberMe', rememberMe);
  }

  void _login() async {
    final apiUrl =
        'https://backendshop-production-3cd7.up.railway.app/api/v1/nguoidungs/dangnhap';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'SDT': _phoneNumberController.text,
        'Matkhau': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Đăng nhập thành công');

      // Lấy token từ response
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];

      // Lấy mã người dùng từ UserProfileService
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Lưu người dùng đang đăng nhập
        prefs.setString('token', token);
        Map<String, dynamic> userData =
            await _userProfileService.getUserProfile();
        final String userId =
            userData['ma'].toString() ?? ""; // Replace 'ma' with the actual key

        // Lưu mã người dùng
        prefs.setString('userId', userId);

        // Lưu thông tin đăng nhập nếu người dùng chọn ghi nhớ đăng nhập
        if (rememberMe) {
          // Lưu token vào SharedPreferences
          prefs.setString('token1', token);
          await _saveCredentials();
        }

        // Chuyển đến trang home
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } catch (error) {
        print('Error fetching user profile data: $error');
      }
    } else {
      print('Đăng nhập thất bại');

      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đăng nhập thất bại'),
            content: Text('Nhập thông tin tài khoản sai'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/facion.png', // Replace with the path to your image asset
                  width: 120.0, // Adjust the width as needed
                  height: 120.0, // Adjust the height as needed
                ),
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 16),
                const Text('Hãy đăng nhập và bắt đầu mua sắm'),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SDT',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneNumberController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: 'Hãy nhập số điện thoại'),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Mật khẩu',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Hãy nhập mật khẩu',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: _passwordValidator,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Các widget khác ở đây...
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: _toggleRememberMe,
                              ),
                              const Text(
                                'Ghi nhớ',
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // Implement forgot password
                                    },
                                    child: const Text(
                                      'Quên mật khẩu',
                                      style:
                                          TextStyle(color: Color(0xFF3D80DE)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Các widget khác ở đây...
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: "Chưa có tài khoản? ",
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Đăng kí',
                        style: const TextStyle(color: Colors.green),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()),
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
    );
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      rememberMe = value ?? false;
    });
  }
}
