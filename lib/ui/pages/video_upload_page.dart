import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_video/ui/pages/video_upload_detail_page.dart';
import 'package:social_video/util/navigator_utils.dart';

import '../../util/screen_size_utils.dart';
import '../widget/video_player_item.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key, required this.videoFile});

  final File videoFile;

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _videoPlayerItem,
            const SizedBox(height: 10),
            _pickFileButton,
          ],
        ),
      ),
    );
  }

  Expanded get _videoPlayerItem {
    return Expanded(
        child: VideoPlayerItem(
      key: Key(DateTime.now().toString()),
      videoUrl: null,
      videoFile: widget.videoFile,
      height: ScreenSizeUtil.screenHeight(context) - 150,
    ));
  }

  Container get _pickFileButton {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () async {
          NavigatorUtils.push(
              context, VideoUpdateDetailPage(videoFile: widget.videoFile));
        },
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 17),
            backgroundColor: Colors.pink[400],
            fixedSize: const Size(150, 50)),
        child: const Text('Next'),
      ),
    );
  }
}