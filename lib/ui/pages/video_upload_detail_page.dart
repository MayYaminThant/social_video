import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/common/common_widget.dart';
import 'package:social_video/controller/user_controller.dart';
import 'package:social_video/controller/video_controller.dart';
import 'package:social_video/model/my_user.dart';
import 'package:social_video/ui/pages/main_page.dart';
import 'package:social_video/util/navigator_utils.dart';

class VideoUpdateDetailPage extends StatefulWidget {
  const VideoUpdateDetailPage({super.key, required this.videoFile});
  final File videoFile;

  @override
  State<VideoUpdateDetailPage> createState() => _VideoUpdateDetailPageState();
}

class _VideoUpdateDetailPageState extends State<VideoUpdateDetailPage> {
  final TextEditingController _captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar,
        body: _body,
        backgroundColor: Colors.white,
      ),
    );
  }

  get _appBar {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Center(
        child: Text(
          'Post',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  get _body {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(widget.videoFile.path),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width - 20,
          child: TextField(
            controller: _captionController,
            maxLines: 3,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Describe your post, add hashtags.'),
          ),
        ),
        const Expanded(
          child: SizedBox(
            height: 10,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () async {
              MyUser? user = context.read<UserController>().currentUser;
              if (user == null) {
                return;
              }
              VideoController.uploadPost(
                  context, widget.videoFile, _captionController.text, user,
                  successCallback: () {
                NavigatorUtils.pushAndRemoveUntil(context, const MainPage());
              }, failureCallback: () {
                showSimpleSnackBar(context, 'Upload post failed!', Colors.red);
              });
            },
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 17),
                backgroundColor: Colors.pink[400],
                fixedSize: const Size(130, 50)),
            child: Row(
              children: const [
                Icon(
                  Icons.arrow_upward,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
