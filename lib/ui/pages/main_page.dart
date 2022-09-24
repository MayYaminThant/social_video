import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/controller/bottom_nav_controller.dart';
import 'package:social_video/ui/pages/profile_page.dart';
import 'package:social_video/ui/pages/sign_in_page.dart';
import 'package:social_video/ui/pages/upload_page.dart';

import '../../controller/user_auth_controller.dart';
import 'home_page.dart';

const bodyTags = [HomePage(), UploadPage(), ProfilePage()];

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future _refreshCallback() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Container(
          color: Colors.transparent,
          child: RefreshIndicator(
            onRefresh: _refreshCallback,
            backgroundColor: Colors.grey,
            color: Colors.white12,
            displacement: 165,
            strokeWidth: 3,
            child: GestureDetector(
              onTap: () {},
              child: Consumer<BottomNavController>(
                builder: (_, controller, __) =>
                    bodyTags.elementAt(controller.selectedIndex),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _bottomNavigationBar,
      ),
    );
  }

  Widget get _bottomNavigationBar {
    return Consumer<BottomNavController>(
      builder: (_, botController, __) => BottomNavigationBar(
        currentIndex: botController.selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: ((position) {
          botController.selectedIndex = position;
        }),
      ),
    );
  }
}
