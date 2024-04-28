import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/login_page.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: kcontentColor,
            padding: const EdgeInsets.all(15),
          ),
          iconSize: 30,
          icon: const Icon(
            Ionicons.notifications,
            color: Colors.yellow,
          ),
        ),
        IconButton(
          onPressed: () async {
            // Xóa token và chuyển về trang đăng nhập
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          style: IconButton.styleFrom(
            backgroundColor: kcontentColor,
            padding: const EdgeInsets.all(15),
          ),
          iconSize: 30,
          icon: const Icon(
            Ionicons.exit,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
