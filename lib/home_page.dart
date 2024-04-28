import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_example/screens/main_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        textTheme: GoogleFonts.mulishTextTheme(),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
