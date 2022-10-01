import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/controller/bottom_nav_controller.dart';
import 'package:social_video/ui/pages/profile_page.dart';
import 'package:social_video/ui/pages/add_video_page.dart';
import 'package:social_video/util/common_utils.dart';
import 'package:social_video/util/navigator_utils.dart';

import '../../controller/user_auth_controller.dart';
import '../../controller/user_controller.dart';
import 'home_page.dart';

const bodyTags = [HomePage(), AddVideoPage(), ProfilePage()];

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
    CommonUtils.doInFuture(() async {
      context.read<UserController>().currentUser =
          await UserController.getAUser(
              context.read<AuthStateController>().currentUser!.uid);
    });
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
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: ((position) {
          if (position == 1) {
            NavigatorUtils.push(context, const AddVideoPage());
            setState(() {});
          } else {
            botController.selectedIndex = position;
          }
        }),
        backgroundColor: Colors.white,
      ),
    );
  }
}
