import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:social_video/common/common_widget.dart';
import 'package:social_video/controller/user_controller.dart';
import 'package:social_video/controller/video_controller.dart';
import 'package:social_video/model/my_user.dart';
import 'package:social_video/ui/pages/main_page.dart';
import 'package:social_video/util/navigator_utils.dart';
import 'package:social_video/util/screen_size_utils.dart';

import '../../controller/video_state_controller.dart';

class VideoUpdateDetailPage extends StatefulWidget {
  const VideoUpdateDetailPage(
      {super.key, required this.videoFile, required this.videoBytes});
  final File videoFile;
  final Uint8List? videoBytes;

  @override
  State<VideoUpdateDetailPage> createState() => _VideoUpdateDetailPageState();
}

class _VideoUpdateDetailPageState extends State<VideoUpdateDetailPage> {
  final TextEditingController _captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: CircularProgressIndicator(),
        ),
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        duration: const Duration(seconds: 2),
        child: Scaffold(
          appBar: _appBar,
          body: _body,
          backgroundColor: Colors.white,
        ),
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
      title: const Text(
        'Post',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  get _body {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: ScreenSizeUtil.screenWidth(context) - 20,
                  child: TextField(
                    controller: _captionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Describe your post, add hashtags.'),
                  ),
                ),
              ),
              if (widget.videoBytes != null)
                Image.memory(
                  widget.videoBytes!,
                  width: 100,
                  height: 100,
                ),
            ],
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () async {
              MyUser? user = context.read<UserController>().currentUser;
              if (user == null) {
                return;
              }
              context.loaderOverlay.show();
              VideoController.uploadPost(
                  context, widget.videoFile, _captionController.text, user,
                  successCallback: () {
                context.loaderOverlay.hide();
                NavigatorUtils.pushAndRemoveUntil(context, const MainPage());
              }, failureCallback: () {
                context.loaderOverlay.hide();
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
