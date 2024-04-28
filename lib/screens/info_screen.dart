import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_example/home_page.dart';
import 'package:shop_example/service/user_profile_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_example/widgets/home_appbar.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  DateTime? _selectedDate;
  late UserProfileService _userProfileService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _loadUserProfileData();
  }

  void _loadUserProfileData() async {
    try {
      Map<String, dynamic> userData =
          await _userProfileService.getUserProfile();
      setState(() {
        _fullNameController.text =
            utf8.decode(userData["hoten"].codeUnits) ?? '';
        _addressController.text =
            utf8.decode(userData["diachi"].codeUnits) ?? '';
        _selectedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .parse(userData['ngaysinh'] ?? '');
        _selectedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .parse(userData['ngaysinh'] ?? '');
      });
    } catch (error) {
      print('Error loading user profile data: $error');
    }
  }

  void _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> updatedData = {
          'hoten': _fullNameController.text,
          'diachi': _addressController.text,
          'ngaysinh': DateFormat("yyyy-MM-dd").format(_selectedDate!),
          'matkhau': _passwordController.text,
          'nhatlaimatkhau': _retypePasswordController.text,
        };

        await _userProfileService.updateUserProfile(updatedData);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cập nhật thành công'),
              content: Text('Cập nhật thông tin thành công'),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );

        // Chuyển trang về home

        // Handle success (if needed)
      } catch (error) {
        print('Error updating user profile: $error');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameController,
                style: TextStyle(fontSize: 18.0), // Increase text size
                decoration: InputDecoration(labelText: 'Họ và tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hãy nhập họ tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                style: TextStyle(fontSize: 18.0), // Increase text size
                decoration: InputDecoration(labelText: 'Địa chỉ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hãy nhập địa chỉ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8.0),
                    Text(
                      _selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                          : 'Chọn ngày sinh',
                      style: TextStyle(fontSize: 18.0), // Increase text size
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: TextStyle(fontSize: 18.0), // Increase text size
                decoration: InputDecoration(
                  labelText: 'Nhập mật khẩu mới',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hãy nhập lại mật khẩu mới';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _retypePasswordController,
                obscureText: !_isPasswordVisible,
                style: TextStyle(fontSize: 18.0), // Increase text size
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nhập lại mật khẩu';
                  } else if (value != _passwordController.text) {
                    return 'Nhập lại mật khẩu không chính xác';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateUserProfile();
                  }
                },
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
