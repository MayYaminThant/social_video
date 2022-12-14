import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/controller/video_controller.dart';
import 'package:social_video/ui/widget/video_player_item.dart';

import '../../util/common_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    CommonUtils.doInFuture(
      () {
        context.read<VideoController>().getAllVideoList();
      },
    );
    return Scaffold(
      body: _body,
    );
  }

  Widget get _body {
    return Consumer<VideoController>(
      builder: (_, controller, __) => PageView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.allVideoList.length,
        itemBuilder: ((context, index) {
          log("VideoUrl : ${controller.allVideoList.elementAt(index).videoUrl}");
          return VideoPlayerItem(
            key: Key(DateTime.now().toString()),
            video: controller.allVideoList.elementAt(index),
            videoFile: null,
          );
        }),
      ),
    );
  }
}
