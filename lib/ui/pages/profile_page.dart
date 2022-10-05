import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/controller/user_controller.dart';
import 'package:social_video/ui/pages/sign_in_page.dart';
import 'package:social_video/util/file_picker_utils.dart';
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
      title: Consumer<UserController>(
        builder: (context, userController, _) => Center(
          child: Text(
            userController.currentUser != null
                ? userController.currentUser!.customerName.toString()
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
        _profileImage,
        const SizedBox(height: 20),
        Consumer<AuthStateController>(
          builder: (context, stateController, _) => ElevatedButton(
            onPressed: () {
              stateController.signOut();
              stateController.loginState = ApplicationLoginState.emailAddress;
              context.read<UserController>().currentUser = null;
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

  Widget get _profileImage {
    return Consumer<UserController>(
      builder: (context, userController, _) => Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(500)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: userController.pickedImageFile != null
                  ? Image.file(
                      userController.pickedImageFile!,
                      width: 90,
                      height: 90,
                      fit: BoxFit.fitWidth,
                    )
                  : userController.currentUser?.profileUrl != null
                      ? Image.network(
                          userController.currentUser!.profileUrl!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/images/no_image.jpg',
                            width: 90,
                            height: 90,
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      : Image.asset(
                          'assets/images/no_image.jpg',
                          width: 90,
                          height: 90,
                          fit: BoxFit.fitWidth,
                        ),
            ),
            Positioned(
              bottom: -1,
              right: -1,
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(500),
                      bottomRight: Radius.circular(500)),
                ),
                child: IconButton(
                  onPressed: () async {
                    if (userController.pickedImageFile != null) {
                      String? result =
                          await userController.uploadPicture(context);
                      if (result != null && result.isNotEmpty) {
                        await UserController.updateUserByProfileUrl(result);
                        userController.pickedImageFile = null;
                        if (userController.currentUser != null) {
                          userController.currentUser!.profileUrl = result;
                        }
                      }
                    } else {
                      final File? file = await FilePickerUtils.pickFile(
                          ['jpg', 'png', 'jpeg']);
                      if (file == null) {
                        return;
                      }
                      userController.pickedImageFile = file;
                    }
                  },
                  icon: Icon(userController.pickedImageFile != null
                      ? Icons.check
                      : Icons.edit),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
