import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/screens/cart_screen.dart';
import 'package:shop_example/screens/home_screen.dart';
import 'package:shop_example/screens/info_screen.dart';
import 'package:shop_example/screens/myorder_screen.dart';
import 'package:shop_example/screens/product_screen.dart';
import 'package:shop_example/screens/products_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentTab = 2;
          });
        },
        shape: const CircleBorder(),
        backgroundColor: kprimaryColor,
        child: const Icon(
          Ionicons.home,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        height: 70,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => setState(() {
                currentTab = 0;
              }),
              icon: Icon(
                Ionicons.grid_outline,
                color: currentTab == 0 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                currentTab = 1;
              }),
              icon: Icon(
                Ionicons.receipt,
                color: currentTab == 1 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                currentTab = 3;
              }),
              icon: Icon(
                Ionicons.cart_outline,
                color: currentTab == 3 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                currentTab = 4;
              }),
              icon: Icon(
                Ionicons.person_outline,
                color: currentTab == 4 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading indicator while waiting for data
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Return an error message if an error occurs
            return Center(
              child: Text('Error loading data: ${snapshot.error}'),
            );
          } else {
            // Data has been loaded successfully, display the appropriate screen
            return screens[currentTab];
          }
        },
      ),
    );
  }

  Future<void> _getData() async {
    // Simulate fetching data with a delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));
  }

  final List<Widget> screens = [
    ProductsScreen(),
    MyOrderScreen(),
    HomeScreen(),
    CartScreen(),
    InfoScreen(),
  ];
}
