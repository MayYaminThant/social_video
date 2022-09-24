import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/ui/pages/sign_in_page.dart';
import 'package:social_video/util/screen_size_utils.dart';

import '../../controller/user_auth_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }

  AppBar get _appBar {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Consumer<AuthStateController>(
        builder: (context, stateController, _) => Center(
          child: Text(
            stateController.currentUser != null
                ? stateController.currentUser!.displayName.toString()
                : '',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget get _body {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: ScreenSizeUtil.screenWidth(context), height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(500),
          child: Image.asset(
            'assets/images/flying-kite.jpg',
            width: 90,
            height: 90,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 20),
        Consumer<AuthStateController>(
          builder: (context, stateController, _) => ElevatedButton(
            onPressed: () {
              stateController.signOut();
              stateController.loginState = ApplicationLoginState.emailAddress;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (bContext) => const SignInPage()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black45),
            child: const Text('Log out'),
          ),
        ),
      ],
    );
  }
}
