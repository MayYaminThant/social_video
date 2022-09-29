import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_video/util/screen_size_utils.dart';
import 'package:video_player/video_player.dart';

import 'video_control_overlay.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem(
      {super.key, required this.videoUrl, required this.videoFile, this.height})
      : assert(videoUrl != null || videoFile != null);
  final String? videoUrl;
  final File? videoFile;
  final double? height;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();

  // static void destroyVideoController() {videoCon}
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();

    videoController = widget.videoUrl != null
        ? VideoPlayerController.network(widget.videoUrl!)
        : VideoPlayerController.file(widget.videoFile!);

    videoController.addListener(() {
      setState(() {});
    });
    videoController.setLooping(true);
    videoController.initialize().then((_) => setState(() {}));
    videoController.play();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? ScreenSizeUtil.screenHeight(context),
      width: ScreenSizeUtil.screenWidth(context),
      child: AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(videoController),
            ControlsOverlay(controller: videoController),
            VideoProgressIndicator(
              videoController,
              allowScrubbing: true,
              colors: const VideoProgressColors(playedColor: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  destroyVideoController() {
    videoController.dispose();
  }
}
