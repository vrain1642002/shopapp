import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_example/screens/home_screen.dart';
import 'package:shop_example/screens/main_screen.dart';
import 'login_page.dart' as login;
import 'home_page.dart' as home;
import 'register_page.dart' as register;

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => login.LoginPage(),
      '/home': (context) => home.HomePage(),
      '/register': (context) => register.RegistrationPage(),
    },
  ));
}
